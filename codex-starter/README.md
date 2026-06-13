# Codex Starter Pack

A small starter kit for Codex, OpenAI's coding-agent app: one global guidance
file plus four skills covering the everyday moves — shaping a rough request,
stress-testing a plan, closing a session, and getting a second opinion from
another AI.

From [claudeblattman.com](https://claudeblattman.com).

## What's inside

| Piece | Installs to | What it does |
|---|---|---|
| `global/AGENTS.md` | `~/.codex/AGENTS.md` | Baseline working guidance for every Codex session |
| `$prompt` | `~/.codex/skills/prompt` | Turn a rough or dictated request into a clear task, then do it |
| `$review-plan` | `~/.codex/skills/review-plan` | Single-pass structured critique of a plan, with a verdict |
| `$done` | `~/.codex/skills/done` | Write a short `HANDOFF.md` so the next session resumes fast |
| `$ask-agents` | `~/.codex/skills/ask-agents` | Ask Claude Code and/or Gemini for an outside opinion |

## Install

1. Clone or download this folder.
2. From inside it, run:

   ```
   python3 install-codex-starter.py install
   ```

   If you already have a `~/.codex/AGENTS.md`, the installer backs it up to
   `AGENTS.md.bak-<date>` before replacing it, and tells you so.

3. Restart Codex so it picks up the new skills.
4. In any Codex session, invoke a skill by name: `$prompt`, `$review-plan`,
   `$done`, or `$ask-agents`.

Other commands: `status` (preview what install would do), `verify` (check
installed files), `uninstall` (see below).

## Notes

- `$ask-agents` needs Node.js 18+ plus the `claude` and/or `gemini`
  command-line tools installed and signed in. It asks you to confirm before
  sending anything to another AI service. The other pieces have no dependencies
  beyond Python 3 for the installer.
- Codex Desktop's native folder trust, approvals, sandboxing, and connector
  settings already handle safety and access — this pack does not (and should
  not) configure any of them.

## Uninstall

```
python3 install-codex-starter.py uninstall
```

This removes the installed files and restores your original `AGENTS.md` from
the backup if one was made.
