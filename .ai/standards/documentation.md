# Documentation Standards

## What to Document

| Artifact | Location | When |
|----------|----------|------|
| Module overview | `docs/modules/<name>.md` | New feature area |
| ADR | `docs/architecture/adr-NNNN-*.md` | Significant technical decision |
| API | `docs/api/` or OpenAPI | Public or partner APIs |
| Runbook | `docs/runbooks/` | Deploy, incident, integration ops |
| Feature spec | `docs/specs/` | Before implementation |

## Style

- Clear headings, short paragraphs
- Code examples tested or marked `# illustrative`
- Link to ADRs instead of duplicating rationale
- Date and author on runbooks

## Maintenance

- Update docs in same PR as code when behavior changes
- Quarterly review of runbooks for accuracy

## References

- Agent: `.ai/agents/documentation-writer.yaml`
- Skill: `document-module`
- Template: `.ai/templates/technical-design-document.md`
