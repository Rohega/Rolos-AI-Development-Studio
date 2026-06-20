# shellcheck shell=bash
# rorcc agent <name> [--local|--cloud] — chat session with an agent.
# Local backend: a compiled Ollama model (rorcc-<name>) via /api/chat.
# Cloud backend: OpenAI/Anthropic with the assembled prompt as the system message.
# Both stream the reply token-by-token.

cmd_agent() {
  local name="" backend=""
  while [ $# -gt 0 ]; do
    case "$1" in
      --cloud) backend="cloud" ;;
      --local) backend="local" ;;
      -*) err "unknown option: $1"; return 2 ;;
      *) [ -z "$name" ] && name="$1" || { err "unexpected argument: $1"; return 2; } ;;
    esac
    shift
  done
  if [ -z "$name" ]; then
    err "usage: rorcc agent <agent-name> [--local|--cloud]"
    return 2
  fi
  backend="${backend:-${RORCC_BACKEND:-local}}"

  command -v jq >/dev/null 2>&1 || { err "jq is required for 'rorcc agent' (apt install jq | brew install jq)"; return 1; }

  local sysfile="" label
  if [ "$backend" = "cloud" ]; then
    . "$RORCC_LIB_DIR/cloud.sh"
    cloud_check || return 1
    local root; root="$(find_ai_root)" || { err "no .ai/ framework found"; return 1; }
    [ -f "$root/.ai/agents/$name.yaml" ] || { err "agent not found: $name"; return 1; }
    . "$RORCC_LIB_DIR/assemble.sh"
    sysfile="$(mktemp)"
    assemble_system "$root" "$name" > "$sysfile" 2>/dev/null
    apply_context_budget "$sysfile"
    label="cloud:$CLOUD_PROVIDER/$CLOUD_MODEL"
  else
    ollama_running || { err "ollama daemon not reachable at $OLLAMA_HOST — start it with 'ollama serve'"; return 1; }
    if ! ollama_has_model "rorcc-$name"; then
      err "model 'rorcc-$name' not found — build it first: rorcc build-agent $name"
      return 1
    fi
    label="local:rorcc-$name"
  fi

  info "Chatting with ${C_BOLD}$name${C_RESET} (${C_DIM}$label${C_RESET}). Type ${C_DIM}/exit${C_RESET} to quit, ${C_DIM}/reset${C_RESET} to clear history."
  printf '\n'

  local messages='[]'
  local input content payload line chunk err_msg

  while true; do
    printf '%b' "${C_GREEN}you ›${C_RESET} "
    IFS= read -r input || break
    case "$input" in
      "")        continue ;;
      "/exit"|"/quit") break ;;
      "/reset")  messages='[]'; info "history cleared"; continue ;;
    esac

    messages="$(jq --arg c "$input" '. += [{"role":"user","content":$c}]' <<<"$messages")"
    printf '%b\n' "${C_BLUE}$name ›${C_RESET}"
    content=""

    if [ "$backend" = "cloud" ]; then
      if cloud_stream "$sysfile" "$messages"; then
        content="$CLOUD_REPLY"
      fi
      printf '\n\n'
      [ -z "$content" ] && { err "cloud request failed or returned empty (check API key / network)"; continue; }
    else
      payload="$(jq -n --arg m "rorcc-$name" --argjson msgs "$messages" '{model:$m, messages:$msgs, stream:true}')"
      err_msg=""
      while IFS= read -r line; do
        [ -z "$line" ] && continue
        err_msg="$(jq -r '.error // empty' <<<"$line" 2>/dev/null)"
        [ -n "$err_msg" ] && break
        chunk="$(jq -rj '.message.content // empty' <<<"$line" 2>/dev/null)"
        printf '%s' "$chunk"
        content="$content$chunk"
      done < <(curl -fsS --no-buffer "$OLLAMA_HOST/api/chat" -d "$payload" 2>/dev/null)
      printf '\n\n'
      [ -n "$err_msg" ] && { err "model error: $err_msg"; continue; }
      [ -z "$content" ] && { err "empty response (is the model still loading? try again)"; continue; }
    fi

    messages="$(jq --arg c "$content" '. += [{"role":"assistant","content":$c}]' <<<"$messages")"
  done

  [ -n "$sysfile" ] && rm -f "$sysfile"
  printf '\n'
  info "session ended"
}
