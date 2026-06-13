---
name: council
description: Dispatch a small panel of critic agents in parallel on a plan, draft, or decision, then synthesize their raw critiques in a separate fresh-context pass. Use when the user asks for a council, a panel of critics, or a multi-angle review.
argument-hint: <topic or file:path> [--panel a,b,c] [--n 3] [--type plan|decision] [--peer codex|gemini]
---

# /council — Parallel Critics, Then a Separate Synthesis

Dispatch 3–4 critic agents in parallel on the same input, collect their raw critiques, then run ONE synthesis pass in a fresh context. Hard cap: 4 critics. Single round only — critics speak once, the synthesizer reads once. Never turn the critiques into a majority vote.

Why this shape:
- **Parallel, not sequential** — independent critics with different lenses catch different problems, and nobody anchors on whoever spoke first.
- **One round only** — no debate or rebuttals. Multi-round AI debate drifts toward consensus, not accuracy.
- **Separate synthesis** — a fresh-context pass reads the critiques as data instead of being swayed by the conversation that produced them.

## The four shipped critics

| Critic | Lens |
|--------|------|
| `skeptic` | Wishful thinking — which load-bearing claims aren't backed by evidence? |
| `pre-mortem` | Works backward from failure — the top 3 ways this fails |
| `completeness-checker` | What's missing that a domain expert would expect? |
| `chief-of-staff` | What's the actual decision, and what does saying yes cost the user? |

Persona files live at `${CLAUDE_PLUGIN_ROOT}/agents/<name>.md`.

## Default panels

| Task type | Panel | N |
|-----------|-------|---|
| Plan / architecture / workflow review | skeptic, pre-mortem, completeness-checker | 3 |
| Decision support ("should I…") | skeptic, pre-mortem, chief-of-staff | 3 |

Paper and grant-proposal panels need additional personas — future release. If the user asks for one, say so and offer the plan panel as the closest fit.

Inferring the type when `--type` isn't given: "plan / design / architecture / workflow" → plan; "should I / decide / go or no-go / accept or reject" → decision; unclear → ask one line: "Is this a plan review or a decision?"

## When NOT to run a council

- Quick lookups, single-file edits, casual brainstorming — just answer.
- Inputs under ~50 words of substance — there isn't enough for three critics to disagree about. Offer a quick single review instead.
- If it's unclear whether the user wants a council run or is just discussing councils as a topic, ask one line before dispatching.

## Steps

### 1. Parse and resolve

1. Identify the input. If `file:<path>` is given, Read that file — its content is what the critics review. Otherwise the topic is the text or recent conversation content the user pointed at.
2. Resolve the panel: explicit `--panel` wins; else `--type`; else infer from keywords; else ask.
3. Cap at 4 critics. If the user asks for more: "Hard cap is 4 — more voices adds noise, not signal. Pick a tighter panel."

### 2. Check the persona files exist

For each persona in the panel, Glob `${CLAUDE_PLUGIN_ROOT}/agents/<name>.md`. If any file is missing, stop with a clear message:

> "Council can't run: the persona file for `<name>` is missing from the starter-kit plugin. Reinstalling the plugin usually fixes this, or pass `--panel` with personas that exist."

No silent substitutions for missing personas.

### 3. Optional peer swap (`--peer codex` or `--peer gemini`)

By default all critics are Claude agents — that works with zero extra setup. `--peer` swaps ONE critic for a different AI engine, so the panel isn't all one model family.

0. **Privacy check and explicit confirmation (required).** A peer critic sends the full input to another AI service. If the input contains confidential records, personal contact details, research-participant or human-subjects data, or anything the user wouldn't paste into a public website — skip the peer swap, say why in one sentence, and run the all-Claude panel. If the privacy check passes, ask: "Send this plan to Codex/Gemini as one council critic? (yes/no)" Proceed with the peer critic only if the user answers yes; otherwise run the all-Claude panel.

1. Read `~/.claude/starter-kit/engines.json` (written by `/kit-setup`). The engine counts as available only if ALL of these hold:
   - the file exists and parses as JSON (missing or broken file = every engine unavailable — that's normal, not an error),
   - the engine's top-level entry (`codex` or `gemini`) has `"available": true` — the flat schema in `${CLAUDE_PLUGIN_ROOT}/references/engines-contract.md` is the only one,
   - `command -v codex` (or `command -v gemini`) still finds the CLI — the config can go stale; the live check wins.

   If any check fails, print exactly:

   > "Running on Claude only — that's the normal setup and everything here works. (Have ChatGPT or Gemini? Run /kit-setup to plug them in.)"

   and continue with the all-Claude panel.

2. If the engine is available, pick the critic it replaces: `codex` replaces `skeptic` (closest overlap — rigor and failure-finding); `gemini` replaces `completeness-checker` (broad coverage). If the replaced persona isn't in the panel, replace the last critic in the panel.

3. Build the peer prompt: the replaced persona's role and output shape (from its persona file), the same input the Claude critics get, and the line "End with VERDICT: APPROVE or REVISE + brief rationale. Do not reconcile with other critics — a separate synthesizer does that."

4. Create two temp files in one Bash call — `echo "$(mktemp /tmp/council-peer-prompt.XXXXXX) $(mktemp /tmp/council-peer-out.XXXXXX)"` — note both paths, then use the Write tool to put the peer prompt in the first one.

5. In Step 4's parallel message, include ONE Bash call alongside the Task calls:

   ```bash
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/codex-run.sh" <out-file> < <prompt-file>
   # or, for gemini:
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/gemini-run.sh" <out-file> < <prompt-file>
   ```

6. If the script fails or reports the engine unavailable, don't fail the council — note "peer critic unavailable, continuing with Claude critics" and synthesize from the critics that did return.

### 4. Dispatch the critics in parallel

Print one status line first: `<panel-type> panel: dispatching N critics`

Then send ONE message containing all N Task calls — one message is what makes them run in parallel. Each call:
- `subagent_type`: `starter-kit:<name>` (plugin agents are namespaced, e.g. `starter-kit:skeptic`)
- `description`: 3–5 words (e.g. "Skeptic reviews plan")
- `prompt`: the full input from Step 1, plus: "Produce your structured critique in your persona's output shape (findings, score, blockers). End with VERDICT: APPROVE or REVISE + one line of rationale."

Fallback: if dispatch fails because the `starter-kit:<name>` agent type isn't found, Read the persona file and re-dispatch as `subagent_type: general-purpose` with the persona file's full content prefixed to the prompt as the role.

No `model` parameter — critics run on whatever model the session is using. That's deliberate: the kit works on any plan without special access.

### 5. Collect

Collect the raw critic outputs (and Read the peer's out-file, if one ran). Do NOT summarize or reconcile them yourself — that happens in a fresh context, next.

### 6. Separate synthesis pass (mandatory — never skip, never inline)

Dispatch ONE more Task call:
- `subagent_type`: `general-purpose` (fresh context — the synthesizer must not see this conversation)
- `prompt` containing, in order:
  1. An instruction to first Read the synthesis template at `${CLAUDE_PLUGIN_ROOT}/references/council-synthesis.md` and follow it. Resolve `${CLAUDE_PLUGIN_ROOT}` to its actual path when composing the prompt — the subagent can't expand the variable itself.
  2. Which branch applies: plan or decision.
  3. All raw critic outputs, verbatim, each labeled with its persona name (label the peer by engine + persona, e.g. "codex as skeptic").
  4. The original content the critics reviewed.

### 7. Emit

Show the synthesizer's output, then include the raw critic outputs inside a `<details>` collapsible at the bottom. Nothing hidden: the council ranks concerns, it does not dismiss them.

## Out of scope

- Round 2 / iterative debate (single round only)
- Majority voting on narrative output
- More than 4 critics
