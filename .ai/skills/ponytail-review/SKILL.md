---
name: ponytail-review
description: >
  Code review focused exclusively on over-engineering. Finds what to delete:
  reinvented stdlib/Rails core, unneeded gems, speculative abstractions, dead
  flexibility. One line per finding: location, what to cut, what replaces it.
  Use when the user says "review for over-engineering", "what can we delete",
  "is this over-engineered", "simplify review", or invokes /ponytail-review.
  Complements correctness-focused review — this one only hunts complexity.
---

# ponytail-review

Reviews a diff for unnecessary complexity. One line per finding: location, what to cut, what replaces it. The diff's best outcome is getting shorter. Governed by `.ai/standards/minimalism.md`.

## Format

`L<line>: <tag> <what>. <replacement>.`, or `<file>:L<line>: ...` for multi-file diffs.

Tags:

- `delete:` dead code, unused flexibility, speculative feature. Replacement: nothing.
- `stdlib:` hand-rolled thing the stdlib or Rails core ships. Name it (`ActiveSupport`, `enum`, `delegate`, `Enumerable#…`).
- `native:` gem or code doing what the platform/DB already does. Name the feature (`<input type="date">`, unique index, DB default).
- `yagni:` abstraction with one implementation, config nobody sets, layer/service with one caller.
- `shrink:` same logic, fewer lines. Show the shorter form.

## Examples

✅ `app/models/user.rb:L12-38: stdlib: 27-line email validator. use Devise's validatable or a format check; real validation is the confirmation mail.`

✅ `Gemfile:L40: native: gem added for one date format. Rails I18n.l / strftime, 0 deps.`

✅ `app/repositories/order_repo.rb:L1-44: yagni: AbstractRepository with one implementation. Inline into the model until a second one exists.`

✅ `app/services/save_user.rb:L52-71: delete: service wrapping a single `user.save!`. Call it directly.`

## Scoring

End with the only metric that matters: `net: -<N> lines possible.` If nothing to cut: `Lean already. Ship.`

## Boundaries

Scope: over-engineering and complexity only. Correctness bugs, security holes, and performance are out of scope — route them to QA / `security-audit`. A single smoke test or focused RSpec example is the ponytail minimum, never flag it for deletion. Lists fixes, does not apply them.
