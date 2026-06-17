# Adding a Language Stack

The framework separates an **agnostic core** from **stack-specific** guidance so you can
support new languages without duplicating shared rules. Rails ships as the reference stack.

```text
.ai/standards/              # agnostic: collaboration, security, testing principles, api-design, …
.ai/standards/stacks/<id>/  # stack-specific standards (development.md, data layer, …)
.ai/agents/                 # agnostic roles: product-owner, code-reviewer, qa-engineer, …
.ai/agents/stacks/<id>/     # stack-specific roles: backend-developer, architect, …
```

What stays agnostic vs. what is per-stack:

| Agnostic (root) | Per-stack (`stacks/<id>/`) |
|-----------------|----------------------------|
| product-owner, code-reviewer, qa-engineer, security-reviewer, documentation-writer, release-manager, aws-devops-engineer | backend-developer, architect, frontend-developer, dba |
| collaboration, security, testing (principles), api-design, code-review, documentation, git-workflow, aws-infrastructure | development.md, data-layer standard (e.g. mysql.md) |

## Steps

Replace `<id>` with your stack id (e.g. `python`, `node`, `go`).

1. **Standard** — Copy `.ai/standards/stacks/_TEMPLATE/` to `.ai/standards/stacks/<id>/`
   and fill in `development.md` (conventions, structure, APIs, async, config, tooling).
   Add a data-layer standard if relevant.

2. **Agent(s)** — Copy `.ai/agents/stacks/_TEMPLATE/` to `.ai/agents/stacks/<id>/` and fill
   in `backend-developer.yaml` and `architect.yaml` (and any others). Point their
   `references:` at the standard from step 1.

3. **Skills** — Add stack-specific review/scaffolding skills under `.ai/skills/` if needed
   (mirror `review-rails-models`, `create-api-endpoints`). Reuse the agnostic ones otherwise.

4. **Cursor rule** — Copy `.cursor/rules/stack-template.mdc.example` to
   `.cursor/rules/<id>.mdc` (drop `.example`), set `globs` to the stack's file patterns
   (e.g. `**/*.py`), and point it at `.ai/standards/stacks/<id>/development.md`.

5. **Claude adapter** — Add a thin adapter in `.claude/agents/` whose
   **Canonical definition** points to the new `.ai/agents/stacks/<id>/...` YAML.

6. **Wire the workflow** — In `.ai/workflows/new-feature.yaml`, add a `stacks.<id>` entry
   mapping `architect`, `backend-developer`, `frontend-developer`, `standard`, and the
   `stack-review` / `deploy-review` skills. Set `stack: <id>` to make it the active stack.

7. **Update indices** — Add the stack to `.ai/standards/stacks/README.md` and mention it in
   `README.md` / `.ai/README.md` if you want it discoverable.

## Verify

- `.cursor/rules/<id>.mdc` activates on the stack's files (check `globs`).
- The Claude adapter resolves to an existing YAML under `.ai/agents/stacks/<id>/`.
- `new-feature.yaml` `stacks.<id>` resolves every role and skill it references.
