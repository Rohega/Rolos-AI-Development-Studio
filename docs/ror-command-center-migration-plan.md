> Language: English | [Español](#versión-en-español)

# RoR Command Center — Migration Plan

> Pivot of the framework from **agnostic / multi-stack** to a **Ruby on Rails specialist** called **RoR Command Center** (slug: `ror-command-center`).

## 1. Context and goal

The repository started as **Rolos AI Development Studio**, a *vendor-neutral* and multi-stack framework where Rails was just the "reference stack". The new purpose is the opposite:

> We are **not** a generic agent framework. We accelerate production-grade Ruby on Rails development with proven architecture, conventions, and operational practices.

### Core Philosophy

- Rails First
- Convention Over Configuration
- Production Ready
- AWS Native
- Maintainable Code
- Testable Code
- Senior Engineer Standards

### Platform specialization

Ruby on Rails 7+ / 8+, PostgreSQL and MySQL, Sidekiq, ActiveJob, Devise, ActiveAdmin,
Hotwire, React + Inertia, AWS, Docker, Capistrano, Kamal, REST APIs, Background
Processing, OCR Pipelines, WhatsApp Integrations, Enterprise Applications.

## 2. Final roster (8 agents)

The prompt names 7 specialists; we add a dedicated **Security Engineer** as the 8th so we don't
degrade security quality. The capabilities of the removed agents
(DBA, code review, release, UX) are **folded** into the remaining ones, not lost.

| # | Specialist | Absorbs from current agents |
|---|---|---|
| 1 | Product Owner | `product-owner` |
| 2 | Rails Architect | `rails-architect` + `mysql-dba` (modeling, migrations, indexes) |
| 3 | Backend Engineer | `backend-rails-developer` + DBA queries/optimization |
| 4 | Frontend Engineer | `frontend-react-inertia-developer` + `ux-designer` (rails + agnostic) |
| 5 | DevOps AWS Engineer | `aws-devops-engineer` + `release-manager` |
| 6 | QA Engineer | `qa-engineer` + `code-reviewer` |
| 7 | Documentation Engineer | `documentation-writer` |
| 8 | Security Engineer | `security-reviewer` (kept dedicated) |

Agents removed as a standalone role: `mysql-dba`, `code-reviewer`,
`release-manager`, `ux-designer` (x2). Their responsibilities are documented
inside the YAML of the agent that absorbs them.

## 3. Pipeline (8 phases)

Every feature request follows:

```text
Idea → Specification → Architecture → Implementation Plan → Development → Testing → Documentation → Deployment
```

Changes relative to the current `new-feature.yaml`:

- Add an explicit **Implementation Plan** phase (between Architecture and Development).
- Add an explicit **Documentation** phase (before Deployment).
- Remove role resolution via `stacks.<stack>` mapping (no more multi-stack).

## 4. Mandatory rules (output)

- Follow Rails conventions whenever possible.
- Avoid unnecessary abstractions.
- Prefer Service Objects over fat controllers.
- Prefer ActiveJob for async work.
- Generate migration strategies and rollback plans.
- Include security, monitoring, and deployment considerations.
- Assume production deployment on AWS.
- Output must always be actionable and production-focused.

## 5. Execution phases

### Phase 1 — Rebranding (`Rolos AI Development Studio` → `RoR Command Center`)

Files with the old name to update:

- [ ] `README.md` (title + "What Is This?" section)
- [ ] `CLAUDE.md`
- [ ] `.ai/README.md`
- [ ] `.cursor/rules/project-structure.mdc`
- [ ] `.github/copilot-instructions.md`
- [ ] `docs/CLAUDE.md`
- [ ] `docs/integrations/*` (cursor, claude-code, codex, chatgpt, copilot, gemini)
- [ ] `docs/INSTALL.md`
- [ ] `install.sh`
- [ ] `CONTRIBUTING.md`
- [ ] `UPGRADING.md`

### Phase 2 — Philosophy

- [ ] Insert **Core Philosophy** and specialization into `.ai/README.md` and `CLAUDE.md`.
- [ ] Remove the "Vendor-neutral architecture" principle from `.ai/README.md`.
- [ ] Rewrite the `README.md` description as a Rails specialist.

### Phase 3 — Flatten the multi-stack structure

- [ ] Move `.ai/agents/stacks/rails/*` → `.ai/agents/`
- [ ] Move `.ai/standards/stacks/rails/*` → `.ai/standards/`
- [ ] Remove `.ai/agents/stacks/`, `.ai/standards/stacks/`, `_TEMPLATE`
- [ ] Remove `docs/ADDING-A-LANGUAGE.md`
- [ ] Remove `.cursor/rules/stack-template.mdc.example`
- [ ] Simplify `.ai/workflows/new-feature.yaml` (direct paths, no `stacks`)

### Phase 4 — Collapse roster to 8 agents

- [ ] Merge `mysql-dba` → `rails-architect.yaml`
- [ ] Merge `code-reviewer` → `qa-engineer.yaml`
- [ ] Merge `release-manager` → `aws-devops-engineer.yaml`
- [ ] Merge `ux-designer` (x2) → `frontend-react-inertia-developer.yaml`
- [ ] Keep `security-reviewer` as a dedicated agent (rename to Security Engineer)
- [ ] Update the `.claude/agents/*.md` adapters
- [ ] Update the Agent Roster in `.ai/README.md` and `README.md`

### Phase 5 — 8-phase pipeline

- [ ] Add `implementation-plan` and `documentation` phases to `new-feature.yaml`
- [ ] Update the workflow table in `README.md`

### Phase 6 — New technology coverage

Standards to create in `.ai/standards/`:

- [ ] `postgresql.md` (alongside `mysql.md`)
- [ ] `sidekiq-activejob.md`
- [ ] `devise-auth.md`
- [ ] `activeadmin.md`
- [ ] `hotwire.md`
- [ ] `kamal-docker.md` (deploy alongside Capistrano)

Skills to create in `.ai/skills/`:

- [ ] `ocr-pipeline/SKILL.md`
- [ ] `whatsapp-integration/SKILL.md`
- [ ] Corresponding adapters in `.claude/skills/`

### Phase 7 — Sync adapters and validate

- [ ] Regenerate references in `.claude/` and `.cursor/rules/`
- [ ] Validate that every `@.ai/...` path in `CLAUDE.md` resolves
- [ ] Validate that `install.sh` copies the new paths (without `stacks/`)
- [ ] Review the `examples/warehouse-wms` example for broken references

## 6. Risks

| Risk | Mitigation |
|---|---|
| Broken `@.ai/standards/stacks/rails/*` paths in `CLAUDE.md` | Update all after flattening (Phase 3 + 7) |
| `install.sh` references `stacks/` or the old name | Review in Phase 1 and 7 |
| `warehouse-wms` example with old name/paths | Audit in Phase 7 (non-blocking) |
| Capability loss when collapsing agents | Fold responsibilities into the target YAML |
| Postgres + MySQL: standards divergence | Document key differences in each DB standard |

## 7. Final validation

- [x] `grep` for "Rolos" and "vendor-neutral" → 0 results in active paths (outside `archive/` and this plan)
- [x] `grep` for `stacks/` → 0 results in active paths
- [x] Roster = 8 agents in `.ai/agents/` and `.claude/agents/`
- [x] Pipeline = 8 phases in `new-feature.yaml` and `README.md`
- [x] Valid YAML in agents and workflows; 8 agents, 18 skills, 18 standards

## Status: COMPLETED

Migration executed. The `game-studio-original` references are kept on purpose in
`archive/`, and the physical paths of the `examples/warehouse-wms` example were not renamed
(they are real directory/repo paths, not the brand).

---

## Versión en español

# RoR Command Center — Plan de Migración

> Pivote del framework de **agnóstico / multi-stack** a un **especialista en Ruby on Rails** llamado **RoR Command Center** (slug: `ror-command-center`).

## 1. Contexto y objetivo

El repositorio nació como **Rolos AI Development Studio**, un framework *vendor-neutral* y multi-stack donde Rails era solo el "reference stack". El nuevo propósito es lo opuesto:

> **No** somos un framework genérico de agentes. Aceleramos desarrollo Ruby on Rails de grado producción con arquitectura, convenciones y prácticas operativas probadas.

### Core Philosophy

- Rails First
- Convention Over Configuration
- Production Ready
- AWS Native
- Maintainable Code
- Testable Code
- Senior Engineer Standards

### Especialización de la plataforma

Ruby on Rails 7+ / 8+, PostgreSQL y MySQL, Sidekiq, ActiveJob, Devise, ActiveAdmin,
Hotwire, React + Inertia, AWS, Docker, Capistrano, Kamal, REST APIs, Background
Processing, OCR Pipelines, WhatsApp Integrations, Enterprise Applications.

## 2. Roster final (8 agentes)

El prompt nombra 7 especialistas; añadimos **Security Engineer** como 8º dedicado para no
degradar la calidad de seguridad. Las capacidades de los agentes que se eliminan
(DBA, code review, release, UX) se **pliegan** en los que quedan, no se pierden.

| # | Especialista | Absorbe de los agentes actuales |
|---|---|---|
| 1 | Product Owner | `product-owner` |
| 2 | Rails Architect | `rails-architect` + `mysql-dba` (modelado, migraciones, índices) |
| 3 | Backend Engineer | `backend-rails-developer` + queries/optimización de DBA |
| 4 | Frontend Engineer | `frontend-react-inertia-developer` + `ux-designer` (rails + agnóstico) |
| 5 | DevOps AWS Engineer | `aws-devops-engineer` + `release-manager` |
| 6 | QA Engineer | `qa-engineer` + `code-reviewer` |
| 7 | Documentation Engineer | `documentation-writer` |
| 8 | Security Engineer | `security-reviewer` (se mantiene dedicado) |

Agentes eliminados como rol independiente: `mysql-dba`, `code-reviewer`,
`release-manager`, `ux-designer` (x2). Sus responsabilidades quedan documentadas
dentro del YAML del agente que las absorbe.

## 3. Pipeline (8 fases)

Toda solicitud de feature sigue:

```text
Idea → Specification → Architecture → Implementation Plan → Development → Testing → Documentation → Deployment
```

Cambios respecto al `new-feature.yaml` actual:

- Añadir fase explícita **Implementation Plan** (entre Architecture y Development).
- Añadir fase explícita **Documentation** (antes de Deployment).
- Eliminar la resolución de roles vía mapeo `stacks.<stack>` (ya no hay multi-stack).

## 4. Reglas obligatorias (de salida)

- Seguir convenciones Rails siempre que sea posible.
- Evitar abstracciones innecesarias.
- Preferir Service Objects sobre fat controllers.
- Preferir ActiveJob para trabajo asíncrono.
- Generar estrategias de migración y planes de rollback.
- Incluir consideraciones de seguridad, monitoreo y despliegue.
- Asumir despliegue en producción sobre AWS.
- La salida siempre debe ser accionable y orientada a producción.

## 5. Fases de ejecución

### Fase 1 — Rebranding (`Rolos AI Development Studio` → `RoR Command Center`)

Archivos con el nombre antiguo a actualizar:

- [ ] `README.md` (título + sección "What Is This?")
- [ ] `CLAUDE.md`
- [ ] `.ai/README.md`
- [ ] `.cursor/rules/project-structure.mdc`
- [ ] `.github/copilot-instructions.md`
- [ ] `docs/CLAUDE.md`
- [ ] `docs/integrations/*` (cursor, claude-code, codex, chatgpt, copilot, gemini)
- [ ] `docs/INSTALL.md`
- [ ] `install.sh`
- [ ] `CONTRIBUTING.md`
- [ ] `UPGRADING.md`

### Fase 2 — Filosofía

- [ ] Insertar **Core Philosophy** y especialización en `.ai/README.md` y `CLAUDE.md`.
- [ ] Eliminar el principio "Vendor-neutral architecture" de `.ai/README.md`.
- [ ] Reescribir la descripción de `README.md` como especialista Rails.

### Fase 3 — Aplanar estructura multi-stack

- [ ] Mover `.ai/agents/stacks/rails/*` → `.ai/agents/`
- [ ] Mover `.ai/standards/stacks/rails/*` → `.ai/standards/`
- [ ] Eliminar `.ai/agents/stacks/`, `.ai/standards/stacks/`, `_TEMPLATE`
- [ ] Eliminar `docs/ADDING-A-LANGUAGE.md`
- [ ] Eliminar `.cursor/rules/stack-template.mdc.example`
- [ ] Simplificar `.ai/workflows/new-feature.yaml` (rutas directas, sin `stacks`)

### Fase 4 — Colapsar roster a 8 agentes

- [ ] Refundir `mysql-dba` → `rails-architect.yaml`
- [ ] Refundir `code-reviewer` → `qa-engineer.yaml`
- [ ] Refundir `release-manager` → `aws-devops-engineer.yaml`
- [ ] Refundir `ux-designer` (x2) → `frontend-react-inertia-developer.yaml`
- [ ] Mantener `security-reviewer` como agente dedicado (renombrar a Security Engineer)
- [ ] Actualizar adaptadores `.claude/agents/*.md`
- [ ] Actualizar el Agent Roster en `.ai/README.md` y `README.md`

### Fase 5 — Pipeline de 8 fases

- [ ] Añadir fase `implementation-plan` y `documentation` en `new-feature.yaml`
- [ ] Actualizar la tabla de workflow en `README.md`

### Fase 6 — Cobertura tecnológica nueva

Standards a crear en `.ai/standards/`:

- [ ] `postgresql.md` (junto a `mysql.md`)
- [ ] `sidekiq-activejob.md`
- [ ] `devise-auth.md`
- [ ] `activeadmin.md`
- [ ] `hotwire.md`
- [ ] `kamal-docker.md` (deploy junto a Capistrano)

Skills a crear en `.ai/skills/`:

- [ ] `ocr-pipeline/SKILL.md`
- [ ] `whatsapp-integration/SKILL.md`
- [ ] Adaptadores correspondientes en `.claude/skills/`

### Fase 7 — Sincronizar adaptadores y validar

- [ ] Regenerar referencias en `.claude/` y `.cursor/rules/`
- [ ] Validar que todas las rutas `@.ai/...` en `CLAUDE.md` resuelven
- [ ] Validar que `install.sh` copia las nuevas rutas (sin `stacks/`)
- [ ] Revisar ejemplos `examples/warehouse-wms` por referencias rotas

## 6. Riesgos

| Riesgo | Mitigación |
|---|---|
| Rutas `@.ai/standards/stacks/rails/*` rotas en `CLAUDE.md` | Actualizar todas tras aplanar (Fase 3 + 7) |
| `install.sh` referencia `stacks/` o nombre viejo | Revisar en Fase 1 y 7 |
| Ejemplo `warehouse-wms` con nombre/rutas viejas | Auditar en Fase 7 (no bloqueante) |
| Pérdida de capacidades al colapsar agentes | Plegar responsabilidades en los YAML destino |
| Postgres + MySQL: divergencia de estándares | Documentar diferencias clave en cada standard de DB |

## 7. Validación final

- [x] `grep` de "Rolos" y "vendor-neutral" → 0 resultados en rutas activas (fuera de `archive/` y este plan)
- [x] `grep` de `stacks/` → 0 resultados en rutas activas
- [x] Roster = 8 agentes en `.ai/agents/` y `.claude/agents/`
- [x] Pipeline = 8 fases en `new-feature.yaml` y `README.md`
- [x] YAML válido en agentes y workflows; 8 agentes, 18 skills, 18 standards

## Estado: COMPLETADO

Migración ejecutada. Referencias `game-studio-original` se conservan a propósito en
`archive/` y los paths físicos del ejemplo `examples/warehouse-wms` no se renombraron
(son rutas reales de directorio/repo, no la marca).
