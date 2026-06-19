---
name: ponytail-audit
description: >
  Whole-repo audit for over-engineering. Like ponytail-review, but scans the
  entire codebase instead of a diff: a ranked list of what to delete, simplify,
  or replace with stdlib/Rails-native equivalents. Use when the user says
  "audit this codebase", "audit for over-engineering", "what can I delete from
  this repo", "find bloat", or invokes /ponytail-audit. One-shot report, does
  not apply fixes.
---

# ponytail-audit

`ponytail-review`, repo-wide. Scan the whole tree instead of a diff. Rank findings biggest cut first. Governed by `.ai/standards/minimalism.md`.

## Tags

Same as `ponytail-review`: `delete:`, `stdlib:`, `native:`, `yagni:`, `shrink:`.

## Hunt (Rails-flavored)

- Gems the stdlib/Rails core or the DB already cover.
- Single-implementation concerns, service objects that only wrap one model call.
- Custom validators reinventing `validates`, format helpers reinventing I18n.
- App-level uniqueness/presence with no matching DB constraint (and vice-versa: duplicated checks).
- Dead feature flags, unused config, hand-rolled stdlib (`Enumerable`, `ActiveSupport`).

## Output

One line per finding, ranked: `<tag> <what to cut>. <replacement>. [path]`. End with `net: -<N> lines, -<M> gems possible.` Nothing to cut: `Lean already. Ship.`

## Boundaries

Scope: over-engineering and complexity only. Correctness, security, and performance go to a normal review / `security-audit` pass. Lists findings, applies nothing. One-shot.
