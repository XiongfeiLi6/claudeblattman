---
description: First-run guide for the Claude Blattman desktop agent starter kit. Starts with Claude Code; Codex is optional after the first handoff.
---

# Start Here: Desktop Agent Starter Kit

This page is for your first hour with Claude Code. If you also downloaded
**Codex**, keep it for the second check. Codex is useful soon, but the first
session works best when you learn one loop in one app.

The goal is not to learn every feature. The goal is to make one folder usable:
open it, ask clearly, review the plan before anything changes, do one small
piece of work, and leave a handoff note so the next session can resume.

Minimum path for day one: Claude Code, one safe practice folder, and one
handoff. After that, choose one real project and one artifact you actually want
to keep.

<div class="starter-path" markdown>
<label><input type="checkbox"> I have Claude Code installed and signed in.</label>
<label><input type="checkbox"> I have one safe practice folder ready.</label>
<label><input type="checkbox"> I will not use private research, participant, medical, legal, school, or financial records in the first practice run.</label>
</div>

<div class="starter-progress" markdown>
<div class="starter-progress__label"><span data-starter-progress-label>0 of 10 steps complete</span></div>
<div class="starter-progress__bar"><span data-starter-progress-fill></span></div>
<button type="button" class="starter-progress__reset" data-starter-reset>Reset checklist</button>
</div>

## What To Open First

Start with **Claude Code**. Use **Codex** after you understand the basic loop, or
when you want a second app to inspect the same folder.

In this guide, **Claude Code** means the agent inside the Claude desktop app that
can open a folder on your computer and act on its files — not a plain chat window.
If your Claude window can't open or attach a local folder, you're in a plain chat,
not Claude Code; switch to Claude Code before continuing. **Codex** is optional; it
is not part of the first 30 minutes.

<div class="starter-card" markdown>
### Claude Code: main workbench

Use Claude Code for the first session. It is where the starter kit gives you
slash commands:

- `/prompt` turns a rough request into a clear task.
- `/review-plan quick` checks the plan before action.
- `/done` writes `HANDOFF.md` so you can continue later.
- `/kit-setup` checks optional Codex/Gemini second opinions.

</div>

## The First Folder

Create a folder whose contents are safe for practice. Put one harmless file in
it: a meeting agenda, a draft memo, a reading list, or a small todo list.

This practice folder is rehearsal. Your durable workspace can come next:

```text
Mac: Documents/AI_Projects/ or a cloud-synced AI_Projects folder
PC: Documents\AI_Projects\ or a cloud-synced AI_Projects folder
```

Use a synced folder only if you want the same projects available on more than
one machine. Do not open the whole synced root; open the one project folder.

**Do not open your whole Documents folder, Dropbox folder, desktop, home folder,
or research project folder for the first run. Create a brand new empty practice
folder. If making a `.md` file is annoying, a plain text file is fine.**

Good first folder:

```text
Documents/AI Practice/
  first-task.md
```

Put this in `first-task.md`:

```markdown
# First task

- Safe thing I want help with:
- File Claude Code may edit:
- Files/folders Claude Code must not touch:
```

Do not use this first folder for:

- research-participant or human-subjects data
- confidential transcripts
- private contact rosters
- inbox exports
- school, medical, legal, or financial records
- anything you would not paste into another AI service

## Install The Claude Starter Kit

If Chris sent you pilot instructions, use those. For the public version, install
the Claude Code plugin first.

In Claude Code, paste these two lines into the app:

```text
/plugin marketplace add chrisblattman/claudeblattman
/plugin install starter-kit@claudeblattman
```

Then run:

```text
/kit-hello
```

You should see a short confirmation that the starter kit is installed and the
commands are available. If instead you get "unknown command," the plugin didn't
install — re-run the two `/plugin` lines above, then try again.

You can stop here for the first session. Codex setup is optional after the first
handoff.

## Starter Commands

The starter kit adds short commands to Claude Code. If you are in the pilot, use
the install instructions Chris sent before the session. In the public release,
install the `starter-kit` plugin first.

If a command is missing, do not stop. Type the plain-English fallback shown
below. The workflow matters more than the shortcut.

| App | Starter shortcut | Plain-English fallback |
|---|---|---|
| Claude Code | `/prompt` | "Turn this rough request into a clear task, then make a short plan before editing." |
| Claude Code | `/review-plan quick` | "Review this plan before we act. Find risks, missing steps, and a safer sequence." |
| Claude Code | `/done` | "Write or update HANDOFF.md with status, next steps, key files, and decisions." |

## First Run In Claude Code

Follow these steps in order. If the app asks whether to trust or allow access to
the folder, approve only the practice folder. If the app asks for access,
approve only `Documents/AI Practice/`. Do not approve your whole Documents
folder.

<div class="starter-steps" markdown>

<label><input type="checkbox"> Open Claude Code.</label>
<label><input type="checkbox"> Open or attach your practice folder.</label>
<label><input type="checkbox"> Confirm Claude can see the file list.</label>
<label><input type="checkbox"> Paste the first prompt below.</label>
<label><input type="checkbox"> Read the plan before approving changes.</label>
<label><input type="checkbox"> Let it do one small step.</label>
<label><input type="checkbox"> Run `/done` and inspect `HANDOFF.md`.</label>

</div>

To confirm folder access, paste:

```text
Can you see this folder? List only the filenames you can read. Do not open file
contents yet.
```

Paste this:

```text
/prompt I am learning to use Claude on this folder. Read the files first.
Help me choose one small useful task we can finish in 15 minutes. Before
editing anything, make a short plan and ask me to approve it.
```

After Claude Code gives a plan, run:

```text
/review-plan quick
```

When one small step is complete, run:

```text
/done
```

Open `HANDOFF.md`. That file is the point of the exercise: it proves the next
session can pick up where this one stopped.

**Next time:** reopen the same folder and ask Claude Code to read `HANDOFF.md`
first. That's how every future session starts — it's the whole reason you wrote
the file.

## Choose A Real Project

After the practice handoff works, pick one real project and one artifact. The
practice folder was the rehearsal; the real project is the destination.

Good starter projects have four traits:

- one folder, app, or account family in scope
- one useful artifact at the end
- no external sends, deletes, shares, or calendar changes without approval
- real enough that you would keep the result

Examples:

| Area | Good first project | Useful artifact |
|---|---|---|
| Personal | Update a personal website, bio, resume, or profile | `PROFILE_DRAFT.md` or a revised page |
| Personal | Plan a trip, event, move, or household project | checklist, options table, itinerary |
| Professional | Prepare for one meeting using Calendar, Gmail, and Drive | `MEETING_PREP.md` |
| Professional | Turn messy notes into a memo or action plan | `DECISION_MEMO.md` or `NEXT_ACTIONS.md` |
| Research | Index a project folder, repo, or safe literature folder | `PROJECT_INDEX.md` |
| Research | Review a draft, protocol, codebook, or technical plan | `REVIEW_MEMO.md` |

For research teams, keep human-subjects, beneficiary, private contact, and
sensitive organizational data out until the storage and approval rules are
clear. Use safe notes, public papers, dummy data, or a bounded project folder
first.

Once you authorize a folder or connector, you do not need to hunt for every
file manually. Ask Claude or Codex to find the relevant files, emails, calendar
events, or Drive docs, then show you the paths or links before it acts.

## If Something Looks Scary

<details>
<summary>Claude Code or Codex asks for folder access</summary>

Approve access only to the practice folder. Do not approve your whole home
folder, Dropbox root, email exports, or research-data folders during the first
session.
</details>

<details>
<summary>A command is missing</summary>

Use plain English instead. The skill may not be installed yet, or the app may
need a restart. The workflow still works if you type the instruction yourself.
</details>

<details>
<summary>Codex or Gemini is unavailable</summary>

That is normal. Claude Code-only and Codex-only workflows are complete. Optional
second opinions can wait.
</details>

<details>
<summary>The app wants to send an email, message, or external request</summary>

Stop and ask for a draft first. Nothing should be sent outside your computer
without your explicit approval.
</details>

## The 30-Minute Session

Use this agenda if someone is sitting with you.

| Minute | Action |
|---:|---|
| 0-5 | Open the practice folder in Claude Code and confirm the app can see files |
| 5-10 | Run `/prompt` on one real but safe task |
| 10-15 | Run `/review-plan quick` and choose one small action |
| 15-25 | Let Claude complete only that small action |
| 25-30 | Run `/done`, open `HANDOFF.md`, and stop |

That is enough for day one. The advanced material can wait until the handoff
loop feels natural.

## Not Before The First Handoff

Do not start with MCP setup, a broad skill library, deep research, recall, or
multi-agent councils. Those are useful later, but they are not the first move.

Gmail, Calendar, Drive, GitHub, Granola, or similar connectors can be useful
early if you have a real task and you understand the scope. Start with one
connector family, ask for read-only discovery first, and require approval before
the app sends, shares, deletes, edits someone else's document, or changes a
calendar event.

## Later: Codex And Second Opinions

Use this section after the Claude Code handoff loop feels natural.

??? note "Optional after your first handoff: install the Codex starter pack"

    In Terminal:

    ```bash
    git clone https://github.com/chrisblattman/claudeblattman.git
    cd claudeblattman/codex-starter
    python3 install-codex-starter.py install
    ```

    Restart Codex after that install. Then open the same practice folder in
    Codex and ask:

    ```text
    $prompt Read the files in this folder and tell me what changed since the
    handoff. Do not edit anything yet. Suggest one small next step.
    ```

    If `$prompt` is not available yet, use plain English:

    ```text
    Read this folder and the HANDOFF.md file. Tell me the current state and the
    first safe next step. Do not edit anything yet.
    ```

??? note "Optional after the basic loop: second opinions"

    Second opinions are useful, but they are not part of the first 30 minutes.

    - In Claude Code, `/kit-setup` checks whether optional Codex or Gemini command-line
      tools are installed and usable.
    - In Claude Code, `/codex` and `/gemini` ask one outside model a question.
    - In Codex, `$ask-agents` can ask Claude or Gemini.

    Do not send confidential, personal, research-participant, or unpublished
    sensitive material to outside models. If a task is sensitive, keep it inside
    the main app and use generic descriptions. Even on non-sensitive material,
    the starter kit asks you to confirm before sending the prompt to another AI
    service.

??? note "Optional after connectors are working: context recovery"

    Once a folder or connector is authorized, you can ask the app to find the
    materials instead of searching manually:

    ```text
    Find the most relevant files, emails, calendar events, and Drive docs for
    this project. Show me the paths or links first. Do not edit, send, share,
    delete, or change calendar events.
    ```

    Then ask for a plan:

    ```text
    Based on those sources, propose one useful artifact we can finish today.
    Make a short plan and ask before editing anything.
    ```

<script>
(function () {
  var key = "starter-kit-first-run-v1";
  var boxes = Array.prototype.slice.call(
    document.querySelectorAll(".starter-path input[type='checkbox'], .starter-steps input[type='checkbox']")
  );
  var fill = document.querySelector("[data-starter-progress-fill]");
  var label = document.querySelector("[data-starter-progress-label]");
  var reset = document.querySelector("[data-starter-reset]");

  function save() {
    try {
      localStorage.setItem(key, JSON.stringify(boxes.map(function (box) { return box.checked; })));
    } catch (error) {}
  }

  function update() {
    var done = boxes.filter(function (box) { return box.checked; }).length;
    var total = boxes.length;
    var pct = total ? Math.round((done / total) * 100) : 0;
    if (fill) fill.style.width = pct + "%";
    if (label) label.textContent = done + " of " + total + " steps complete";
    save();
  }

  try {
    var saved = JSON.parse(localStorage.getItem(key) || "[]");
    saved.forEach(function (checked, index) {
      if (boxes[index]) boxes[index].checked = Boolean(checked);
    });
  } catch (error) {}

  boxes.forEach(function (box) {
    box.addEventListener("change", update);
  });

  if (reset) {
    reset.addEventListener("click", function () {
      boxes.forEach(function (box) { box.checked = false; });
      update();
    });
  }

  update();
})();
</script>
