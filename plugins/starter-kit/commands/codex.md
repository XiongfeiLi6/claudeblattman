---
description: Ask Codex (ChatGPT's coding model) one question and relay its answer — a quick second opinion alongside Claude.
argument-hint: <question or request>
---

# /codex — one-shot Codex query

Send the user's request to the Codex CLI and relay the answer. One question, one reply, read-only — Codex edits nothing.

## Steps

1. **Privacy check (required, every time).** Sending this question transmits its content to another AI service. If the request or any pasted content includes confidential records, personal contact details, research-participant or human-subjects data, unpublished sensitive material, or anything the user wouldn't paste into a public website — do NOT send it. Explain why in one sentence and offer either a Claude-only answer or a redacted version the user approves first.

2. **Explicit send confirmation (required, every time).** If the privacy check passes, ask: "Send this prompt to Codex for a second opinion? (yes/no)" Proceed only if the user answers yes. If they answer no or do not answer clearly, stop and offer a Claude-only answer.

3. **Check it's enabled.** Read `~/.claude/starter-kit/engines.json`. If the file is missing, unparseable, or `codex.available` is not `true`, print exactly this and stop:

   > Running on Claude only — that's the normal setup and everything here works. (Have ChatGPT or Gemini? Run /kit-setup to plug them in.)

4. **Re-check the binary.** Run `command -v codex`. Not found → print the same note and stop.

5. **Make a private workspace.** Run `mktemp -d` once and use the directory it prints (below: `<rundir>`) for both files. Never use predictable fixed paths like `/tmp/codex-prompt.txt`.

6. **Write the prompt** to `<rundir>/prompt.txt` with the Write tool (NOT echo or a heredoc — shell quoting mangles multi-line prompts). Content: the user's request, verbatim. If empty, ask one line: "What should I ask Codex?"

7. **Run the wrapper** (it picks the best available model and falls back automatically — never call `codex exec` directly):

   ```bash
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/codex-run.sh" <rundir>/reply.txt < <rundir>/prompt.txt
   ```

   Run in the foreground and wait — it can take a minute or two.

8. **Relay the reply.** Read `<rundir>/reply.txt`. If it's short, show it verbatim; if long, summarize the key points and offer the full text. Label it clearly as Codex's answer, and add one sentence on where you agree or differ.

9. **If the wrapper fails**, tell the user in plain language — "I couldn't reach Codex just now, so here's my own answer instead. If this keeps happening, run /kit-setup." — then answer the question yourself. Keep the technical error details to yourself unless the user asks for them.

10. **Clean up.** Remove the temp directory (`rm -rf <rundir>`).
