#!/usr/bin/env bash
# codex-run.sh — run a one-shot, read-only Codex query with model fallback.
# Part of the starter-kit plugin; used by /codex and /council --peer codex.
#
# Usage:   codex-run.sh <out_file> [light]      (prompt on stdin)
#   Default: try the most capable models first. Pass "light" for quick, cheap calls.
#
# Writes Codex's final answer to <out_file> (streaming stdout to <out_file>.stdout,
# stderr to <out_file>.stderr). Exits 0 only when <out_file> is non-empty.
# On failure it prints a loud "CODEX UNAVAILABLE" line and times out long-running calls.
#
# The account default is tried first so public users are not forced onto model
# names their plan may not expose. Explicit fallback names are best-effort only.

set -uo pipefail
umask 077   # temp prompt/output files are private to the user

OUT="${1:?usage: codex-run.sh <out_file> [light]   (prompt on stdin)}"
HINT="${2:-default}"
RUN_TIMEOUT_SECONDS="${STARTER_KIT_ENGINE_TIMEOUT_SECONDS:-300}"

CODEX_BIN="$(command -v codex || true)"
if [ -z "$CODEX_BIN" ]; then
  echo "CODEX UNAVAILABLE: no 'codex' on PATH. Install the Codex CLI (npm install -g @openai/codex), then run /kit-setup." >&2
  exit 127
fi

if [ "$HINT" = "light" ]; then
  CANDIDATES=("" gpt-5.3-codex-spark gpt-5.4 gpt-5.3-codex)
else
  CANDIDATES=("" gpt-5.5-codex gpt-5.5 gpt-5.4 gpt-5.3-codex-spark gpt-5.3-codex)
fi

# Read the prompt once; reuse it across model retries.
PROMPT_TMP="$(mktemp)"
cat > "$PROMPT_TMP"

# Run against a clean, throwaway config dir so a stray or hand-edited config
# file can't break the call. Link the real login token so auth still works.
CLEAN_HOME="$(mktemp -d)"
TIMEOUT_FLAG="$(mktemp)"
trap 'rm -f "$PROMPT_TMP" "$TIMEOUT_FLAG"; rm -rf "$CLEAN_HOME"' EXIT
REAL_HOME="${CODEX_HOME:-$HOME/.codex}"
: > "$CLEAN_HOME/config.toml"
if [ -f "$REAL_HOME/auth.json" ] && [ ! -L "$REAL_HOME/auth.json" ]; then
  ln -s "$REAL_HOME/auth.json" "$CLEAN_HOME/auth.json"
fi
export CODEX_HOME="$CLEAN_HOME"

run_with_timeout() {
  stdin_file="$1"
  shift
  rm -f "$TIMEOUT_FLAG"
  "$@" < "$stdin_file" &
  child_pid=$!
  (
    sleep "$RUN_TIMEOUT_SECONDS"
    if kill -0 "$child_pid" 2>/dev/null; then
      echo timeout > "$TIMEOUT_FLAG"
      kill -TERM "$child_pid" 2>/dev/null || true
      sleep 2
      kill -KILL "$child_pid" 2>/dev/null || true
    fi
  ) &
  watcher_pid=$!
  wait "$child_pid"
  rc=$?
  kill "$watcher_pid" 2>/dev/null || true
  wait "$watcher_pid" 2>/dev/null || true
  return "$rc"
}

FIRST=1
LAST_ERR=""
for MODEL in "${CANDIDATES[@]}"; do
  MODEL_LABEL="${MODEL:-account default}"
  if [ -n "$MODEL" ]; then
    run_with_timeout "$PROMPT_TMP" "$CODEX_BIN" exec --model "$MODEL" --sandbox read-only \
      -c approval_policy=never --skip-git-repo-check \
      -o "$OUT" - > "$OUT.stdout" 2> "$OUT.stderr"
  else
    run_with_timeout "$PROMPT_TMP" "$CODEX_BIN" exec --sandbox read-only \
      -c approval_policy=never --skip-git-repo-check \
      -o "$OUT" - > "$OUT.stdout" 2> "$OUT.stderr"
  fi
  RC=$?

  if [ "$RC" -eq 0 ] && [ -s "$OUT" ]; then
    if [ "$FIRST" -ne 1 ]; then
      echo "CODEX NOTE: fell back to model=$MODEL_LABEL ($LAST_ERR)" >&2
    fi
    echo "CODEX OK: model=$MODEL_LABEL out=$OUT" >&2
    exit 0
  fi

  if [ -s "$TIMEOUT_FLAG" ]; then
    LAST_ERR="$MODEL_LABEL timed out after ${RUN_TIMEOUT_SECONDS}s"
    break
  fi

  # Model not available on this account or plan -> try the next one down.
  if grep -qiE "not supported|invalid_request_error|model_not_found|does not exist" "$OUT.stderr" "$OUT.stdout" 2>/dev/null; then
    LAST_ERR="$MODEL_LABEL not available on this account"
    FIRST=0
    continue
  fi
  # Prompt too large for this model's context window -> try the next one.
  if grep -qiE "maximum context length|context window|context length|too long|exceeds" "$OUT.stderr" 2>/dev/null; then
    LAST_ERR="$MODEL_LABEL context overflow"
    FIRST=0
    continue
  fi
  # Anything else (auth, network, crash): stop and fail loud, don't burn retries.
  LAST_ERR="$MODEL_LABEL exit=$RC"
  break
done

echo "CODEX UNAVAILABLE: all candidate models failed. Last: $LAST_ERR" >&2
echo "  stderr tail:" >&2
tail -5 "$OUT.stderr" >&2 2>/dev/null || true
echo "  If this is an auth problem, run 'codex login' once, then try again." >&2
exit 1
