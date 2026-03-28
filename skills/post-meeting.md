<!-- post-meeting v1.0 | sanitized from private v1.3 -->
# Post-Meeting Summary & Email

*v1.0 — Summarize a meeting transcript and draft follow-up email with decisions, action items, and next steps.*

Summarize a meeting transcript and draft a follow-up email to attendees. Run from a project directory after a meeting.

## Prerequisites

**Required:**
- **Gmail MCP** — for drafting the follow-up email

**Recommended:**
- A project `.claude/CLAUDE.md` file with team roster (names + emails) and transcript folder path
- Meeting transcripts saved as `.txt` files in a project transcripts folder

**Optional:**
- **Granola MCP** — for pulling transcripts directly from Granola instead of local files

## First-Time Setup

1. **Create a project config** at `[project-root]/.claude/CLAUDE.md` with at minimum:
   ```markdown
   # Project Name

   ## Team
   - [Name] <email@example.com> — PI
   - [Name] <email@example.com> — Research Manager
   - [Name] <email@example.com> — RA

   ## Folders
   - transcripts: `transcripts/`
   ```

2. **Create a transcripts folder** in your project directory:
   ```bash
   mkdir -p transcripts/
   ```

3. **Save meeting transcripts** as `.txt` files in that folder. Most transcription tools (Granola, Otter, etc.) can export to text. Name files with dates for easy sorting (e.g., `2026-03-15_team-sync.txt`).

## Arguments

`$ARGUMENTS` can include:
- *(none)* — most recent transcript in project's transcripts folder
- `[keyword]` — filter transcripts by keyword in filename
- `id:DOC_ID` — specific Granola document ID (bypasses local files; requires Granola MCP)
- `nosend` — show summary only, skip email drafting
- `save` — also save summary as local `.md` file in transcripts folder

## Instructions

### Step 1: Find Project Context

Read `.claude/CLAUDE.md` at **exactly** `$(pwd)/.claude/CLAUDE.md`.

Extract:
- Transcript folder path (e.g., `transcripts/`)
- Team roster — names + emails
- Project name (from header or `project_name` field)

Fields may be inside markdown code fences (` ```yaml ``` `) — extract from inside fences.

**If not found:** Offer Granola MCP fallback (if available) — don't silently walk up directories.
```
No .claude/CLAUDE.md found in this directory.
I can search Granola directly — want me to list recent meetings? (y/n)
```
If yes and Granola MCP is available: list recent meetings, then jump to Step 3 with `id:` flow.
If no Granola MCP: ask user to provide the transcript path manually.

### Step 2: Fetch Latest Transcript

**If using Granola MCP:** Search for recent meetings matching this project and fetch the transcript.

**If using local files:** List `.txt` files in the transcripts folder (excluding `archive/` subfolder), sorted by date (newest first).

### Step 3: Pick Meeting

If `id:DOC_ID` argument: use Granola MCP to fetch the document directly, skip to Step 4.

If keyword argument: filter `.txt` files in transcripts folder by keyword in filename.

Otherwise: show most recent transcript + 2-3 others for selection.

**Transcript-not-ready check:** If no transcript is newer than 30 minutes and the user didn't specify an older one:
```
Transcript may still be processing. Try again in ~10 minutes, or pick an older meeting.
```

### Step 3.5: Confirm Selection

```
Summarize "[meeting title]" from [date]? (y/n)
```
Confirm BEFORE reading the full transcript.

### Step 4: Read Transcript

Read the selected `.txt` file. If using Granola MCP (`id:` arg), fetch via the Granola transcript API.

### Step 5: Summarize

Generate structured summary with:
- 2-3 sentence overview of topics discussed
- Numbered decisions with context
- Bulleted action items with owner and deadline (if mentioned)
- Next steps

**Minimum-content gate:** If no decisions AND no action items detected:
```
This was a brief meeting with no tracked decisions or action items. Send summary anyway? (y/n)
```

**Language check:** If non-English content detected in transcript:
```
Draft in [detected language] or English? (default: English)
```

If `nosend` argument: display summary and stop here.

### Step 6: Draft Email + Confirm

Build recipient list from team roster. Default: all team members who were likely on the call (infer from transcript speaker mentions). Show recipients for confirmation.

**Sensitivity flag:** If the meeting appears to be funder-only or leadership-only (narrow attendee list, sensitive topics):
```
This appears to be a [funder/leadership-only] meeting. Review summary for sensitive content before sending.
```

Draft the email using a direct, professional tone. Avoid AI-sounding language ("delve," "leverage," "multifaceted," etc.).

**Recency-aware opener:** Meeting today -> "today's meeting"; yesterday -> "yesterday's meeting"; older -> "our meeting on [day]".

```
--------------------
POST-MEETING EMAIL
--------------------

To: [name1] <email1>, [name2] <email2>
Subject: Meeting summary: [title]

[Full draft text]

> Send as Gmail draft / Edit recipients / Edit draft / Skip
```

If `save` argument: also write summary to `[transcripts_folder]/summary-[date]-[title-slug].md`.

### Step 7: Create Gmail Draft

On approval, use Gmail MCP to create a draft:
```
mcp__google_workspace__draft_gmail_message
  to: [recipients]
  subject: Meeting summary: [title]
  body: [email body]
```

Report: "Draft created in Gmail — open Gmail to review and send."

### Step 8: Log Performance

```bash
echo "$(date +%Y-%m-%d),post-meeting,TOOL_CALLS,NOTES" >> ~/.claude-assistant/logs/skill-performance.csv
```
Replace `TOOL_CALLS` with exact count and `NOTES` with summary (e.g., `team-sync-5-actions`).

## Email Format

The email has two parts: a **summary body** (decisions, action items by person, next steps) and a **detailed meeting notes appendix** (full intellectual content as a searchable record).

**Err on the side of more detail, not less.** A longer, thorough email is better than a brief one that misses things.

```
Hi [Name(s)],

Good meeting [today/yesterday/on Monday]. Here's a summary:

**What we discussed:**
[3-5 sentence overview covering the main topics and how they connect]

**Key decisions:**
1. [Decision with enough context that someone who missed the meeting understands why]
2. [Decision with context]
3. [Decision with context]

**Action items:**

[Name 1]:
- [Task] (by [date if mentioned])
- [Task]

[Name 2]:
- [Task] (by [date if mentioned])

[Name 3]:
- [Task]

**Next steps:**
- [What happens next, including any follow-up meetings or deadlines]
- [Second next step]

Full transcript: [path to .txt file or Granola link]

Let me know if I missed anything.

[Your name]

---

## Detailed Meeting Notes

### [Topic Section 1]
[Substantive discussion: key arguments, positions taken by each participant,
analytical points, data or evidence cited. Include enough detail that someone
who missed the meeting can follow the reasoning.]

### [Topic Section 2]
[Comparative examples discussed, theoretical debates, methodological considerations]

### [Topic Section 3]
[Timeline/historical context, administrative items, logistics, resource questions]

### [Continue for all substantive topics — aim for 3-5 pages]
```

**Summary body:** Numbered lists for decisions (with context). Action items **grouped by person** so each team member can scan for their tasks.

**Detailed appendix:** Structured by discussion topic (not chronological). Include participant positions and arguments, not just conclusions. Capture analytical reasoning, not just outcomes. This serves as the meeting record — **be thorough, not brief**. Aim for 3-5 pages for a substantive meeting.

## Customization Points

- **Transcript source:** Swap Granola for Otter, Fireflies, or any tool that exports `.txt` transcripts
- **Team roster location:** Move from `.claude/CLAUDE.md` to a shared config file if you prefer
- **Email sending:** If you have a send script configured, replace the Gmail draft step with direct sending
- **Language:** The language check detects non-English content; customize the default for your team
- **Transcript folder:** Change the convention in your project `.claude/CLAUDE.md`

## Error Handling

| Condition | Action |
|-----------|--------|
| No `.claude/CLAUDE.md` | Offer Granola MCP fallback or ask for transcript path |
| No transcripts in folder | "No recent transcripts. May still be processing if you just finished a call." |
| Granola MCP unavailable | Fall back to local `.txt` files |
| Gmail draft fails | Display the email text so you can copy-paste it |
| No team roster | Ask user to type recipient emails manually |
