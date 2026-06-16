# Rails Development Standards

## Conventions

- Follow Rails conventions over custom abstractions
- Use standard MVC; extract to service objects when a controller action exceeds ~15 lines or logic is reused
- Prefer `app/services/`, `app/jobs/`, `app/policies/` over lib/ unless truly framework-agnostic
- Use strong parameters in all controllers
- Authorization via Pundit or equivalent — every mutating action checked

## Models

- Validations in models; complex cross-model rules in service objects
- Use `enum` with prefix/suffix for status fields
- Scopes for reusable query fragments; avoid class methods that hide side effects
- Callbacks sparingly — prefer explicit service calls for multi-step workflows

## Controllers & APIs

- Thin controllers: load, authorize, delegate, respond
- JSON APIs use consistent serializer layer (Blueprinter, Alba, or jbuilder per ADR)
- Version APIs in URL path when breaking changes expected (`/api/v1/`)

## Background Jobs

- Idempotent jobs with explicit retry and discard policies
- Pass IDs, not ActiveRecord objects, to jobs
- Long-running work never blocks HTTP requests

## Configuration

- Environment-specific config in credentials or ENV — never hardcode secrets
- Feature flags for risky rollouts when appropriate

## References

- Agent: `.ai/agents/backend-rails-developer.yaml`
- Skills: `review-rails-models`, `create-api-endpoints`
