# Prompt Formatting Core — Shared Reference

Used by `/prompt` in both normal and refine mode. Covers prompt structure, depth calibration, and tool routing.

---

## Formatting Elements

When formatting a prompt, apply these elements as appropriate (not all are needed for every prompt):

- **Role/persona** — include only when specialized expertise sharpens the output
- **Task** — stated clearly in 1-2 sentences (always include)
- **Context** — relevant background the model needs
- **Constraints** — length, tone, format, what to avoid
- **Output format** — specify structure (bullets, table, sections, etc.)
- **Bookend pattern** — restate the key instruction at the end if the prompt is long (see the prompting guide's bookend principle for the full pattern)
- **Examples** — include only if they would reduce ambiguity (try zero-shot first)

**Scaling rule:** Match formatting complexity to task complexity. A 1-sentence ask doesn't need a 20-line prompt.

---

## XML Structure

**Recommended when** the formatted prompt mixes 2+ content types (instructions + pasted context, or instructions + examples + input data) AND the output is destined for an API call or another Claude session. Wrap each content type in its own tag:

- `<instructions>` for the core task directives
- `<context>` for background information
- `<example>` (or `<examples>` containing multiple `<example>` blocks) for few-shot examples
- `<document>` with `<source>` and `<document_content>` subtags for pasted files
- a named tag like `<final_verdict>` if structured-output extraction is planned

**Skip when:**
- The prompt is 1-2 sentences or has a single content type (just instructions, no pasted data)
- The output is prose the user will read inline before pasting
- `/prompt` is executing directly in-conversation (no benefit over prose ordering)

XML helps parsing reliability when the receiving model has to distinguish instruction text from pasted data. It does not improve performance in simple one-turn cases.

---

## Long-Context Ordering (inputs of roughly 20k+ tokens)

When the prompt includes pasted long content (documents, transcripts, data dumps):

- **Put the long content at the TOP**
- **Put the query / instruction at the BOTTOM**

Anthropic's evals show a substantial quality uplift vs. query-at-top ordering, especially with complex, multi-document inputs. The effect is less pronounced for simple single-document cases. For multi-document prompts, wrap each document per the XML Structure section above.

---

## Depth Calibration

Before formatting, assess how much depth this task needs. **Default to Light** (format only). Depth injection is additive, not automatic.

### Heuristic

| Level | When to use | User override |
|-------|-------------|---------------|
| **Light** | Default. Quick replies, simple lookups, routine tasks, short emails | `depth:light` |
| **Standard** | Analysis, research, writing, or design where output quality depends on rigor | `depth:standard` |
| **Deep** | (a) High stakes: methodology, research design, grant proposals, decisions that are hard to reverse; (b) the user explicitly asks for thoroughness; (c) the task involves comparing against external standards | `depth:deep` |

### Escalation signals (upgrade from Light)

- Task involves synthesis, analysis, or original argument → **Standard**
- Task involves research design, causal inference, or policy implications → **Standard** or **Deep**
- Words like "comprehensive," "thorough," "rigorous" in the request → **Standard** or **Deep**
- Methodology design, pre-analysis plan, grant proposal → **Deep**

---

## Depth-Injection Templates

### Light (default)
No injection. Format the prompt using the elements above. Done.

### Standard — append to formatted prompt:
```
Include at the end:
- Key assumptions (2-3 bullets)
- Brief rationale for major choices
```

### Deep — append to formatted prompt:
```
Before answering:
- Research current best practices for [task domain]
- Compare your approach against established standards in [domain]
- Flag where your approach deviates and why

Think carefully through the problem before responding.

Include at the end:
- Key assumptions (2-3 bullets)
- Brief rationale for major choices
- What you verified and what remains uncertain
```

The "think carefully through the problem" line encourages recent Claude models to reason more deeply on hard tasks without requesting explicit chain-of-thought. Omit it from Standard and Light — reserve it for genuinely hard Deep-tier problems.

---

## Tool-Routing Awareness

After formatting, check whether the task is better suited to another tool. Brief note, not blocking.

| Signal | Suggested tool | Reason |
|--------|---------------|--------|
| Deep multi-source literature review, "find everything about X" | A dedicated deep-research tool (e.g., ChatGPT Deep Research) | Better multi-source web synthesis |
| Citation-heavy factual lookup, sourced answers | A search-first tool (e.g., Perplexity) | Inline citations, live sources |
| Heavy spreadsheet work (formulas, pivots, complex formatting) | The spreadsheet app itself, with its built-in AI if available | Native formula and pivot support |
| Video/audio analysis | A tool that processes media directly (e.g., Gemini) | Claude cannot watch or listen to media files |
| Otherwise | Proceed in Claude Code | Strong at reasoning, editing, local files |

**Normal mode:** add a brief note before executing if another tool would serve better.
**Refine mode:** note in the changes list if the refined prompt would benefit from a specific tool.
