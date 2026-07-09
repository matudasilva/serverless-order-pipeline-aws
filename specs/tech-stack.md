# Technology Stack

> Referenced by `specs/constitution.md` §2. Any change here must stay
> consistent with the constitution's conventions (§3) — in particular, the
> `required_version` and `hashicorp/aws` provider pins declared here must
> match what `envs/dev/providers.tf` and the CI workflow actually declare.

## Stack

| Component | Version / value | Notes |
|---|---|---|
| Terraform | `>= 1.9` | Consistent pin across `providers.tf` and CI. |
| AWS provider (`hashicorp/aws`) | `~> 5.x` | May be refined in `core-pipeline`'s plan if a narrower range is justified. |
| Cloud | AWS, region `us-east-1` | Single region; no multi-region parameterization. |
| Lambda runtime | Python 3.12 | Upgraded from the original exercise's 3.9. |
| CI | GitHub Actions | Scope: `fmt -check` + `validate` only (see constitution §3, "CI"). |

## Cost constraint

Resources must stay within (or very close to) the AWS free tier. No
resources that generate significant fixed cost (e.g. NAT Gateways,
always-on instances) are provisioned.

## Security posture

Least privilege by design — see `specs/constitution.md` §3, "IAM and
security".
