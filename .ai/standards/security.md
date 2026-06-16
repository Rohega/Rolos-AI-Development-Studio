# Security Standards

## Application (Rails)

- CSRF protection enabled for session-based apps
- Strong parameters on all mass assignment
- Authorization on every mutating action (Pundit or equivalent)
- SQL injection prevention via parameterized queries / ActiveRecord
- XSS prevention: escape output, CSP headers in production
- Secure headers: HSTS, X-Frame-Options, X-Content-Type-Options

## Authentication & Sessions

- bcrypt or Argon2 for password hashing
- Session timeout and secure cookie flags (`httponly`, `secure`, `same_site`)
- MFA for admin access when handling sensitive data

## AWS

- No long-lived access keys on EC2 — use instance profiles
- S3 bucket policies deny public access by default
- Textract and S3 access scoped to required prefixes
- CloudTrail enabled for audit

## Secrets

- Never commit secrets, API keys, or credentials
- Rotate secrets on compromise or employee departure
- `.env` files gitignored; use credentials/parameter store

## Dependencies

- Run `bundle audit` / Dependabot before release
- Patch critical CVEs before production deploy

## References

- Agent: `.ai/agents/security-reviewer.yaml`
- Skill: `security-audit`
