#!/bin/bash
# Advises review when canonical .ai/ skills are modified

INPUT=$(cat)
if command -v jq >/dev/null 2>&1; then
    FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
else
    FILE_PATH=$(echo "$INPUT" | grep -oE '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/"file_path"[[:space:]]*:[[:space:]]*"//;s/"$//')
fi

FILE_PATH=$(echo "$FILE_PATH" | sed 's|\\|/|g')

if echo "$FILE_PATH" | grep -qE '(^|/)\.ai/skills/'; then
    SKILL_NAME=$(echo "$FILE_PATH" | grep -oE '\.ai/skills/[^/]+' | sed 's|\.ai/skills/||')
    echo "=== Canonical skill modified: $SKILL_NAME ===" >&2
    echo "Update Claude adapter at .claude/skills/$SKILL_NAME/SKILL.md if description changed." >&2
fi

if echo "$FILE_PATH" | grep -qE '(^|/)\.claude/skills/'; then
    SKILL_NAME=$(echo "$FILE_PATH" | grep -oE '\.claude/skills/[^/]+' | sed 's|\.claude/skills/||')
    echo "=== Claude skill adapter modified: $SKILL_NAME ===" >&2
    echo "Ensure it still delegates to .ai/skills/$SKILL_NAME/SKILL.md" >&2
fi

exit 0
