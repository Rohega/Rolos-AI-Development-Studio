#!/usr/bin/env bash
# Detect upstream ponytail changes so we can re-apply them to our Rails-adapted
# copies. We do NOT clobber: .ai/standards/minimalism.md and .ai/skills/ponytail-*
# are adapted, not verbatim. This script only tells you WHAT changed upstream.
#
# ponytail: snapshot-diff, not auto-merge. Add real merge only if upstream churns often.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PONYTAIL_REPO="${PONYTAIL_REPO:-$(cd "$REPO_ROOT/.." && pwd)/ponytail}"
SNAPSHOT_DIR="$REPO_ROOT/scripts/.ponytail-snapshot"

# Upstream source files we derive our content from.
SOURCES=(
  "AGENTS.md"
  "skills/ponytail/SKILL.md"
  "skills/ponytail-review/SKILL.md"
  "skills/ponytail-audit/SKILL.md"
  "skills/ponytail-debt/SKILL.md"
)

if [[ ! -d "$PONYTAIL_REPO" ]]; then
  echo "ponytail repo not found at: $PONYTAIL_REPO"
  echo "Clone it next to this repo, or set PONYTAIL_REPO=/path/to/ponytail. Nothing to do."
  exit 0
fi

mkdir -p "$SNAPSHOT_DIR"
changed=0

for src in "${SOURCES[@]}"; do
  upstream="$PONYTAIL_REPO/$src"
  snap="$SNAPSHOT_DIR/${src//\//__}"
  [[ -f "$upstream" ]] || { echo "missing upstream: $src (skipping)"; continue; }
  if [[ ! -f "$snap" ]]; then
    echo "new (no snapshot yet): $src"
    changed=1
  elif ! diff -q "$snap" "$upstream" >/dev/null; then
    echo "=== changed upstream: $src ==="
    diff -u "$snap" "$upstream" || true
    changed=1
  fi
  cp "$upstream" "$snap"
done

if [[ "$changed" -eq 0 ]]; then
  echo "Up to date. No upstream ponytail changes since last sync."
else
  echo
  echo "Upstream changed. Re-apply relevant bits to:"
  echo "  .ai/standards/minimalism.md  (from AGENTS.md + skills/ponytail/SKILL.md)"
  echo "  .ai/skills/ponytail-*/SKILL.md  (from skills/ponytail-*/SKILL.md)"
  echo "Snapshot updated under scripts/.ponytail-snapshot/."
fi
