# Release Checklist: v[X.Y.Z]

**Target date:** [YYYY-MM-DD]  
**Release Manager:** [Name]  
**Environment:** Production

---

## Pre-Release

- [ ] All stories in scope marked Done
- [ ] QA sign-off obtained
- [ ] Security audit clear (or waivers documented)
- [ ] Migrations reviewed by MySQL DBA
- [ ] Changelog updated
- [ ] Staging deploy verified

## Codebase Health

- [ ] CI green on release branch
- [ ] No open BLOCKING code review items
- [ ] `bundle audit` / dependency scan clean

## Deployment

- [ ] Deployment plan reviewed (`.ai/templates/deployment-plan.md`)
- [ ] Maintenance window communicated
- [ ] Database backup confirmed
- [ ] Capistrano deploy executed
- [ ] Migrations ran successfully

## Post-Release

- [ ] Health checks pass
- [ ] Smoke test on production
- [ ] Error rates normal (monitoring)
- [ ] Git tag `vX.Y.Z` created
- [ ] Release notes published

## Rollback (if needed)

- [ ] Rollback procedure: [link to runbook]
- [ ] Rollback executed: [Y/N — date/time]
