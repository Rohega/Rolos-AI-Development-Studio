# Deployment Plan: [Release/Feature]

**Version:** v[X.Y.Z]  
**Author:** [AWS DevOps Engineer / Release Manager]  
**Date:** [YYYY-MM-DD]  
**Target:** [Staging | Production]

---

## Scope

[What is being deployed — features, migrations, config changes]

## Prerequisites

- [ ] QA sign-off
- [ ] Migrations reviewed
- [ ] Secrets/config updated in parameter store
- [ ] Stakeholders notified

## Infrastructure Changes

| Resource | Change | IaC File |
|----------|--------|----------|
| | | |

## Deployment Steps

1. [ ] Backup database
2. [ ] Deploy to staging — `cap staging deploy`
3. [ ] Run smoke tests on staging
4. [ ] Deploy to production — `cap production deploy`
5. [ ] Run migrations: `[command]`
6. [ ] Restart Puma/nginx if required
7. [ ] Verify health endpoint

## Validation

- [ ] `/health` returns 200
- [ ] [Critical user path]
- [ ] Background jobs processing
- [ ] No spike in error rate

## Rollback Strategy

**Trigger:** [error rate, failed migration, etc.]

**Steps:**
1. `cap production deploy:rollback`
2. [Migration rollback if needed]
3. Verify previous version healthy

**RTO:** [target recovery time]

## Contacts

| Role | Name | Contact |
|------|------|---------|
| Release Manager | | |
| On-call | | |
