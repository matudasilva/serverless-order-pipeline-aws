# Baseline: código original del ejercicio

> Registro del punto de partida tal como fue provisto en el ejercicio
> "Building a Proof of Concept for a Serverless Solution" (AWS Architecting
> Solutions), consola AWS, Python 3.9. Este código NO se despliega tal cual:
> es la referencia sobre la cual la feature `core-pipeline` construye las
> mejoras descritas en `specs/features/core-pipeline/plan.md` (manejo de
> errores, logging estructurado, configuración vía variables de entorno,
> clientes boto3 fuera del handler, IAM least-privilege).

## Lambda 1 — POC-Lambda-1 (SQS → DynamoDB)

```python
import boto3, uuid

client = boto3.resource('dynamodb')
table = client.Table("orders")

def lambda_handler(event, context):
    for record in event['Records']:
        print("test")
        payload = record["body"]
        print(str(payload))
        table.put_item(Item={'orderID': str(uuid.uuid4()), 'order': payload})
```

## Lambda 2 — POC-Lambda-2 (DynamoDB Streams → SNS)

```python
import boto3, json

client = boto3.client('sns')

def lambda_handler(event, context):
    for record in event["Records"]:
        if record['eventName'] == 'INSERT':
            new_record = record['dynamodb']['NewImage']
            response = client.publish(
                TargetArn='<ARN del topic SNS, hardcodeado en el original>',
                Message=json.dumps({'default': json.dumps(new_record)}),
                MessageStructure='json'
            )
```

## Arquitectura original

```
Client → API Gateway (POST) → SQS → Lambda 1 → DynamoDB (orders)
                                                      │
                                                      ▼ (Streams, NEW_IMAGE)
                                                  Lambda 2 → SNS → Email
```

Región: us-east-1. Runtime original: Python 3.9 (actualizado a 3.12 en esta
implementación).
