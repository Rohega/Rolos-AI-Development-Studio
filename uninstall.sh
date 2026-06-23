#!/usr/bin/env bash
# RoR Command Center — desinstalación / limpieza (contraparte de setup.sh).
#
# Quita lo que instaló setup.sh: especialistas compilados, el comando 'rorcc',
# el framework descargado y (opcional) los modelos de IA o el propio Ollama.
# También puede borrar de un proyecto los archivos que copió install.sh.
#
#   ./uninstall.sh                 # limpieza local, pregunta por cada grupo
#   ./uninstall.sh --models        # además borra los modelos base descargados
#   ./uninstall.sh --ollama        # además desinstala Ollama por completo
#   ./uninstall.sh --project DIR   # borra del proyecto DIR lo que copió install.sh
#   ./uninstall.sh --dry-run       # muestra qué haría, sin borrar nada
#
# Idempotente: si algo ya no existe, lo omite.
set -euo pipefail

# --- Colors -------------------------------------------------------------------
if [ -t 1 ]; then
  C_RESET="\033[0m"; C_DIM="\033[2m"; C_GREEN="\033[32m"; C_YELLOW="\033[33m"
  C_BLUE="\033[34m"; C_RED="\033[31m"; C_BOLD="\033[1m"
else
  C_RESET=""; C_DIM=""; C_GREEN=""; C_YELLOW=""; C_BLUE=""; C_RED=""; C_BOLD=""
fi
info() { printf '%b\n' "${C_BLUE}==>${C_RESET} $1"; }
ok()   { printf '%b\n' "${C_GREEN}ok${C_RESET}   $1"; }
warn() { printf '%b\n' "${C_YELLOW}!${C_RESET}    $1"; }
err()  { printf '%b\n' "${C_RED}error:${C_RESET} $1" >&2; }
step() { printf '\n%b\n' "${C_BOLD}$1${C_RESET}"; }

have() { command -v "$1" >/dev/null 2>&1; }
OS="$(uname -s)"
OLLAMA_HOST="${OLLAMA_HOST:-http://localhost:11434}"

# --- Args ---------------------------------------------------------------------
DRY=0; YES="${RORCC_YES:-0}"; DO_MODELS=0; DO_OLLAMA=0; PROJECT=""
usage() {
  cat <<'EOF'
RoR Command Center — desinstalación / limpieza

USO:
  ./uninstall.sh [opciones]

OPCIONES:
  --models          También borra los modelos base de IA descargados (varios GB).
  --ollama          También desinstala Ollama por completo (binario, servicio, ~/.ollama).
  --project <dir>   Borra de <dir> los archivos del framework que copió install.sh.
  --yes             No preguntar (asume "sí"). También con RORCC_YES=1.
  --dry-run         Muestra qué se borraría, sin borrar nada.
  -h, --help        Esta ayuda.

QUÉ SE QUITA (limpieza local, por defecto):
  • Especialistas compilados en Ollama (modelos 'rorcc-*')
  • El comando 'rorcc' enlazado en tu PATH
  • El framework descargado por el one-liner (~/.ror-command-center)
  • Artefactos de compilación (.rorcc/build/)

NO se tocan 'jq', 'zstd' ni 'git' (utilidades generales del sistema).
EOF
}
while [ $# -gt 0 ]; do
  case "$1" in
    --models)  DO_MODELS=1 ;;
    --ollama)  DO_OLLAMA=1 ;;
    --project) shift; PROJECT="${1:-}"; [ -n "$PROJECT" ] || { err "--project requiere una ruta"; exit 2; } ;;
    --yes|-y)  YES=1 ;;
    --dry-run) DRY=1 ;;
    -h|--help) usage; exit 0 ;;
    *) err "opción desconocida: $1"; printf '\n'; usage; exit 2 ;;
  esac
  shift
done

# Pregunta sí/no. Devuelve 0 (sí) si YES=1 o DRY=1 (para previsualizar todo).
confirm() {
  [ "$YES" = "1" ] || [ "$DRY" = "1" ] && return 0
  [ -t 0 ] || { warn "no interactivo: re-ejecuta con --yes para confirmar '$1'"; return 1; }
  printf '%b' "$1 [s/N]: "; IFS= read -r a
  case "$a" in s|S|si|SI|y|Y) return 0 ;; *) return 1 ;; esac
}

# Borra una ruta (archivo o carpeta) respetando --dry-run.
rm_path() {
  local p="$1"
  [ -e "$p" ] || [ -L "$p" ] || return 0
  if [ "$DRY" = "1" ]; then printf '   %b[dry-run]%b rm -rf %s\n' "$C_DIM" "$C_RESET" "$p"; return 0; fi
  rm -rf "$p" && ok "borrado: ${C_DIM}$p${C_RESET}"
}

# --- Localiza el framework (para artefactos de build) -------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || pwd)"
CLONE_DIR="${RORCC_HOME_DIR:-$HOME/.ror-command-center}"

# =============================================================================
# Modo B: limpiar un proyecto (lo que copió install.sh)
# =============================================================================
# Mantener en sync con CORE_ITEMS/SCAFFOLD_DIRS de install.sh.
CORE_ITEMS=(
  ".ai" ".cursor" ".claude/agents" ".claude/hooks" ".claude/skills"
  ".claude/settings.json" "AGENTS.md" "CLAUDE.md" "docs/integrations"
  "docs/CLAUDE.md" "docs/COLLABORATIVE-DESIGN-PRINCIPLE.md" "docs/USER-MANUAL.md"
  ".github/copilot-instructions.md"
)
SCAFFOLD_DIRS=(
  "docs/architecture" "docs/specs" "docs/stories" "docs/design"
  "docs/runbooks" "docs/modules"
)

clean_project() {
  local dir="$1"
  [ -d "$dir" ] || { err "no existe el directorio: $dir"; exit 1; }
  dir="$(cd "$dir" && pwd)"
  if [ ! -d "$dir/.ai" ]; then
    warn "$dir no parece tener el framework instalado (no hay .ai/). Aborto por seguridad."
    exit 1
  fi
  step "Limpiar framework del proyecto: $dir"
  warn "Esto borra carpetas/archivos del framework. Tu código de la app NO se toca,"
  warn "pero SÍ se pierden los archivos del framework (incluido lo que hayas editado)."
  confirm "¿Borrar los archivos del framework en $dir?" || { info "Cancelado."; exit 0; }

  local rel
  for rel in "${CORE_ITEMS[@]}"; do
    rm_path "$dir/$rel"
  done

  # Las carpetas de scaffolding solo se borran si están vacías o solo con .gitkeep
  # (evita borrar specs/ADRs/etc. que tú hayas escrito).
  for rel in "${SCAFFOLD_DIRS[@]}"; do
    local d="$dir/$rel"
    [ -d "$d" ] || continue
    local extra
    extra="$(find "$d" -type f ! -name '.gitkeep' -print -quit 2>/dev/null || true)"
    if [ -n "$extra" ]; then
      warn "conservo $rel/ (tiene archivos tuyos)"
    else
      rm_path "$d"
    fi
  done

  printf '\n'
  [ "$DRY" = "1" ] && warn "dry-run: nada se borró." || ok "proyecto limpio."
}

if [ -n "$PROJECT" ]; then
  clean_project "$PROJECT"
  exit 0
fi

# =============================================================================
# Modo A: limpieza local (por defecto)
# =============================================================================
printf '%b\n' "${C_BOLD}RoR Command Center — limpieza${C_RESET}"
[ "$DRY" = "1" ] && warn "dry-run: no se borrará nada, solo se muestra."

# --- 1. Especialistas compilados (modelos rorcc-* en Ollama) -----------------
step "1  Especialistas compilados (Ollama 'rorcc-*')"
if have ollama && curl -fsS "$OLLAMA_HOST/api/tags" >/dev/null 2>&1; then
  models="$(ollama list 2>/dev/null | awk '$1 ~ /^rorcc-/ {print $1}')"
  if [ -z "$models" ]; then
    ok "no hay especialistas compilados"
  elif confirm "¿Borrar especialistas: $(echo "$models" | tr '\n' ' ')?"; then
    for m in $models; do
      if [ "$DRY" = "1" ]; then printf '   %b[dry-run]%b ollama rm %s\n' "$C_DIM" "$C_RESET" "$m"
      else ollama rm "$m" >/dev/null 2>&1 && ok "borrado: $m" || warn "no se pudo borrar: $m"; fi
    done
  else
    info "omitido"
  fi
else
  warn "Ollama no está corriendo; omito los especialistas (arráncalo si quieres borrarlos)"
fi

# --- 2. Comando 'rorcc' en PATH ----------------------------------------------
step "2  Comando 'rorcc'"
found=0
for d in "$HOME/.local/bin" "/usr/local/bin"; do
  if [ -e "$d/rorcc" ] || [ -L "$d/rorcc" ]; then
    found=1
    confirm "¿Quitar el enlace $d/rorcc?" && rm_path "$d/rorcc" || info "omitido: $d/rorcc"
  fi
done
[ "$found" -eq 0 ] && ok "no encontré 'rorcc' enlazado"

# --- 3. Framework descargado + artefactos de build ---------------------------
step "3  Framework descargado y artefactos"
if [ -d "$CLONE_DIR/.ai/agents" ]; then
  confirm "¿Borrar el framework descargado en $CLONE_DIR?" && rm_path "$CLONE_DIR" || info "omitido: $CLONE_DIR"
else
  ok "no hay framework auto-descargado en $CLONE_DIR"
fi
for base in "$SCRIPT_DIR" "$CLONE_DIR"; do
  if [ -d "$base/.rorcc/build" ]; then
    confirm "¿Borrar artefactos de compilación en $base/.rorcc?" && rm_path "$base/.rorcc" || info "omitido: $base/.rorcc"
  fi
done

# --- 4. Modelos base (opcional, --models) ------------------------------------
step "4  Modelos base de IA"
if [ "$DO_MODELS" -ne 1 ]; then
  info "se conservan (usa --models para borrarlos). Suelen pesar varios GB."
elif have ollama && curl -fsS "$OLLAMA_HOST/api/tags" >/dev/null 2>&1; then
  base_models="$(ollama list 2>/dev/null | awk '$1 ~ /^qwen2.5-coder:/ {print $1}')"
  if [ -z "$base_models" ]; then
    ok "no hay modelos base de qwen2.5-coder"
  elif confirm "¿Borrar modelos base: $(echo "$base_models" | tr '\n' ' ')?"; then
    for m in $base_models; do
      if [ "$DRY" = "1" ]; then printf '   %b[dry-run]%b ollama rm %s\n' "$C_DIM" "$C_RESET" "$m"
      else ollama rm "$m" >/dev/null 2>&1 && ok "borrado: $m" || warn "no se pudo borrar: $m"; fi
    done
  else
    info "omitido"
  fi
else
  warn "Ollama no está corriendo; no puedo listar/borrar modelos"
fi

# --- 5. Ollama completo (opcional, --ollama) ---------------------------------
step "5  Ollama (motor de IA)"
if [ "$DO_OLLAMA" -ne 1 ]; then
  info "se conserva (usa --ollama para desinstalarlo)."
elif ! have ollama; then
  ok "Ollama no está instalado"
elif confirm "¿Desinstalar Ollama por completo (binario, servicio y ~/.ollama)?"; then
  if [ "$OS" = "Darwin" ]; then
    if have brew && brew list ollama >/dev/null 2>&1; then
      [ "$DRY" = "1" ] && printf '   %b[dry-run]%b brew uninstall ollama\n' "$C_DIM" "$C_RESET" || brew uninstall ollama || true
    else
      warn "instalado fuera de brew: arrastra Ollama.app a la Papelera manualmente"
    fi
    rm_path "$HOME/.ollama"
  else
    # Linux: pasos oficiales de desinstalación.
    if have systemctl; then
      for c in "sudo systemctl stop ollama" "sudo systemctl disable ollama"; do
        [ "$DRY" = "1" ] && printf '   %b[dry-run]%b %s\n' "$C_DIM" "$C_RESET" "$c" || eval "$c" 2>/dev/null || true
      done
      rm_path "/etc/systemd/system/ollama.service" # nota: requiere sudo si no eres root
    fi
    bin="$(command -v ollama || true)"
    if [ -n "$bin" ]; then
      if [ "$DRY" = "1" ]; then printf '   %b[dry-run]%b sudo rm %s\n' "$C_DIM" "$C_RESET" "$bin"
      else sudo rm -f "$bin" && ok "borrado binario: $bin" || warn "no se pudo borrar $bin (¿permisos?)"; fi
    fi
    if [ "$DRY" = "1" ]; then printf '   %b[dry-run]%b sudo rm -rf /usr/share/ollama  +  rm -rf ~/.ollama\n' "$C_DIM" "$C_RESET"
    else sudo rm -rf /usr/share/ollama 2>/dev/null || true; rm -rf "$HOME/.ollama" 2>/dev/null || true; ok "datos de Ollama borrados"; fi
    warn "si setup creó el usuario 'ollama', puedes quitarlo: sudo userdel ollama; sudo groupdel ollama"
  fi
else
  info "omitido"
fi

printf '\n'
[ "$DRY" = "1" ] && warn "dry-run terminado — re-ejecuta sin --dry-run para aplicar." || ok "${C_BOLD}Limpieza terminada.${C_RESET}"
info "No toqué 'jq', 'zstd' ni 'git' (utilidades generales). Quítalas tú si quieres."
