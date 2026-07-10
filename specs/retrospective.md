# Retrospective

> Written at the close of Phase 5, reflecting on how Spec-Driven
> Development actually played out across this repo's five phases. This
> feeds future iterations of the `spec-feature` skill and the process
> itself — it's not a postmortem of the product, it's a postmortem of the
> workflow.

## What worked

- **The approval gate held.** Across `core-pipeline`, `api-ingestion`,
  and `diagrams`, no infrastructure code was written before `spec.md` and
  `plan.md` were explicitly approved — including two rounds of real
  design review feedback (`core-pipeline`'s DLQ/IAM fixes,
  `api-ingestion`'s `/orders` path rejection and response-mapping
  additions) that changed the actual implementation, not just the
  documents. The gate wasn't ceremonial.
- **ADRs surfaced real AWS edge cases before they became surprises.**
  Writing "why" down (e.g., why `dynamodb:ListStreams` can't be scoped to
  a single stream ARN, why the CloudWatch role needs a custom policy
  instead of AWS's managed one) forced a level of IAM precision that
  would likely have been skipped under time pressure without the ADR
  requirement.
- **The mid-project "Review summary" convention paid for itself.** After
  `core-pipeline`'s spec/plan turned out longer than the architect's
  review bandwidth needed, adding a mandatory ≤10-line summary block (and
  retrofitting it) measurably shortened the feedback loop for
  `api-ingestion` and `diagrams`.
- **`specs/tech-stack.md` as a single source of truth avoided drift.**
  Splitting it out of the constitution meant version pins only needed
  updating in one place (e.g., adding the `hashicorp/archive` provider
  once ADR-5 introduced it) instead of two documents disagreeing.
- **One-task-one-commit made the history legible.** Every `tasks.md`
  checklist item became a reviewable, atomically revertible commit —
  useful during this retrospective itself, to reconstruct what actually
  happened versus what was planned.

## What I'd improve

- **The `diagrams` feature skipped a commit checkpoint.** `spec.md` and
  `tasks.md` were drafted and approved but never committed before
  implementation started — caught and fixed retroactively, but the skill
  should treat "commit the approved spec/plan/tasks" as its own explicit
  step, not something the agent is trusted to remember every time.
- **Diagram orientation should have been an acceptance criterion, not an
  afterthought.** Both diagrams were authored horizontally, reviewed,
  and only then rebuilt vertically once it became clear a wide image
  reads poorly in a README's column width. `spec.md` for a
  README-embedded artifact should ask about the target embedding context
  (and likely orientation) up front, rather than discovering it after a
  full implementation pass.
- **IAM correctness leaned on the architect's AWS expertise more than the
  process accounted for.** Several real gotchas —
  `sqs:ChangeMessageVisibility` needed by the SQS event source mapping,
  the CloudWatch log-group creation race, `ListStreams`' scoping ceiling
  — came from design review, not from the agent's first draft. A running
  "known least-privilege gotchas" checklist inside the `spec-feature`
  skill (grown over time, project to project) would catch more of these
  before the first review round instead of during it.
- **No artifact captures the actual `terraform plan` output.** Every
  feature's validation step ran `plan` and summarized it in conversation,
  but the raw output was never saved anywhere durable. For a portfolio
  meant to demonstrate auditability, attaching (or linking to) the actual
  plan output per feature would strengthen the "reviewer can verify this
  really works" story this repo is trying to tell.
