# Continuous Improvement

Your AI setup drifts. You learn a better prompting pattern on Tuesday, forget it by Thursday, and rediscover it a month later. Tips evaporate unless you capture them *and* convert them into config changes.

I built a pipeline to fix this. It's specific to Gmail and Claude Code, but the principle — *capture, filter, convert* — works anywhere.

---

## What this looks like in practice

Tuesday morning you see a tweet about using XML tags in multi-step prompts. You forward it to yourself. Sunday you run `/tips-curate` and it rates the tip HIGH. Two weeks later, `/tips-integrate` proposes adding an XML tag convention to your CLAUDE.md. You approve. Done.

Four steps: **scout** for new techniques, **capture** what you find, **curate** it into a rated log, **integrate** the best items into your config files.

---

## Setup

You need [Gmail MCP configured](../toolkit/mcp-setup.md) and a Gmail label called `@ToSelf`:

1. In Gmail → left sidebar → **+ Create new label** → name it `@ToSelf`
2. Optional filter: search bar filter icon → **Subject:** `@toself` → **Create filter** → **Apply label:** `@ToSelf`

Now any email with `@toself` in the subject gets tagged automatically. Forward interesting articles, email yourself quick notes, or manually label anything you want processed later. Works from any device.

---

## The four steps

### 1. Scout (`/tips-scout`)

Reads your recent tips log, finds what topics you've under-covered, and generates a targeted search prompt for [Grok DeepSearch](https://grok.com/) (or any AI search tool). Copy the prompt, run the search, forward the best results to yourself.

### 2. Capture

No skill needed. Email yourself with `@toself` in the subject. That's it.

### 3. Curate (`/tips-curate`)

Fetches unread @ToSelf emails, follows any links to fetch full content, rates each tip (High / Medium / Low), and presents a structured report. You approve or skip each one. Approved tips go into a searchable log with tags, source attribution, and a concrete action proposal.

### 4. Integrate (`/tips-integrate`)

Scans your tips log and generates proposals:

- **Type A (direct)** — A specific edit to a specific config file. Shows current state, proposed change, rationale.
- **Type B (investigation)** — Needs more research first. Lands in your [learning catalog's](#the-learning-catalog) INBOX.

Every proposal requires your approval. The skill tracks what it has processed and never re-proposes the same item.

---

## The learning catalog

The tips log captures discoveries. The learning catalog captures decisions — what's worth doing, what you've tried, what you've dismissed.

Type B proposals land in an **INBOX** section. You review them periodically (I do it biweekly) and promote each to the right tier:

| Tier | Meaning |
|------|---------|
| **HIGH** | Clear payoff, do soon |
| **MEDIUM** | Worth evaluating, not urgent |
| **LOW** | Not worth pursuing now; kept for reference |
| **DONE** | Implemented and working |
| **REJECTED** | Assessed and dismissed; won't resurface |

Items always enter via INBOX — the skill doesn't make priority calls on your behalf.

---

## Example: from email to proposal

A curated tip entry in the log:

```markdown
## 2026-02-20

### Boris Tane's Research-Annotate-Implement Workflow [workflow] [prompting] [skill-design] [high]
- **Source:** Boris Tane (@boristane) blog post (Feb 15, 2026)
- **Insight:** 3-phase Claude Code methodology: (1) Deep research with findings
  in persistent markdown files, (2) Annotation cycle — add inline notes to
  Claude's plan correcting assumptions, rejecting approaches, injecting domain
  knowledge (repeat 1-6 times), (3) Execute with "implement it all" only after
  plan is approved.
- **Action:** Compare annotation cycle against current plan-mode workflow.
- **URL:** https://boristane.com/blog/how-i-use-claude-code/
```

The integration proposal it generates:

```
────────────────────
INVESTIGATION PROPOSAL [2 of 5]
────────────────────
Source: tips
Item: Boris Tane's Research-Annotate-Implement Workflow
Task: Compare the annotation-cycle pattern against current plan-mode workflow.
  Design a /plan-annotate skill or modify /review-plan to support iterative
  annotation on saved plan files.
Destination: learning catalog INBOX
Rationale: Current plan mode is chat-based; structured annotation on a
  persistent document may produce better plans for complex tasks.
```

---

## When to run

| Skill | Frequency | Trigger |
|-------|-----------|---------|
| `/tips-scout` | Weekly | Before `/tips-curate`, to generate a search prompt |
| `/tips-curate` | Weekly | When you have unread @ToSelf emails |
| `/tips-integrate` | Biweekly | After a curate session or two |

No rigid schedule. The integrate skill warns you if tips are stale.

---

## Install

From the [Skill Library](../setup/skill-reference.md#tips-scout-search-prompt-generator):

| Skill | MCP needed | Notes |
|-------|-----------|-------|
| [`/tips-scout`](../setup/skill-reference.md#tips-scout-search-prompt-generator) | None | Filesystem only |
| [`/tips-curate`](../setup/skill-reference.md#tips-curate-tip-curation) | Gmail MCP | Reads and marks @ToSelf emails |
| [`/tips-integrate`](../setup/skill-reference.md#tips-integrate-tip-integration) | None | Includes a `references/` subdirectory |

---

## Browse real examples

These are the kinds of workflows and resources the pipeline is designed to capture and evaluate. Worth browsing to see what's out there:

- **[Boris Tane: How I Use Claude Code](https://boristane.com/blog/how-i-use-claude-code/)** — The research-annotate-implement workflow. One of the highest-rated tips in my log.
- **[Anthropic's Official Skills Library](https://github.com/anthropics/skills)** — Anthropic's own example skills, including a document plugin for PDFs and spreadsheets.
- **[Awesome Claude Skills](https://github.com/travisvn/awesome-claude-skills)** — Community-curated list of skills, patterns, and tools. Good scouting territory.
- **[Anthropic Skills Cookbooks](https://github.com/anthropics/claude-cookbooks/blob/main/skills/README.md)** — Tutorial notebooks for building custom skills from scratch.

---

## Customization

**`/tips-curate`:** Tips log location, Gmail label name, batch size, quality thresholds — all configurable by editing the skill file directly.

**`/tips-integrate`:** Source selection, state file location, target config files, pruning intervals — same approach, edit the markdown.

---

!!! tip "The other input channel: your own corrections"
    This pipeline is *proactive* — scheduled discovery. Your system also learns *reactively*: when you override a classification, substantially edit a draft, or manually do something a skill should handle, a self-improvement protocol proposes targeted config changes on the spot. Scheduled scouting from outside, continuous feedback from inside.

## See also

- **[Collected Tips & Research Log](../downloads/collected-tips-log.md)** — A snapshot of my own tips log. Searchable by keyword, tag, or date.
- **[`/review-plan` — Stress-Test Any Plan](../workflows/plan-review-browser.md)** — Pairs well with the pipeline: curate ideas, then review plans before implementing.
- **[Skill Design Patterns](../downloads/skill-patterns.md)** — How production skills are structured, if you want to build your own.
