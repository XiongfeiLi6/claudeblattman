# Weekly Project Review
*v1.4 — Removed todo queue check; improved transcript handling; formatting checkpoint; performance logging*

Generate a comprehensive weekly summary for the current research project, pulling from multiple sources.

## Overview

This skill collects data from WhatsApp, meeting transcripts, and Gmail, then generates:
1. **Tab 1 content**: High-level project dashboard (updated directly in Google Doc)
2. **Tab 2 content**: Detailed weekly log with thematic synthesis across all sources

## Instructions

### Step 0: Read Project Configuration
- Read `.claude/CLAUDE.md` from the current project folder
- Extract ALL of: project name, Google Doc ID (`google_doc_id`), team roster, WhatsApp groups (with JIDs), folder paths, `granola_folder`, `project_keywords`, `exclude_keywords`
- Fields may appear inside ` ```yaml ` code blocks — extract values from inside code fences too
- Strip surrounding quotes from extracted values (e.g., `"Project name"` -> `Project name`)
- Extract `project_type` (default: "quantitative"). Look for `project_type: qualitative` in the config.
- If `project_type` is "qualitative", use the qualitative dashboard template (see Customization Points)
- If config is missing required fields, inform user and stop

### Step 1: Determine Date Range
- Check `10_AI_Collaboration/Weekly_Reviews/` for most recent `weekly-review-*.md` or `whatsapp-summary-*.md` file
- Use that date as start_date (or 7 days ago if none exists)
- end_date = today
- Tell user: "Generating weekly review for [start_date] to [end_date]"

### Step 1.5: Populate Transcripts (Optional)

If you have a transcript export tool (e.g., `granola-fetch`, Otter.ai export):

1. Check the project's configured transcripts folder for existing files
2. Run your transcript tool with the date range to fetch any new transcripts
   - If the project config has a `granola_folder` field, pass it as a filter
   - Strip surrounding quotes from folder names before passing
3. If fetch fails, continue with existing local transcripts

### Step 2: Collect Data (with graceful degradation)

**2a. WhatsApp Messages**
- For each group in `whatsapp_groups`:
  - Search for group using WhatsApp MCP (`list_chats`)
  - **CRITICAL**: Do NOT rely on `list_chats` metadata for last message dates — metadata is often stale
  - ALWAYS fetch actual messages using `list_messages` regardless of what metadata shows
  - Filter to messages within date range
- If WhatsApp MCP fails on first attempt: retry once (transient connection failures are common). If still unavailable: Note "WhatsApp unavailable - skipped" and continue
- Save raw messages to `10_AI_Collaboration/Weekly_Reviews/whatsapp-summary-[date].md`

**2b. Meeting Transcripts**
- Read all transcript files from the configured transcripts folder
- Support multiple formats: Granola JSON, manual markdown, Zoom .vtt files
- Parse meeting date, attendees, and content from each
- If no new transcripts: Note "No new transcripts this period"

**2c. Gmail Threads**
- **Date range**: Same as other sources
- **Filter criteria** (emails must match at least one):
  - Sender OR recipient matches any team member email in roster
  - Subject or body contains project keywords from `project_keywords` list in config
- **Exclusions**: Automated emails, calendar invites (.ics), newsletters, bulk mail; threads matching `exclude_keywords`
- **Grouping**: Group by thread to preserve conversation context
- **Feedback loop**: At end of Gmail section, list included/excluded counts for noise control
- If Gmail MCP unavailable: Note "Gmail unavailable - skipped" and continue

**2d. Sensitive Content Filtering (CRITICAL)**

The weekly summary may be shared with the full team. Screen for and exclude sensitive content from ALL sources:

**Exclude**: Critical performance comments, hiring/firing discussions, pay/compensation, personnel-specific funding decisions, anything inappropriate for full team.

**Screening by source type**:
- General team meetings: Low sensitivity — include freely
- PI-only or PI + Research Manager threads: Screen MORE AGGRESSIVELY but include non-sensitive content
- 1-on-1 transcripts: Review for sensitive topics before including

When in doubt: Omit specific sensitive content and note "[Some content omitted — PI review recommended]"

**Include freely**: Funding strategy, project decisions, action items, research design, logistics, strategic direction.

### Step 2e: Verify Key Metrics Against Authoritative Sources

**Before generating content, verify all quantitative claims.**

Priority order for factual claims:
1. **Research Design and Progress document** (if maintained) — check for verified figures
2. **Earlier weekly summaries** — if they post-date the research design doc
3. **Current week's sources** — only if #1 and #2 unavailable; FLAG if uncertain

Watch for red flags: round numbers, hedged statements, conflicting numbers, numbers without context.

### Step 2f: Read Previous Dashboard as Baseline

**The Project Status Dashboard is a LIVING DOCUMENT.**

1. Read the current dashboard content from the Google Doc (Tab 1)
2. This is your BASELINE — not a blank slate
3. PRESERVE previous content unless explicitly superseded, factually outdated, or explicitly removed by user
4. MODIFY existing sections with new information; ADD new items; REMOVE only when completed/superseded

### Step 3: Synthesize

**Detail and Length Requirements**: Scale to meeting length:
- Brief check-ins (under 20 min): 0.5-1 page
- Standard meetings (20-60 min): 1-3 pages
- Long strategy sessions (60+ min): 2-4 pages

**Guiding principle**: Include more detail when in doubt. A reader who wasn't at the meeting should understand WHAT was decided, WHY, WHO said it, and the context.

**Priority-Related Content Detection**: Watch for "strategic priority", "operational", "critical path", "green/yellow/red", "urgent", "success factor" language. Note status changes.

**FORMATTING RULES**:
- **NO MARKDOWN TABLES** — use bullet/sub-bullet format for ALL structured data
- Bold labels followed by content on same line or as sub-bullets
- **ALWAYS bold team member names** throughout both Tab 1 and Tab 2 (do NOT use `**` markdown markers in the text — track bold ranges separately and apply formatting via the Google Docs API)
- **Do NOT include** direct quotes. Paraphrase instead.
- **ASCII emoji placeholders**: Use `[RED]`, `[GREEN]`, `[YELLOW]` instead of real emoji in generated text. Real emoji are supplementary-plane Unicode that break Google Docs index calculations. They are swapped to real emoji via `find_and_replace_doc` after all content is written.

**Visual Separators**:
- Between weekly summaries: heavy double-line separator
- Within weekly summaries: medium single-line separator

**Language Guidelines**: Plain, accessible language. Avoid jargon. Use "challenges" not "blockers", "unclear" not "TBD". Prefer concrete descriptions over abstract terms.

**Generate Tab 1 (Dashboard)**: Start from previous dashboard, update with this week's info. Structure:
- Project overview and status
- Strategic objectives and progress
- Operational objectives serving each strategic goal
- Team member to-do items
- Critical success factors with status (green/yellow/red)
- Funding pipeline

**Generate Tab 2 (Weekly Log)**: New entry prepended (reverse chronological). Structure:
- Date range header
- Weekly Activity Summary (thematic synthesis across all sources)
- Detailed Meeting Records (full summaries of each meeting)

### Step 4: Save Local Copies

**Skip if `nosave` argument.**

- Save to `10_AI_Collaboration/Weekly_Reviews/weekly-review-[date].md`

### Step 5: Write to Google Doc

Proceed directly to Step 6 — do NOT display content in terminal for review. User reviews formatted content in the Google Doc.

### Step 6: Update Google Doc

**If `tab1only`:** Only execute the Dashboard Replacement phase. Skip Weekly Log Prepend.
**If `tab2only`:** Only execute the Weekly Log Prepend phase. Skip Dashboard Replacement.

**First-Time Setup**: Before first use, add these three marker lines to your Google Doc (Tab 1), each on its own line:

```
=== PROJECT STATUS DASHBOARD ===
[your dashboard content]
=== DASHBOARD END ===

=== WEEKLY SUMMARIES START ===
[weekly logs go here, newest on top]
```

**Precondition Check**: Before any writes, verify all 3 markers exist in the doc. If `DASHBOARD END` is missing, STOP and report — do not attempt to write.

**Why 3 markers**: The explicit `DASHBOARD END` marker prevents boundary corruption that occurred with the original 2-marker approach.

**6-Phase Protocol**:
1. **Preparation** — Generate text with `[RED]`/`[GREEN]`/`[YELLOW]` ASCII placeholders; strip `**` markdown bold markers (bold is applied via API, not text)
2. **Dashboard Replacement** — Delete content between `DASHBOARD` and `DASHBOARD END` markers, then insert new dashboard text (atomic batch operation)
3. **Verification** — Confirm all 3 markers are intact after the dashboard write
4. **Weekly Log Prepend** — Insert new entry at `WEEKLY SUMMARIES START` marker (newest on top)
5. **Emoji Swap** — Use `find_and_replace_doc` to replace `[RED]` with real red circle, `[GREEN]` with green circle, `[YELLOW]` with yellow circle
6. **Formatting** — Apply heading sizes and team name bolding using API-reported indices (from `inspect_doc_structure`), not calculated offsets

**CRITICAL: Do NOT skip Phase 6 (Formatting).** The document is unreadable without proper header sizes and bold formatting. After completing Phases 1-5, you MUST proceed to Phase 6. At minimum apply: (a) Tier 2 baseline format reset (11pt non-bold on full range), then (b) Tier 1 section header formatting (16pt/14pt/12pt bold).

**Formatting scope: FULL DOCUMENT.** Even when running `tab1only` or `tab2only`, Phase 6 formats the entire document. Formatting is idempotent.

**Batch operations**: Use `batch_update_doc` to combine delete + insert + format operations into a single call — this reduces 19-29 sequential API calls to 1-3.

### Step 7: Final Confirmation
1. Confirm: "Weekly review complete. Google Doc updated."
2. Provide link: "Check Google Doc: [link]"
3. Note any issues or manual fixes needed

### Step 8: Archive Processed Transcripts

After the weekly review is complete:

1. Create archive folder if needed: `[project]/10_AI_Collaboration/Transcripts/archive/`
2. Move all processed transcript files to archive
3. Confirm: "Archived X transcript(s) to Transcripts/archive/"
4. Note any files left behind (outside date range, unparseable)

## Arguments

`$ARGUMENTS` can include:
- `nosave` — Don't save intermediate files
- `tab1only` — Only generate Tab 1 dashboard
- `tab2only` — Only generate Tab 2 detailed log
- `days:N` — Override date range to last N days
- `since:YYYY-MM-DD` — Override start date
- `skipwhatsapp` — Skip WhatsApp even if available
- `skipemail` — Skip email even if configured
- `skiparchive` — Don't archive transcripts after processing

## Examples

```
/weekly-review                    # Full review, default date range
/weekly-review days:14            # Last 14 days
/weekly-review tab1only           # Quick dashboard update
/weekly-review skipwhatsapp       # Skip WhatsApp if unavailable
```

## Error Handling

- If project config missing: "No .claude/CLAUDE.md found. Please run from a configured project folder."
- If WhatsApp unavailable: Continue with other sources, note in output
- If no transcripts folder: Create it, note "No transcripts folder found - created"
- If Google Doc update fails: Save content locally, provide manual instructions
- Flag any ambiguities: "Unclear who said X - please clarify"

## Customization Points

**To set up this skill for your workflow:**

1. **Folder paths**: The default `10_AI_Collaboration/Weekly_Reviews/` path reflects one project structure. Update to match your own — e.g., `~/Research/Project/reviews/` or `docs/weekly-reviews/`.

2. **Data sources**: The skill pulls from WhatsApp, meeting transcripts, and Gmail by default. Remove or add sources in the data collection steps to match your available integrations.

3. **Google Doc format**: The 3-marker system (`=== PROJECT STATUS DASHBOARD ===`, `=== DASHBOARD END ===`, `=== WEEKLY SUMMARIES START ===`) requires markers in your Google Doc. See Step 6 for setup instructions.

4. **Dashboard template**: The default is quantitative (metrics, sample sizes, timelines). Set `project_type: qualitative` in your project config for a qualitative dashboard (thematic analysis, interview progress, coding framework).

5. **Transcript formats**: Support for Granola, Zoom .vtt, manual markdown, and informal notes. Add new format parsers as needed.

## Performance Logging

After completing all steps, log this run:
```bash
echo "$(date +%Y-%m-%d),weekly-review,TOOL_CALLS,NOTES" >> ~/.claude-assistant/logs/skill-performance.csv
```
Replace TOOL_CALLS with approximate count of tool uses this run. Replace NOTES with brief volume info (e.g., "3 transcripts 12 emails 2 whatsapp"). Do not skip this step.
