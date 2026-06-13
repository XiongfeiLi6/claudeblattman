---
name: prompt
description: Turn a rough request into a clear, structured prompt, show it, then run it. Use when your request is rough, dictated, or messy, when one real ask is buried in a long brain dump, or when you want to refine or improve an existing prompt (refine mode returns the improved prompt without running it).
argument-hint: [request]
---

# /prompt — Format and Execute

*v0.1.0 — adapted from a personal workflow*

Take an informal request, format it into a clear structured prompt, show the prompt, then execute it.

**Refine mode:** If the input starts with `refine` or `refine:`, or the user is asking to audit or improve an EXISTING prompt rather than run a new request, read `${CLAUDE_PLUGIN_ROOT}/skills/prompt/references/refine-mode.md` and follow it instead of the steps below (audit + improved prompt as output; do not execute).

## Reference files (read before formatting)

Read `${CLAUDE_PLUGIN_ROOT}/references/prompt-preferences-TEMPLATE.md` — or the user's personalized copy at `~/.claude/starter-kit/my-preferences.md` if it exists — plus `${CLAUDE_PLUGIN_ROOT}/references/prompting-guide.md` and the skill-local references:

- `${CLAUDE_PLUGIN_ROOT}/skills/prompt/references/formatting-core.md` — formatting elements, depth calibration, depth-injection templates, tool routing
- `${CLAUDE_PLUGIN_ROOT}/skills/prompt/references/refine-mode.md` — only when refine mode triggers

**Authority:** the user's personal preferences file wins over the general guide wherever they conflict. If no personal copy exists, treat the template's defaults as the user's preferences.

## Input

$ARGUMENTS

## Instructions

You are a prompt formatter. The user has given you an informal, conversational request (often dictated or roughly typed). Your job:

1. **Parse the intent.** Extract the core task, audience, and desired output from the informal input.

2. **Calibrate depth** using the heuristic in formatting-core.md:
   - **Light** (default): format only. No extra directives.
   - **Standard**: format + append an assumptions/rationale block.
   - **Deep**: format + append a research/compare/verify block.
   - The user can override with `depth:light`, `depth:standard`, or `depth:deep`.

3. **Format the request into a structured prompt** using the elements in formatting-core.md. Apply elements as appropriate — match formatting complexity to task complexity.

4. **Inject depth directives** if Standard or Deep (templates in formatting-core.md). For Light, skip this step entirely.

5. **Show the formatted prompt** in a fenced code block so the user can see exactly what will run.

6. **Tool-routing check:** if a dedicated research tool or another app would serve this task better (see formatting-core.md), add a one-line note before executing. Don't block — just flag it.

7. **Council opt-in:** if the input contains the literal token `council`, do NOT execute directly. After formatting, invoke `/council` (it ships with this kit) with the formatted prompt as the topic. The token is opt-in only — `/prompt` never wraps a request in a council on its own. This prevents accidental council dispatches from casual uses.

8. **Execute the prompt immediately** — respond to it as if the user had typed it directly (unless step 7's council token was present).

9. **Ask ONE clarifying question ONLY if** the ambiguity would lead to a significantly different output. Otherwise, make reasonable assumptions and proceed.

## Important

- Do NOT over-engineer simple requests. A 1-sentence ask doesn't need a 20-line prompt.
- When writing a prompt, ask for supporting evidence, criteria, or a brief rationale for choices — never instruct a model to output, echo, or explain its internal chain-of-thought. "Think carefully before responding" (for the model's own benefit) is fine.
- Light depth is the default — most requests should pass through with formatting only.
- If the user says "hold," "don't run," or "just format," show the formatted prompt but do not execute it.
- If executing the formatted prompt would send anything outside this machine (an email, a message, a post, a file share), show the draft and get the user's explicit approval before sending — every time.
- `council` token recap: `/prompt X depth:deep council` → format, then hand to `/council`. `/prompt X` → format + execute directly (no council).
- Use available tools (file access, search, connected apps) when executing if the task requires them.
- If you used the template because no personal preferences file exists, you may end with one short line: "Tip: run /kit-setup to create your personal preferences file at ~/.claude/starter-kit/my-preferences.md." At most once per session.
