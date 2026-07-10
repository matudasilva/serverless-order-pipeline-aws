resource "aws_api_gateway_rest_api" "poc_api" {
  name = "POC-API"
}

resource "aws_api_gateway_resource" "orders" {
  rest_api_id = aws_api_gateway_rest_api.poc_api.id
  parent_id   = aws_api_gateway_rest_api.poc_api.root_resource_id
  path_part   = "orders"
}

resource "aws_api_gateway_method" "post_orders" {
  rest_api_id   = aws_api_gateway_rest_api.poc_api.id
  resource_id   = aws_api_gateway_resource.orders.id
  http_method   = "POST"
  authorization = "NONE"
}

data "aws_iam_policy_document" "api_gateway_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "api_gateway_sqs" {
  name               = "poc-api-gateway-sqs-role"
  assume_role_policy = data.aws_iam_policy_document.api_gateway_assume.json
}

data "aws_iam_policy_document" "api_gateway_sqs" {
  statement {
    sid       = "SendToPocQueue"
    effect    = "Allow"
    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.poc_queue.arn]
  }
}

resource "aws_iam_role_policy" "api_gateway_sqs" {
  name   = "poc-api-gateway-sqs-policy"
  role   = aws_iam_role.api_gateway_sqs.id
  policy = data.aws_iam_policy_document.api_gateway_sqs.json
}

resource "aws_api_gateway_integration" "post_orders" {
  rest_api_id             = aws_api_gateway_rest_api.poc_api.id
  resource_id             = aws_api_gateway_resource.orders.id
  http_method             = aws_api_gateway_method.post_orders.http_method
  type                    = "AWS"
  integration_http_method = "POST"
  credentials             = aws_iam_role.api_gateway_sqs.arn
  uri                     = "arn:aws:apigateway:us-east-1:sqs:path/${data.aws_caller_identity.current.account_id}/${aws_sqs_queue.poc_queue.name}"
  passthrough_behavior    = "NEVER"

  request_parameters = {
    "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
  }

  request_templates = {
    "application/json" = "Action=SendMessage&MessageBody=$input.body"
  }
}

resource "aws_api_gateway_method_response" "post_orders_200" {
  rest_api_id = aws_api_gateway_rest_api.poc_api.id
  resource_id = aws_api_gateway_resource.orders.id
  http_method = aws_api_gateway_method.post_orders.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_method_response" "post_orders_400" {
  rest_api_id = aws_api_gateway_rest_api.poc_api.id
  resource_id = aws_api_gateway_resource.orders.id
  http_method = aws_api_gateway_method.post_orders.http_method
  status_code = "400"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_method_response" "post_orders_500" {
  rest_api_id = aws_api_gateway_rest_api.poc_api.id
  resource_id = aws_api_gateway_resource.orders.id
  http_method = aws_api_gateway_method.post_orders.http_method
  status_code = "500"

  response_models = {
    "application/json" = "Empty"
  }
}

# ADR-8: the 200 response parses SQS's raw XML into JSON instead of
# passing it through, and — because 200 is now explicitly mapped — 400
# and 500 must be explicitly mapped too, or SQS errors would silently
# surface as 200 with an XML error body.
resource "aws_api_gateway_integration_response" "post_orders_200" {
  rest_api_id = aws_api_gateway_rest_api.poc_api.id
  resource_id = aws_api_gateway_resource.orders.id
  http_method = aws_api_gateway_method.post_orders.http_method
  status_code = aws_api_gateway_method_response.post_orders_200.status_code

  selection_pattern = "2\\d{2}"

  response_templates = {
    "application/json" = <<-EOT
      {
        "messageId": "$util.parseXml($input.body).SendMessageResponse.SendMessageResult.MessageId",
        "status": "queued"
      }
    EOT
  }

  depends_on = [aws_api_gateway_integration.post_orders]
}

resource "aws_api_gateway_integration_response" "post_orders_400" {
  rest_api_id = aws_api_gateway_rest_api.poc_api.id
  resource_id = aws_api_gateway_resource.orders.id
  http_method = aws_api_gateway_method.post_orders.http_method
  status_code = aws_api_gateway_method_response.post_orders_400.status_code

  selection_pattern = "4\\d{2}"

  response_templates = {
    "application/json" = <<-EOT
      {
        "status": "error",
        "message": "The request could not be queued. Check the request body and try again."
      }
    EOT
  }

  depends_on = [aws_api_gateway_integration.post_orders]
}

resource "aws_api_gateway_integration_response" "post_orders_500" {
  rest_api_id = aws_api_gateway_rest_api.poc_api.id
  resource_id = aws_api_gateway_resource.orders.id
  http_method = aws_api_gateway_method.post_orders.http_method
  status_code = aws_api_gateway_method_response.post_orders_500.status_code

  selection_pattern = "5\\d{2}"

  response_templates = {
    "application/json" = <<-EOT
      {
        "status": "error",
        "message": "An unexpected error occurred while queueing the request."
      }
    EOT
  }

  depends_on = [aws_api_gateway_integration.post_orders]
}
