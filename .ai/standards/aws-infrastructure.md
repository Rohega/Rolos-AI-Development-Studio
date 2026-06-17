# AWS Infrastructure Standards

## Principles

- Infrastructure as Code for all resources
- Least-privilege IAM — one role per service function
- Encrypt at rest (S3, RDS, EBS) and in transit (TLS 1.2+)
- Tag all resources: `Environment`, `Project`, `Owner`, `CostCenter`

## Common Services

| Service | Use Case |
|---------|----------|
| EC2 | Application servers (Puma behind nginx) |
| RDS MySQL | Primary application database |
| S3 | Document and asset storage |
| IAM | Service roles, instance profiles |
| Parameter Store / Secrets Manager | Application secrets |

## Networking

- Application servers in private subnets where possible
- Security groups: deny by default, explicit ingress rules
- No public RDS endpoints without VPN/bastion justification

## Deployments

- Staging must mirror production topology
- Health checks on every load-balanced target
- Deployment plan required (see `.ai/templates/deployment-plan.md`)

## References

- Agent: `.ai/agents/aws-devops-engineer.yaml`
- Skills: `aws-deploy-plan`, `nginx-puma-review`, `capistrano-review`
