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

## Language Convention

English is the canonical language. When a document also needs a Spanish
version, keep both in the **same file** (do not rename files — this avoids
breaking cross-references) using this layout:

```markdown
> Language: English | [Español](#versión-en-español)

# Title (English)

...canonical English content...

---

## Versión en español

...original Spanish content, kept intact...
```

- English first (canonical), Spanish below under a stable anchor.
- New documents should be written in English; add the Spanish block only when
  the audience needs it.
- Code blocks, commands, and file paths are shared — do not translate them.

## Maintenance

- Update docs in same PR as code when behavior changes
- Quarterly review of runbooks for accuracy

## References

- Agent: `.ai/agents/documentation-writer.yaml`
- Skill: `document-module`
- Template: `.ai/templates/technical-design-document.md`
