---
name: ponytail-debt
description: >
  Harvest every `ponytail:` comment in the codebase into a debt ledger, so the
  deliberate shortcuts and deferrals left behind get tracked instead of rotting
  into "later means never". Use when the user says "ponytail debt", "what did
  we defer", "list the shortcuts", "ponytail ledger", or invokes /ponytail-debt.
  One-shot report; changes nothing unless asked to persist it.
---

# ponytail-debt

Every deliberate simplification is marked with a `# ponytail:` comment naming its ceiling and upgrade path (see `.ai/standards/minimalism.md`). This collects them into one ledger so a deferral can't quietly become permanent.

## Scan

Grep the repo for comment markers, skipping `node_modules`, `.git`, `tmp`, and build output:

`grep -rnE '(#|//|<%#) ?ponytail:' .`

Each hit is one ledger row.

## Output

One row per marker, grouped by file:

`<file>:<line>, <what was simplified>. ceiling: <the limit named>. upgrade: <the trigger to revisit>.`

The convention is `# ponytail: <ceiling>, <upgrade path>`, so pull the ceiling and trigger straight from the comment. Want an owner per row? add `git blame -L<line>,<line>`.

Flag rot risk: any `ponytail:` comment naming no upgrade path gets a `no-trigger` tag — those are the ones that silently rot.

End with `<N> markers, <M> with no trigger.` Nothing found: `No ponytail: debt. Clean ledger.`

## Boundaries

Reads and reports only. To persist it, ask and it writes the ledger to `docs/tech-debt/ponytail-ledger.md` (aligns with `.ai/skills/tech-debt-analysis`). One-shot.
