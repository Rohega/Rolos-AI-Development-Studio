# [Language/Framework] Development Standards

> Stack: **[stack-id]**. Copy this folder to `.ai/standards/stacks/<stack-id>/` and fill in
> every section. Keep agnostic rules (security, testing principles, api-design, git-workflow)
> in `.ai/standards/` — only put stack-specific guidance here.

## Conventions

- [Naming, project layout, idiomatic style for this language/framework]
- [When to extract modules/services vs. keep inline]
- [Input validation and authorization approach]

## Project Structure

- [Where domain code, jobs/background work, and adapters live]
- [Module/package boundaries]

## APIs / Interfaces

- [How endpoints/handlers are defined]
- [Serialization and versioning approach]

## Background / Async Work

- [Queue/worker mechanism]
- [Idempotency and retry policy]

## Configuration

- [Config and secrets handling — never hardcode secrets]

## Tooling

- Tests: [test framework] (agnostic principles in `.ai/standards/testing.md`)
- Lint/format: [linter/formatter]
- Dependencies: [package manager + audit tool]
- Build/run: [build and run commands]

## References

- Agent: `.ai/agents/stacks/<stack-id>/backend-developer.yaml`
- Cursor rule: `.cursor/rules/<stack-id>.mdc`
- Skills: [stack-specific review/scaffolding skills, if any]
