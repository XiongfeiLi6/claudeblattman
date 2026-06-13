---
name: kit-setup
description: "One-time starter-kit setup: detects optional AI engines (Codex, Gemini), confirms each with you, writes the engines config, and optionally personalizes how Claude writes for you. Safe to re-run anytime."
---

# Kit Setup

Everything in this kit works on Claude alone. This skill records which optional extra engines exist on this machine, so other kit skills can offer second opinions. **Detect, then confirm.** Never ask the user what subscriptions or plans they have, and never list, describe, or ask about tools that weren't detected.

## Phase 1 — Engines

### 1. Detect

One Bash call:

```bash
command -v codex; command -v gemini; date +%Y-%m-%d
```

For each CLI found, run a quick `<tool> --version`; if that fails, say it looks installed but isn't currently working, record it as unavailable, and move on — don't troubleshoot here. Version output only means "detected," not "usable."

### 2. Confirm each FOUND tool, in plain language

One short yes/no question per tool that was found — and nothing about tools that weren't:

- **codex:** "I found the Codex CLI installed — want me to use it for second opinions and research? (yes/no)"
- **gemini:** "I found the Gemini CLI installed — want me to use it for second opinions and very long documents? (yes/no)"

If nothing was found, skip the questions entirely. Either way, close Phase 1 with one line: "If you later install the Codex or Gemini CLI, run /kit-setup again."

### 3. Smoke-test each accepted tool

For each detected tool the user accepts, create one private temp directory with `mktemp -d`, then run one tiny smoke test through the shipped wrapper:

```bash
smoke_dir="$(mktemp -d)"
printf 'Reply with exactly: starter-kit-ok\n' | bash "${CLAUDE_PLUGIN_ROOT}/scripts/codex-run.sh" "$smoke_dir/codex.txt" light
printf 'Reply with exactly: starter-kit-ok\n' | bash "${CLAUDE_PLUGIN_ROOT}/scripts/gemini-run.sh" "$smoke_dir/gemini.txt"
```

If the wrapper succeeds and the output is non-empty, mark the engine `available: true`. If it fails, mark it unavailable but preserve what happened, for example `{ "available": false, "detected": true, "auth_unverified": true }`. Keep the user-facing message plain: "I found Codex/Gemini, but it did not answer a test prompt yet. Everything still works on Claude."

### 4. Write the config

Target: `~/.claude/starter-kit/engines.json`. Run `mkdir -p ~/.claude/starter-kit` first. If the file already exists, Read it and preserve any fields you don't recognize — newer kit versions may have added some. Schema (full contract: `${CLAUDE_PLUGIN_ROOT}/references/engines-contract.md`):

```json
{
  "schema_version": 1,
  "codex":  { "available": true },
  "gemini": { "available": false },
  "oracle": { "available": false },
  "paste_loop": ["chatgpt", "gemini"],
  "updated": "<today, YYYY-MM-DD>"
}
```

- `available: true` only if the CLI was detected, the user said yes, and the smoke test returned a non-empty answer.
- If the user says no to an installed tool, write `{ "available": false, "user_declined": true }` so a re-run doesn't quietly switch it back on.
- `paste_loop`: write the default shown above on first write; keep any existing value on re-runs.
- `oracle`: always write `{ "available": false }` — the field is reserved for a future release; this version doesn't probe or enable it.

## Phase 2 — Personalize (optional; offer once)

Ask once: "Want to spend two minutes personalizing how I write for you? Five quick questions — totally skippable."

If yes, ask one at a time, conversationally:

1. What kind of work will you mostly use this for — and what's your role or field?
2. How do you like answers — short and direct, or thorough and explained?
3. What annoys you in AI writing? (buzzwords, bullet overload, hedging…)
4. How formal should drafts be by default?
5. Anything I should always do — or never do?

Then write `~/.claude/starter-kit/my-preferences.md`: start from the template at `${CLAUDE_PLUGIN_ROOT}/references/prompt-preferences-TEMPLATE.md` and fill it in from their answers. If the template is missing, write a simple file with one short section per question. If they skip, say they can run /kit-setup again anytime — and don't offer a second time this run.

## Finish — report in plain language

Two or three sentences, no jargon, no JSON. Pattern:

> "You're set up. Everything runs on Claude — that's the normal setup and it all works."

Add one sentence per enabled engine (e.g. "Codex is also connected, so you can ask it for second opinions with /codex.") and one if preferences were saved. If nothing extra was found, the first sentence is the whole report.

## Re-running

Safe anytime. Re-detect and update `engines.json`: a newly installed tool gets confirmed (Phase 1, step 2) and added; a removed one gets marked unavailable; unknown fields and `paste_loop` are preserved. If `my-preferences.md` already exists, offer to update it rather than starting over.
