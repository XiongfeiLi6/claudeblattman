# Tips Scout
*v1.1 — 2026-02-28*

Generate a customized Grok DeepSearch prompt based on current coverage gaps and active investigation topics. Run weekly (Sunday/Monday) before `/tips-curate`. Output is a prompt to paste into Grok's DeepSearch mode.

Use when you want to generate a targeted search prompt — "scout for tips," "generate Grok prompt," "tips scout," or "what should I search for this week."

## Steps

### Step 0: Check for `base` Argument

If the `base` argument was given (e.g., `/tips-scout base`), read ONLY the base prompt file and skip to Step 5 to output it unchanged. Do not read the tips log or todo file.

### Step 1: Read All Source Files (in parallel)

Read all three files simultaneously using parallel Read calls:

1. **Base prompt**: Your Grok search prompt template file (a markdown file with search categories, key accounts, and output format instructions)
2. **Tips log**: Your collected tips log — read only the first **150 lines**. Recent entries are at the bottom, so if the file is large, read from the end. The log uses `## YYYY-MM-DD` date headers. Stop counting once you reach a date older than 14 days.
3. **Todo items**: Your active todo file — read only the "Active (Current Focus)" section. Do not read Someday/Ideas or Completed sections.

Extract the base prompt text between `## The Prompt (copy everything below this line)` and the next `---` separator. If no `---` follows, read to end of file.

### Step 2: Analyze Recent Coverage

From the tips log entries in the **last 14 days**, count entries by mapping tags to categories:

| Category | Matching Tags | Target Share |
|----------|--------------|-------------|
| Skill & Agent Architecture | `[skill-design]` or `[agent-pattern]` | 30% |
| Claude Code Features & Releases | `[tool]` (without GitHub URL) | 25% |
| Academic & Research Workflows | `[workflow]` | 20% |
| New Repos & Tools | `[mcp]` or entries with github.com URL | 15% |
| Obsidian + Claude Code | entries mentioning "Obsidian" | 10% |

Note: These categories use the same tag taxonomy defined in `/tips-curate` Step 2. A single tip can match multiple categories.

**Boost rule:**
- **BOOST**: Category has 0 entries in the last 14 days
- **DE-EMPHASIZE**: Category has 50%+ of all entries in the last 14 days
- **OK**: Everything else

**Edge case**: If entries exist but none fall within the last 14 days, treat all categories as BOOST and note: "No tips in last 14 days — all categories boosted."

### Step 3: Extract Active Topics

From the todo file's "Active (Current Focus)" section, find items marked TODO or IN PROGRESS. Extract **3-5 keyword themes** that represent what you're currently investigating.

Skip completed items. If no TODO/IN PROGRESS items are found, omit the BONUS section in Step 4 and note: "No active investigations found — skipping topic injection."

### Step 4: Customize the Prompt

Starting from the base prompt, apply these modifications:

1. **Boosted categories**: After the category's header, insert:
   > PRIORITY THIS WEEK: I haven't seen much on this topic lately — dig deeper, lower the engagement threshold, and surface anything substantive.

2. **De-emphasized categories**: After the category's header, insert:
   > I'm well-covered here this week — only surface truly exceptional or novel posts.

3. **Active topics**: Insert a new section BEFORE the `**SKIP:**` line:

```
**BONUS: ACTIVE INVESTIGATIONS**
I'm currently working on these topics — posts about any of them are especially valuable even if they don't fit the categories above:
- [topic 1]
- [topic 2]
- [topic 3]
```

4. **New key accounts**: If any tips in the last 14 days came from accounts NOT already in the base prompt's key account lists, append them to the relevant category with a note: `(new — added [date])`.

Do NOT change the FORMAT section, SKIP rules, or follow-up prompts.

### Step 5: Output

Display results in this format:

```
────────────────────
TIPS SCOUT — Customized Grok Prompt
────────────────────

Coverage analysis (last 14 days, [N] total tips):
  Skill/Agent Architecture: [N] entries  [BOOST / OK / heavy]
  Claude Code Features:     [N] entries  [BOOST / OK / heavy]
  Academic Workflows:       [N] entries  [BOOST / OK / heavy]
  New Repos & Tools:        [N] entries  [BOOST / OK / heavy]
  Obsidian + Claude Code:   [N] entries  [BOOST / OK / heavy]

Active topics injected: [comma-separated list]
New accounts added: [list or "none"]
```

Then output the customized prompt in a fenced code block:

````
```
[full customized prompt — ready to paste into Grok DeepSearch]
```
````

End with:

```
Next steps:
1. Paste into Grok DeepSearch (free tier — no Projects needed)
2. Forward best finds to yourself (email with @ToSelf label)
3. Run /tips-curate to process
```

## Error Handling

- **Base prompt file missing**: "Base prompt not found. Create a Grok search prompt template with categories, key accounts, and output format instructions."
- **Tips log missing or empty**: Use base prompt without customization. Note: "No recent tips found — using base prompt without coverage adjustments."
- **Tips log has entries but none in last 14 days**: Treat all categories as BOOST. Note in output.
- **Todo file missing**: Skip active topics injection. Note: "No todo file found — skipping topic injection."
- **Todo file has no TODO/IN PROGRESS items**: Omit BONUS section. Note in output.

## Examples

```
/tips-scout              # Generate customized Grok prompt
/tips-scout base         # Output base prompt without customization
```

## Integration Notes

- `/tips-curate` Step 4 output reminds you to run `/tips-scout` for next week
- The base prompt template defines categories, key accounts, and skip rules — edit it directly to customize
- This skill reads only; it never modifies the base prompt file
- Coverage analysis window is 14 days to smooth out weekly variation
