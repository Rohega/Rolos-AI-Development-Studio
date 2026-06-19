# Legacy Module Audit: [Module/Domain]

**Status:** [Draft | Review | Approved]  
**Author:** [Documentation Writer]  
**Date:** [YYYY-MM-DD]  
**Rails version:** [e.g. 6.1.7]  
**Audit scope:** [paths, e.g. `app/models/billing/**`, `app/jobs/billing/**`]

---

## Purpose

[Why this module is being audited — onboarding, bug hotspot, modernization candidate.]

## Overview

[One paragraph: what this module does in business terms and where it sits in the app.]

## Inventory

### Models

| Model | Table | Key associations | Notes / concerns |
|-------|-------|------------------|------------------|
| | | | |

### Routes / Controllers

| Route | Controller#action | Auth | Notes |
|-------|-------------------|------|-------|
| | | | |

### Background Jobs

| Job | Queue | Trigger | Idempotent? | Notes |
|-----|-------|---------|-------------|-------|
| | | | | |

### Services / POROs

| Class | Responsibility | Location | Concerns |
|-------|----------------|----------|----------|
| | | `app/services/...` | |

### External Integrations

| Integration | Direction | Auth/secret location | Failure handling |
|-------------|-----------|----------------------|------------------|
| | | | |

## Dependencies

- **Inbound** (who calls this module): 
- **Outbound** (what this module depends on): 
- **Gems pinning behavior/versions:** 

## Test Coverage

| Area | Coverage today | Gap / risk |
|------|----------------|------------|
| Models | | |
| Controllers/requests | | |
| Jobs | | |
| Integrations | | |

## Risks & Hotspots

| Risk | Severity (Low/Med/High) | Evidence | Impact |
|------|-------------------------|----------|--------|
| | | | |

## Technical Debt

- [Entry — link to `docs/tech-debt/register.md`]

## Seams for Safe Change

- [Where behavior can be altered without editing in place — see `.ai/standards/legacy-rails.md`]

## Open Questions

- [ ] 

## References

- Standard: `.ai/standards/legacy-rails.md`
- Skill: `reverse-document-legacy`
- Next step template: `.ai/templates/modernization-plan.md`
