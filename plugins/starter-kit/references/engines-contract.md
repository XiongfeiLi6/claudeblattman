# Engines Contract — how kit skills use optional AI engines

The starter kit runs fully on Claude. Some skills can *optionally* call other AI
CLIs (Codex, Gemini) for second opinions. Any skill or command that wants to use
one MUST follow this contract. (The `oracle` field is reserved for a future
release — nothing in this version probes or enables it.)

## The config file

Location: `~/.claude/starter-kit/engines.json`. Written ONLY by `/kit-setup`;
everything else treats it as read-only.

```json
{
  "schema_version": 1,
  "codex":  { "available": true },
  "gemini": { "available": false },
  "oracle": { "available": false },
  "paste_loop": ["chatgpt", "gemini"],
  "updated": "2026-06-12"
}
```

- `codex` / `gemini` / `oracle` — `available: true` means the CLI was detected on
  PATH AND the user agreed to use it. The objects may carry extra keys (for example
  `"user_declined": true`); readers ignore keys they don't know, writers preserve them.
- `paste_loop` — browser AIs the user can reach by copy-paste when no CLI is set up.
  Skills that support a copy-paste workflow may offer these by name.
- `updated` — date of the last `/kit-setup` run, `YYYY-MM-DD`.

## Rules for anything that uses an engine

1. **Missing, empty, or unparseable file → run Claude-only. Never an error.** No
   warnings, no troubleshooting, no mention of JSON. Claude-only is the kit's
   normal, fully working state — treat it that way.
2. **Re-check at runtime.** Config can go stale. Before any engine use, verify the
   binary still exists (`command -v codex`, `command -v gemini`, …). Config says
   available but the binary is gone → same as unavailable.
3. **The standard skip-note.** When an engine is requested but unavailable, print
   exactly this, then continue with Claude:

   > Running on Claude only — that's the normal setup and everything here works.
   > (Have ChatGPT or Gemini? Run /kit-setup to plug them in.)

4. **Call engines through the shipped wrappers** —
   `${CLAUDE_PLUGIN_ROOT}/scripts/codex-run.sh` and
   `${CLAUDE_PLUGIN_ROOT}/scripts/gemini-run.sh` (prompt on stdin, answer written
   to the out-file you name). They handle model selection and fail loudly instead
   of hanging. Never inline a raw `codex exec` or `gemini -p` call.
5. **Engine failure mid-run is not a task failure.** Say in one line that the
   engine didn't respond, give Claude's own answer, and keep going.
6. **Privacy gate before every external send.** Calling an engine transmits the
   content to another AI service. If the content includes confidential records,
   personal contact details, research-participant or human-subjects data, or
   anything the user wouldn't paste into a public website — don't send it. Say
   why in one sentence and offer a Claude-only path or a user-approved redacted
   version. This check is mandatory in every skill and command that uses an engine.
