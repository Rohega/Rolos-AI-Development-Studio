# Ollama Integration (Local AI)

Run the RoR Command Center specialist team **fully local** on your own PC using
[Ollama](https://ollama.com/) — no cloud, no API keys, zero per-token cost.

## How it fits

RoR Command Center is a knowledge framework (`.ai/`); it has no model of its own.
The `rorcc` CLI talks to **Ollama**, which you install separately. Ollama is a
runtime dependency (like Postgres or Docker), **not** part of this repo.

```text
rorcc (Bash + .ai/ knowledge)  ──HTTP──►  Ollama daemon (localhost:11434) + local models
```

## Prerequisites

| Tool | Why | Install |
|------|-----|---------|
| Ollama | Runs the local model | `curl -fsSL https://ollama.com/install.sh \| sh` |
| `curl` | rorcc → Ollama HTTP | Pre-installed on most systems |
| `jq` | Build/parse chat JSON | `apt install jq` / `brew install jq` |

Pick a base model by RAM (see `ollama/models.yaml`):

| RAM | Model | Pull |
|-----|-------|------|
| 8–16 GB | `qwen2.5-coder:7b` | `ollama pull qwen2.5-coder:7b` |
| 24–32 GB | `qwen2.5-coder:14b` | `ollama pull qwen2.5-coder:14b` |
| 48 GB+ | `qwen2.5-coder:32b` | `ollama pull qwen2.5-coder:32b` |

> Local 7–14B models are below Claude/GPT for complex architecture. The value of
> local is privacy, zero cost, and offline use. For hard problems, use a cloud
> client (Cursor/Claude Code) and keep local for everyday tasks.

## Quickstart

```bash
# 1. Install Ollama + pull a model
curl -fsSL https://ollama.com/install.sh | sh
ollama pull qwen2.5-coder:7b

# 2. Check your environment
rorcc doctor

# 3. Compile an agent into a local Ollama model
rorcc build-agent rails-architect

# 4. Chat with it locally
rorcc agent rails-architect
```

In the chat: type your message, `/reset` to clear history, `/exit` to quit.

## How `build-agent` works

`rorcc build-agent <name>` reads `.ai/agents/<name>.yaml`, inlines every
`.ai/standards/*` it references, and writes an Ollama `Modelfile` with that text
as the `SYSTEM` prompt. It then runs `ollama create rorcc-<name>`. The `.ai/`
files stay the single source of truth — the model is regenerated, never duplicated
by hand. Generated files live in `<project>/.rorcc/build/<name>/`.

## Configuration

| Variable | Default | Purpose |
|----------|---------|---------|
| `RORCC_MODEL` | `qwen2.5-coder:7b` | Base model used by `build-agent` |
| `OLLAMA_HOST` | `http://localhost:11434` | Ollama endpoint |

```bash
RORCC_MODEL=qwen2.5-coder:14b rorcc build-agent backend-rails-developer
```

## Available agents

`rails-architect`, `backend-rails-developer`, `frontend-react-inertia-developer`,
`aws-devops-engineer`, `qa-engineer`, `documentation-writer`, `product-owner`,
`security-reviewer`.

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `ollama daemon not reachable` | Run `ollama serve` (or restart the Ollama app) |
| `base model missing` | `ollama pull qwen2.5-coder:7b` |
| `jq is required` | `apt install jq` / `brew install jq` |
| Slow / poor answers | Use a larger tier model, or switch to a cloud client for that task |
