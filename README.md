# serverless-order-pipeline-aws

> Portfolio en construcción — PoC serverless en AWS (API Gateway → SQS →
> Lambda → DynamoDB → Streams → Lambda → SNS) implementado con Terraform
> siguiendo Spec-Driven Development (SDD) con un agente de código.

Este README se completa en la fase final del proyecto (ver
`specs/roadmap.md`). Por ahora, el punto de entrada para entender el proyecto
es:

- [`specs/constitution.md`](specs/constitution.md) — misión, stack y
  convenciones (Fase 1).
- [`specs/roadmap.md`](specs/roadmap.md) — features planificadas (Fase 1).
- [`specs/features/`](specs/features/) — spec/plan/tasks de cada feature.
- [`docs/reference/original-lambdas.md`](docs/reference/original-lambdas.md) —
  código baseline del ejercicio original.

## Estructura del repo

```
specs/                  # Constitución, roadmap y specs/plans/tasks por feature (SDD)
envs/dev/                # Stack de Terraform del entorno dev
modules/                 # Módulos Terraform reutilizables (solo si aplica)
src/lambdas/              # Código Python de las Lambdas
docs/diagrams/            # Diagramas de arquitectura y de workflow (Excalidraw)
docs/reference/            # Material de referencia (baseline del ejercicio)
.github/workflows/          # CI (fmt + validate, sin apply)
```
