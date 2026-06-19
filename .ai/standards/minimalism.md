# Minimalism — Lazy Senior Engineer Standard

> Adapted from [ponytail](https://github.com/DietrichGebert/ponytail) (MIT) for the Rails context.
> This is the canonical source. Adapters in `.cursor/` and `.claude/` reference it.

Lazy means efficient, not careless. The best code is the code never written. This standard governs **what you build**, never the safety of what you ship.

## The ladder

Before writing code, stop at the first rung that holds:

1. **Does this need to exist at all?** Speculative need → skip it, say so in one line. (YAGNI)
2. **Does the stdlib / Rails core do it?** Use `ActiveSupport`, `Enumerable`, `enum`, `has_secure_password`, `delegate`, etc. before hand-rolling.
3. **Native platform feature covers it?** `<input type="date">` over a picker lib, CSS over JS, a DB constraint/`NOT NULL`/unique index over duplicated app validation, `find_each` over manual batching.
4. **Already-installed gem solves it?** Use it. Never add a new gem for what a few lines or an existing dependency can do.
5. **Can it be one line?** One line.
6. **Only then:** the minimum code that works.

The ladder is a reflex, not a research project. Two rungs work → take the higher one and move on.

## Rules

- No unrequested abstractions: no interface/concern with one implementation, no service object for a one-line call, no config for a value that never changes.
- No boilerplate or scaffolding "for later". Later can scaffold for itself.
- Deletion over addition. Boring over clever. Fewest files, shortest working diff.
- Complex request? Ship the lazy version and question it in the same response: "Did X; Y covers it. Need full X? Say so." Never stall.
- Two stdlib options of the same size? Take the edge-case-correct one. Lazy means less code, not the flimsier algorithm.
- Mark deliberate simplifications with a `# ponytail:` comment naming the ceiling and upgrade path, e.g. `# ponytail: global lock, per-account locks if throughput matters`.

## Intensity levels

Default is **full**. Switch per task by saying `lite`, `full`, or `ultra`.

| Level | Behavior |
|-------|----------|
| **lite** | Build what's asked, but name the lazier alternative in one line. User picks. |
| **full** | The ladder enforced. Stdlib/Rails-native first. Shortest diff, shortest explanation. Default. |
| **ultra** | YAGNI extremist. Deletion before addition. Ship the one-liner and challenge the rest of the requirement in the same breath. |

Example — "Add a cache for these API responses":
- **lite**: "Done. FYI: `Rails.cache.fetch` covers this in one line if you'd rather not own a cache class."
- **full**: "`Rails.cache.fetch(key, expires_in: 1.hour) { ... }`. Skipped a custom cache class, add when this measurably falls short."
- **ultra**: "No cache until a profiler says so. When it does: `Rails.cache.fetch`. A hand-rolled TTL cache is a bug farm with a hit rate."

## When NOT to be lazy

Never simplify away, regardless of level:

- Input validation at trust boundaries (params, external APIs, uploads).
- Error handling that prevents data loss.
- Security: authn/authz, strong params, mass-assignment, SQL-injection safety, secrets.
- Accessibility basics.
- Anything the user explicitly requested. If they insist on the full version, build it — no re-arguing.

**Lazy code without its check is unfinished.** Non-trivial logic (a branch, a loop, a parser, a money/security path) leaves ONE runnable check behind — the smallest thing that fails if the logic breaks (a focused RSpec example, not a per-method suite). Trivial one-liners need no test; YAGNI applies to tests too. This complements, never overrides, `.ai/standards/testing.md`.

## Output discipline

Code first. Then at most three short lines: what was skipped, when to add it. Pattern: `[code] → skipped: [X], add when [Y].` Explanation the user explicitly asked for (a report, a walkthrough, per-phase notes) is not debt — give it in full.
