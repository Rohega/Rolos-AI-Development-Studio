# Modernization Plan: [System/Module]

**Status:** [Draft | Review | Approved]  
**Author:** [Documentation Writer / Rails Architect]  
**Date:** [YYYY-MM-DD]  
**Current state:** [Rails version, key gems, deploy target]  
**Target state:** [desired version/architecture]

---

## Goals

- [Business and technical outcomes — e.g. supportable upgrades, lower defect rate]

## Non-Goals

- [Explicitly out of scope to prevent scope creep]

## Current State Summary

[Link to the relevant `legacy-module-audit.md`(s). Summarize the biggest risks.]

## Inventory & Risk Register

| Item | Type (model/job/integration/gem) | Risk | Impact × Effort | Priority |
|------|----------------------------------|------|-----------------|----------|
| | | | | |

## Strangler Fig Sequencing

Order of incremental replacement (lowest risk / highest value first).

| Step | Boundary | Approach (flag, facade, adapter) | Rollback | Done when |
|------|----------|----------------------------------|----------|-----------|
| 1 | | | | |
| 2 | | | | |

## Characterization Test Plan

- [Seams to pin before refactor — see `.ai/standards/legacy-rails.md`]
- [Golden master / approval targets, if any]

## Rails Upgrade Path (if applicable)

| From → To | Blocking gems | Deprecations to clear | Validation |
|-----------|---------------|------------------------|------------|
| | | | |

## Milestones

| Milestone | Deliverable | Gate |
|-----------|-------------|------|
| M1 | | |
| M2 | | |

## Rollback & Safety

- Per-step rollback: [flag flip / revert / restore prior release]
- Data migration reversibility: [link to migration strategy]

## Open Questions

- [ ] 

## References

- Standard: `.ai/standards/legacy-rails.md`
- Workflow: `.ai/workflows/legacy-onboarding.yaml`
- Skills: `reverse-document-legacy`, `tech-debt-analysis`
