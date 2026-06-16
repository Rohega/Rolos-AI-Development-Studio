# Testing Standards

## Pyramid

1. **Unit** — models, services, parsers (fast, isolated)
2. **Integration** — API endpoints, job execution with test DB
3. **System/E2E** — Capybara for critical user journeys (few, stable)

## RSpec Conventions

- File: `spec/models/invoice_spec.rb`
- Describe blocks match class/method under test
- One expectation per example when practical
- Use factories (FactoryBot), not fixtures for dynamic data

## Coverage Expectations

| Layer | Minimum |
|-------|---------|
| Models / services | Critical paths covered |
| API endpoints | Happy path + auth failure + validation errors |
| Jobs | Success + retryable failure |
| Migrations | Rollback tested on copy of schema |

## CI

- Full suite on every PR to main
- Fail build on test failure — no `pending` without ticket reference

## Evidence

- QA test plan maps stories to automated vs manual tests
- Bug fixes include regression spec when feasible

## References

- Agent: `.ai/agents/qa-engineer.yaml`
- Skills: `qa-plan`, `release-checklist`
