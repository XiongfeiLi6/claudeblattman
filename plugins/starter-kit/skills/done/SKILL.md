---
name: done
description: "Close out a work session: write a short HANDOFF.md snapshot so the next session picks up where this one left off. Run at the end of any substantive session."
---

# Done — end-of-session handoff

Close out this session. Plain Write tool only — no scripts, no state files, no routing logic. Everything stays in the current folder.

1. **Summarize the session from the conversation:** what we worked on, where it stands, what was decided, and the next concrete steps.

2. **Overwrite `./HANDOFF.md`** — it's a snapshot, not a log, so replace the whole file. 30 lines maximum, exactly these sections:

   ```
   # Handoff — <project>

   ## Status
   ## Next steps
   - [ ] <one concrete step a fresh session could start on without asking questions>
   ## Key files
   ## Decisions
   ```

   A few short lines per section. Next steps are checkboxes, most important first; leave finished items out. Key files = the handful of files the next session should open first.

3. **If `./SESSION_LOG.md` exists**, also append a dated entry of 3–6 bullets — what happened this session. Append at the end; never edit earlier entries. (If the file doesn't exist, skip this — don't create it.)

4. **End by telling the user:** "Next session, open this folder and I'll read HANDOFF.md to pick up where we left off."
