# RoR Command Center — Manual de usuario

> Guía práctica para usar RoR Command Center en tu proyecto Rails con cualquier
> agente de IA (Cursor, Claude Code, Codex, Copilot…). Pensada para ponerte a
> producir en una sola sesión.

Última actualización: 2026-06-21

---

## 1. Qué es (en 30 segundos)

RoR Command Center convierte tu repo en un **equipo senior de Rails** dirigido por
IA: 8 roles especialistas, skills reutilizables, workflows de punta a punta y
standards de ingeniería de nivel producción.

La clave: **todo vive en `.ai/` (la fuente única de verdad)**. Las carpetas de cada
plataforma (`.cursor/`, `.claude/`, `.github/`, `AGENTS.md`) son **adaptadores
delgados** que apuntan a `.ai/` sin duplicar contenido.

| Concepto | Dónde vive | En palabras simples |
|----------|-----------|---------------------|
| **Standard** | `.ai/standards/` | El "cómo construimos las cosas". |
| **Agent** | `.ai/agents/` | Un rol del equipo (ej. Rails Architect). |
| **Skill** | `.ai/skills/` | Una tarea concreta (ej. "redactar un feature spec"). |
| **Workflow** | `.ai/workflows/` | Varios pasos encadenados (idea → deploy). |
| **Template** | `.ai/templates/` | Plantilla para generar artefactos (ADR, QA plan…). |
| **Adaptador** | `.cursor/`, `.claude/`, `AGENTS.md` | Le dice a cada IA que use `.ai/`. |

---

## 2. El "router" de `.ai` (cómo se garantiza que se use siempre)

El problema clásico: el agente *menciona* los standards pero no siempre los **lee**.
Para cerrarlo, el framework carga `.ai/` por dos vías complementarias:

1. **Núcleo siempre presente.** Estos 9 standards se cargan en cada sesión porque
   aplican a todo trabajo: `collaboration`, `minimalism`, `development`,
   `project-bootstrap`, `testing`, `security`, `git-workflow`, `code-review`,
   `documentation`.
2. **Standards de dominio on-demand.** El resto (frontend, api, datos, async,
   auth, infra, legacy) se cargan en cuanto tocas su área — así no se infla el
   contexto innecesariamente (principio de minimalismo).

Cómo se materializa en cada plataforma:

| Plataforma | Mecanismo del router | Se carga… |
|------------|----------------------|-----------|
| **Cursor** | `.cursor/rules/ai-index.mdc` (`alwaysApply: true`) | automáticamente en cada chat |
| **Claude Code** | `CLAUDE.md` (`@`-referencias) | al iniciar `claude` |
| **Codex** | `AGENTS.md` (auto-load) | al iniciar sesión |
| **Copilot** | `.github/copilot-instructions.md` | automáticamente |

> En Cursor, además, cada standard de dominio tiene su regla `.mdc` por glob que se
> activa al abrir archivos de ese tipo (`rails.mdc` → `app/**/*.rb`, etc.). El
> router cubre el caso en que **ninguna** regla por glob se dispara (repos nuevos,
> trabajo en Markdown/YAML, planificación en el chat).

---

## 3. Instalación

Clona el framework y ejecútalo apuntando a tu proyecto:

```bash
git clone https://github.com/Rohega/ror-command-center.git
cd ror-command-center
./install.sh /ruta/a/tu-proyecto
```

Copia el **core** y crea el scaffolding vacío de `docs/`. No sobrescribe archivos
existentes salvo que pases `--force`.

| Flag | Efecto |
|------|--------|
| `--dry-run` | Muestra qué copiaría sin escribir nada |
| `--force` | Sobrescribe archivos existentes |
| `--backup` | Guarda los conflictos como `<archivo>.bak` |
| `--with-examples` | Copia también `examples/` y docs del ejemplo warehouse |

Verifica la instalación:

```bash
cd /ruta/a/tu-proyecto
test -f .cursor/rules/ai-index.mdc && echo "router OK"
ls .ai/standards | wc -l   # debería listar los standards
```

Si abres el proyecto en Cursor, el hook de inicio (`detect-gaps.sh`) avisa si
falta `.ai/` o el router.

---

## 4. Uso diario

### 4.1 Flujo recomendado (Cursor)

1. Abre el proyecto en Cursor — el router carga solo.
2. Planifica en **modo Ask**, implementa en **modo Agent**.
3. Para tareas grandes, deja que el agente siga un workflow y se detenga en cada
   fase para tu aprobación.

### 4.2 Recetas copy-paste

**Redactar un feature spec (skill + agent):**

```
Actúa como el agent en .ai/agents/product-owner.yaml y sigue
.ai/skills/create-feature-spec/SKILL.md para un spec de "transferencia de stock
entre almacenes". Hazme preguntas primero; luego guárdalo en docs/specs/.
```

**Revisar un modelo contra los standards (agent + standard):**

```
Actúa como el agent en .ai/agents/qa-engineer.yaml. Revisa app/models/invoice.rb
contra .ai/standards/development.md y .ai/standards/security.md.
Lista los problemas por severidad; no edites archivos todavía.
```

**Ejecutar el workflow completo de nueva feature:**

```
Ejecuta .ai/workflows/new-feature.yaml para "transferencia de stock entre
almacenes". Detente tras cada fase y espera mi aprobación.
```

**Reforzar el framework en un chat puntual:**

```
Para este proyecto, trata .ai/ como la fuente única de verdad. Antes de
implementar, carga el agent de .ai/agents/, el skill de .ai/skills/ y los
standards de .ai/standards/. Sigue el protocolo de colaboración: pregunta,
ofrece opciones, redacta y espera mi aprobación antes de escribir archivos.
```

> Tip: usa `@`-menciones en Cursor para adjuntar el archivo exacto, p. ej.
> `@.ai/skills/create-feature-spec/SKILL.md`.

### 4.3 Otras plataformas

- **Claude Code:** ejecuta `claude`; invoca skills con `/create-feature-spec`,
  `/qa-plan`, etc. Ver `docs/integrations/claude-code.md`.
- **Codex / Copilot:** `AGENTS.md` y `.github/copilot-instructions.md` se cargan
  solos. Ver `docs/integrations/codex.md` y `docs/integrations/copilot.md`.

---

## 5. El pipeline de una feature (Definition of Done)

Toda feature sigue: **Idea → Spec → Arquitectura → Plan → Desarrollo → Tests →
Documentación → Deploy**. No se considera terminada hasta cumplir el DoD:

- [ ] Tests RSpec de los caminos críticos.
- [ ] Sin specs pendientes/saltados sin ticket.
- [ ] `ponytail-review` sin sobre-ingeniería sin resolver.
- [ ] `qa-plan` sin hallazgos BLOQUEANTES.
- [ ] Documentación del módulo en `docs/`.
- [ ] Trabajo en rama `feature/<ticket>-<slug>` (nunca en `main`).

Detalle: `.cursor/rules/workflow-gates.mdc` y `.ai/workflows/new-feature.yaml`.

---

## 6. Extender el framework

- **Nuevo standard:** créalo en `.ai/standards/`. Si quieres que se cargue
  siempre, añádelo al núcleo en `.cursor/rules/ai-index.mdc` (y, por paridad, en
  `CLAUDE.md` / `AGENTS.md`). Si es de dominio, añade su línea en la sección
  "Standards de dominio" y, opcionalmente, una regla `.mdc` por glob.
- **Nuevo skill / agent / workflow:** créalo bajo `.ai/` y lístalo en el router.
- **Regla específica del proyecto:** añade un `.mdc` en `.cursor/rules/` que
  **referencie** `.ai/standards/` — nunca copies el texto del standard.

> Regla de oro: una sola fuente de verdad (`.ai/`). Los adaptadores apuntan, no
> duplican.

---

## 7. Solución de problemas

| Síntoma | Causa probable | Solución |
|---------|----------------|----------|
| El agente ignora los standards | El router no se instaló | `test -f .cursor/rules/ai-index.mdc`; re-ejecuta `install.sh --force` |
| Una regla de dominio no se activa | Tipo de archivo no coincide con el glob | `@`-menciona el standard o la regla |
| El agente edita sin preguntar | Estás en modo Agent | Pide "pregunta antes de editar" o planifica en modo Ask |
| No sé qué reglas están activas | Activación por glob | Abre un archivo de ese tipo o `@`-menciona la regla |
| Falta el equipo en un repo nuevo | Aún sin archivos Rails | El router (`ai-index.mdc`) ya garantiza el núcleo; refuerza con la receta 4.2 |

---

## 8. Glosario

- **`.ai/`** — Fuente única de verdad; todas las definiciones del framework.
- **Adaptador** — Carpeta/archivo específico de una IA que apunta a `.ai/`.
- **Router** — Mecanismo que garantiza que `.ai/` se considere siempre
  (`ai-index.mdc` en Cursor; `CLAUDE.md`/`AGENTS.md` en otras).
- **Núcleo** — Los 9 standards transversales que se cargan en cada sesión.
- **DoD (Definition of Done)** — Criterios mínimos para dar por terminado el trabajo.
- **`alwaysApply`** — Frontmatter de una regla de Cursor que la activa en todo chat.
- **Glob** — Patrón de archivos que activa una regla `.mdc` por tipo de archivo.

---

## 9. Referencias

- Índice de `.ai/`: `.ai/README.md`
- Guía Cursor: `docs/integrations/cursor.md`
- Guía Claude Code: `docs/integrations/claude-code.md`
- Protocolo de colaboración: `.ai/standards/collaboration.md`
- Gates de ingeniería: `.cursor/rules/workflow-gates.mdc`
- Instalación detallada: `docs/INSTALL.md`
