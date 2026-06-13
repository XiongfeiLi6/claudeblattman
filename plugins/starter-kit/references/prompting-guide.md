# Prompting Guide

*A short, practical reference for writing effective prompts, based on Anthropic's published best practices.*
*Where this guide conflicts with your personal preferences file (`~/.claude/starter-kit/my-preferences.md`), your preferences win.*

---

## Core Principles

### 1. Be clear and specific
State the task explicitly at the start. Name the deliverable, the audience, and the scope.

> Weak: "Help me with a presentation."
> Strong: "Outline a 10-slide presentation for our quarterly meeting covering Q2 results, top products, and Q3 targets."

### 2. Try zero-shot first; add examples sparingly
Run the prompt with no examples. If the output format or style is wrong, tighten the instructions or specify an output structure before reaching for examples. One short example of the format you want beats five adjectives describing it — but unnecessary examples add bulk and can over-constrain.

### 3. Decompose complex tasks
Break big asks into numbered components and request each one.

> Weak: "How can I improve team productivity?"
> Strong: "Address: (1) current blockers, (2) possible fixes, (3) implementation challenges, (4) how to measure improvement. State your key assumptions for each."

### 4. Iterate with specific feedback
If the first response isn't right, don't start over — say exactly what to change: "Make the tone more casual, add one customer example, cut the second paragraph by half."

### 5. Assign a role when expertise helps
"You are an experienced grant reviewer..." sharpens output on specialized tasks and surfaces perspectives you might miss. Skip roles for routine asks.

### 6. Bookend long prompts
Models weight the beginning and end of a prompt most heavily. Put the core task and key constraints at the top, supporting documents and background in the middle, and restate the 1-2 most critical requirements at the end as a "Final reminder."

### 7. Separate standing rules from the task
For reusable prompts, keep two layers: persistent behavior rules (role, tone, citation policy, style) and the task-specific request with its inputs. Mixing them produces "prompt mush," where stable rules and one-off instructions collide.

### 8. Ask for rationale, not chain-of-thought
When you want transparency, request structured output: key assumptions (2-3 bullets), a brief rationale for the approach, and what was checked. Don't ask the model to show its internal reasoning step by step — modern models reason internally on their own, and reasoning transcripts add length without adding quality. To nudge depth on a genuinely hard problem: "Think carefully through the problem before responding."

### 9. Request thoroughness with action verbs, not adjectives
"Be thorough" and "be meticulous" do nothing. These work:

- "Research current best practices for [domain]"
- "Compare your approach against [named standard or framework]"
- "Flag where you deviate from [standard] and explain why"
- "Note what you verified and what remains uncertain"

Skip all-caps emphasis ("CRITICAL", "YOU MUST") — modern models already take instructions seriously, and shouting tends to degrade output rather than improve it.

---

## Depth Calibration

Match the number of directives to the stakes of the task. Over-prompting a simple task wastes effort; under-prompting a hard one costs quality.

| Tier | When to use | Typical directives |
|------|-------------|--------------------|
| **Light** | Lookups, formatting, short emails | 0-1. Trust the model. |
| **Standard** | Analysis, writing, research summaries | 2-3. Add "state assumptions" and "note what's uncertain." |
| **Deep** | Proposals, methodology, hard-to-reverse decisions | 3-5. Add comparison against a named standard plus a self-check step. |

Signals to upgrade from Light: the task involves synthesis or original argument (→ Standard); high stakes, external quality standards, or an explicit request for rigor (→ Deep).

Self-verification directives worth adding when reliability matters:

- "Before answering, identify the 2-3 most likely failure modes"
- "After drafting, check whether your response addresses [specific criteria]"
- "State your confidence level and what would change your answer"

---

## Prompt Structure Template

Include only the sections that earn their place:

```
## Role
[Who the model should be — only when specialized expertise helps]

## Task
[What you want done — one or two specific, action-oriented sentences]

## Context
[Background the model can't infer on its own]

## Constraints
[Rules, limits, scope boundaries, things to avoid]

## Output Format
[Structure, length, and style of the response]

## Examples
[A sample of the desired output — only if format or style is non-obvious]
```

Two placement rules for long prompts:

- **Long inputs first.** When pasting big documents, transcripts, or data, put the content at the TOP and the question at the BOTTOM. This measurably improves quality on long-context tasks.
- **Bookend.** Restate the 1-2 most critical constraints at the very end (Principle 6).

For reusable prompts: add a version line (v1.0, v1.1...) with a one-line change note, and keep 3-5 test cases (input → expected output, including one edge case). Re-run a few after every edit — one good run is not evidence of reliability.

---

## Troubleshooting

**Makes things up:** add "If you're unsure about something, say so rather than guessing." Ask for sources or the specific evidence behind each claim. Break the task into smaller, verifiable steps.

**Too generic:** add context about your specific situation; show one example of what you're looking for; assign a relevant expert role.

**Misses requirements:** list requirements as explicit numbered items; use the structure template; for long prompts, bookend the critical ones.

**Too long:** set a word or sentence limit; ask for "concise" output; request bullets instead of paragraphs.

**Too short:** ask it to expand on specific points; request supporting evidence and worked examples.

**Wrong format:** specify the structure ("a table with columns X, Y, Z") before adding examples; if it's still wrong, add one compact example of the format you want.

---

## Quick Checklist (for complex prompts)

- [ ] Task stated clearly at the beginning
- [ ] Necessary context provided
- [ ] Constraints and scope explicit
- [ ] Output format specified
- [ ] Examples included only if format/style matters (tried zero-shot first)
- [ ] Role assigned only if specialized expertise helps
- [ ] Critical instructions repeated at the end (long prompts)
- [ ] Directives use action verbs, scaled to the task's depth tier
