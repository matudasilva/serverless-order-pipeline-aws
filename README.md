# serverless-order-pipeline-aws

> Portfolio in progress — a serverless PoC on AWS (API Gateway → SQS →
> Lambda → DynamoDB → Streams → Lambda → SNS) implemented with Terraform
> following Spec-Driven Development (SDD) with a coding agent.

This README will be completed in the final phase of the project (see
`specs/roadmap.md`). For now, the entry points to understand the project
are:

- [`specs/constitution.md`](specs/constitution.md) — mission and
  conventions (Phase 1).
- [`specs/tech-stack.md`](specs/tech-stack.md) — technology stack and
  version pins (Phase 1).
- [`specs/roadmap.md`](specs/roadmap.md) — planned features (Phase 1).
- [`specs/features/`](specs/features/) — spec/plan/tasks for each feature.
- [`docs/reference/original-lambdas.md`](docs/reference/original-lambdas.md) —
  baseline code from the original exercise.

## Repo structure

```
specs/               # Constitution, roadmap, and per-feature specs/plans/tasks (SDD)
envs/dev/            # Terraform stack for the dev environment
modules/             # Reusable Terraform modules (only where justified)
src/lambdas/         # Python code for the Lambdas
docs/diagrams/       # Architecture and workflow diagrams (Excalidraw)
docs/reference/      # Reference material (original exercise baseline)
.github/workflows/   # CI (fmt + validate, no apply)
```
