---
model: sonnet
---
# Tips Integrate
*v1.2 — 2026-02-28 — Simplified — reduced redundancy and verbosity*

Convert collected tips, reference pack recommendations, and session follow-ups into concrete system improvements. Use after running `/tips-curate` or when you want to apply accumulated AI workflow learnings.

## CRITICAL: No Permission Prompts

**DO NOT use Task agents or ToolSearch.** Use only: Read, Edit, Write, Glob, Grep.

## Arguments

`$ARGUMENTS` options (if no `source:`, scan all):
- `source:tips` — Only tips log (includes medium-rated items)
- `source:refs` — Only reference packs
- `source:session` — Only session log
- `dryrun` — Show proposals without writing
- `since:YYYY-MM-DD` — Only items after this date
- `compact` — Prune old state entries, then stop

## Instructions

### Phase 0: Pre-Checks

0. **Tips freshness check:** Search `~/.claude-assistant/logs/skill-performance.csv` for most recent `tips-curate` row.
   - File missing/unreadable: skip check, proceed.
   - No entry found: warn "Tips have never been curated. Run `/tips-curate` first." Offer yes/skip.
   - Entry >14 days old: warn with date, offer yes/skip.
   - ≤14 days: proceed silently.

1. **State file** at `~/.claude-assistant/state/integrate-state.json` — read or create with default structure (see below). Extract `last_run` for filtering.

2. **Auto-prune:** Remove `deferred_items` >90 days old; strip `change_summary` from `integrated_items` >6 months old. If `compact` argument: save, report counts, STOP.

3. **System inventory** — Glob for file **names only** (do NOT read contents):
   - `~/.claude/commands/*.md` and `~/.claude-assistant/rules/*.md`

4. **CLAUDE.md inline triggers** — Read only the "Inline triggers" section through the next `---` for dedup.

### Phase 1: Scan Sources

**Read `references/scanning-rules.md` first** — it has tag-to-target mappings, the direct-vs-investigation heuristic, and source-specific parsing logic. Follow those rules for all parsing details below.

**Context budget (IMPORTANT):**
- Tips/session log: only entries since `last_run` (first run: last 30 days)
- Reference packs: only `actionable.md` or `direct_advice.md`
- **NEVER read target file contents during scanning** — full reads happen in Phase 4

Skip any item whose `item_key` appears in state file's `integrated_items` or `deferred_items`.

**Sources** (skip gracefully if any source file is missing):

| Source | Path | Key format | Notes |
|--------|------|------------|-------|
| A: Tips | `~/.claude-assistant/tips/collected-tips-log.md` | `YYYY-MM-DD::Title` | Default: `[high]` only; `source:tips` includes `[medium]` |
| B: Ref packs | `~/.claude-assistant/reference-packs/*/` | `ref-pack:dirname::rec-title` | Needs `actionable.md` or `direct_advice.md` |
| C: Session log | `~/.claude-assistant/logs/session-log.md` | `session:YYYY-MM-DD::text-60chars` | Unchecked `- [ ]` items with infrastructure keywords only |

### Phase 2: Generate Proposals

Use the direct-vs-investigation heuristic from `references/scanning-rules.md`. **When in doubt, choose Type B** — vague direct edits are worse than honest "needs research" tasks.

**Type A — Direct** (names a specific existing file + concrete bounded change <10 lines):
```
DIRECT [N/M] | Source: [...] | File: [path]
Item: [title]
Current: [3-5 lines from target — read ONLY for Type A]
Change: [diff-style preview, <10 lines]
Rationale: [1 sentence]
```

**Type B — Investigation** (directional but needs research/design first):
```
INVESTIGATION [N/M] | Source: [...]
Item: [title]
Task: [1-2 sentences — what to research/design]
Rationale: [1 sentence]
```
Investigation tasks go to `~/.claude-assistant/tasks/todo-items.md`.

For Type A only: read the specific target file section (not entire file) for `Current:` field.

### Phase 3: Batch Present

- No items found: "No new items to integrate. [N] previously processed." STOP.
- `dryrun`: show proposals, STOP.

Otherwise, group by type (Direct: skills/rules/CLAUDE.md; Investigation: new skills/research) and present numbered list:

```
INTEGRATE REVIEW — [N] proposals from [M] sources

DIRECT: [numbered list with file + change preview]
INVESTIGATION: [numbered list with task summary]
Skipped: [N] previously processed

Apply which? (1,3,5 / all direct / all investigate / all / none / defer 2,4)
```

**Wait for the user's response before proceeding.**

### Phase 4: Execute Approved Changes

- **Direct:** Read full target file, apply edit, record in state as `integrated_items` (`type: "direct"`, `change_summary`).
- **Investigation:** Append to `~/.claude-assistant/tasks/todo-items.md` under `## Active (Current Focus)` as `- [ ] **[Title]** — [description]. *(Source: /tips-integrate, YYYY-MM-DD)*`. Record in state (`type: "investigation"`).
- **Deferred/rejected:** Record in state with reason (user's words or "deferred"/"rejected").

Save updated state file.

### Phase 5: Report & Log

Show: direct changes applied (file + summary), investigation tasks added, deferred count, skipped count, sources scanned, next run date (2 weeks).

Log: `echo "$(date +%Y-%m-%d),tips-integrate,~TOOL_CALLS,[N]-direct-[M]-investigate-[K]-deferred" >> ~/.claude-assistant/logs/skill-performance.csv`

## State Management

**File:** `~/.claude-assistant/state/integrate-state.json`

```json
{
  "schema_version": 1,
  "last_run": "2026-02-22",
  "integrated_items": [
    { "source": "tips", "item_key": "2026-02-20::SDD Pattern", "date_integrated": "2026-02-22",
      "target": "todo-items.md", "type": "investigation", "change_summary": "Added as dev task" }
  ],
  "deferred_items": [
    { "source": "tips", "item_key": "2026-02-20::Volt Tool", "date_deferred": "2026-02-22",
      "reason": "Tool not mature enough" }
  ]
}
```

## Error Handling

General rule: missing source files are skipped gracefully with a note. Missing state file or todo-items.md are created fresh. Corrupt state file triggers a warning and fresh creation. Target file missing for a direct edit skips that proposal with a warning.

## Integration Points

| Skill | Role |
|-------|------|
| `/tips-curate` | Upstream — collects and rates tips |
| `/done` | Upstream — writes session log follow-ups |
| `/skill-inventory` | Downstream — reflects changes |
| `self-improvement.md` | Complementary — reactive in-session corrections |
| `todo-items.md` | Downstream — receives investigation tasks |
