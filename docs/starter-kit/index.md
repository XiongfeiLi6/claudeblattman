---
description: First-run guide for the Claude Blattman starter kit. Pick one agent — Codex or Claude Code — learn one loop, add the second later.
---

# Start Here: Desktop Agent Starter Kit

The whole kit is one habit. Point an AI agent at a real folder, make it show you its plan before it changes anything, approve one small piece of work, and leave a note so the next session resumes where you stopped. Learn that and you have the kit — the connectors, the second opinions, the slash-command shortcuts are accelerants you add later.

The first session has one job, and it is not a tour of features. It is one real, useful thing finished — a brief, a memo, a cleaned-up draft, something you would actually keep — done in a way you can repeat tomorrow without anyone sitting next to you.

This page assumes you are doing it alone, on a Mac or a Windows PC, and have never opened a terminal. Where a step differs by computer, you'll see **macOS** and **Windows** spelled out side by side — follow your own. Every step that usually trips people up has its own "if this happens" note. The work stays inside one folder you choose, and the agent shows you each change before it makes it — so the worst case is a messy file in your practice folder, not damage to your computer.

## Pick one agent to start

Two agents do this well. Start with one: learn the loop in a single app before you add the second.

<div class="starter-card" markdown>
### Codex — the easiest start

Download the Codex app, sign in with your ChatGPT account, open a folder. No terminal, nothing else to install. Start here if you want the smoothest on-ramp, or if you don't have a paid Claude plan.
</div>

<div class="starter-card" markdown>
### Claude Code — the most built-in shortcuts

The Claude desktop app's **Code** tab gives you the kit's commands once you do a one-time setup. It needs a paid Claude plan (Pro or higher). Start here if you want the curated workflows and don't mind four pasted lines.
</div>

The loop below is identical in both. Pick the one that fits, get it working, then add the other — they are better as a pair: one does the work and writes the handoff, the other opens the same folder and checks it.

<div class="starter-path" markdown>
<label><input type="checkbox"> I picked one agent (Codex or Claude Code) and signed in.</label>
<label><input type="checkbox"> I made one safe, local practice folder — something real but low-stakes.</label>
<label><input type="checkbox"> I will keep private research, participant, medical, legal, school, and financial records out of this first run.</label>
</div>

<div class="starter-progress" markdown>
<div class="starter-progress__label"><span data-starter-progress-label>0 of 10 steps complete</span></div>
<div class="starter-progress__bar"><span data-starter-progress-fill></span></div>
<button type="button" class="starter-progress__reset" data-starter-reset>Reset checklist</button>
</div>

## The loop, in plain English

The habit is the same whichever agent you chose:

1. Open the one folder you want to work in — not your whole computer.
2. Ask the agent to read what's there before it proposes anything.
3. Ask for a short plan, and read it before you approve.
4. Let it do one small piece of work.
5. Have it leave a `HANDOFF.md` — a note to yourself so the next session continues.

Plain English carries all of this. The kit's slash commands are shortcuts for these steps, not magic; if one isn't there yet, type the instruction yourself and the loop still works.

## Set up the agent you picked

??? note "Codex (easiest): download, sign in, open a folder"

    1. Download the **Codex desktop app** from [OpenAI's official Codex app page](https://developers.openai.com/codex/app) and open it. **On a Mac:** pick **Apple Silicon** unless your Mac is from before 2020 (if unsure, Apple menu → About This Mac tells you which). **On Windows:** use the Microsoft Store link on that page. Either way you want the desktop **app** — a normal application you double-click — **not** the "Codex CLI"; if you come across command-line install instructions for Codex, ignore them for day one.
    2. Sign in with your ChatGPT account — no API key, no terminal. Your browser may open and your computer may ask you to confirm or to store the login (macOS Keychain / Windows Credential Manager); that's normal, approve it.
    3. Open or attach your project folder — **File → Open**, or drag the folder onto the app window. You are ready for the loop above.

    The kit's Codex extras (`$prompt`, `$ask-agents`) are optional and come later. Plain English is enough for the first session.

    One honest tradeoff, from setting both up for real: Codex is the smoother start, but its kit extras are lighter than the Claude side — `$prompt` is a simpler cousin of Claude's `/prompt`, and the Codex pack takes its own small install. Codex gets you moving fastest; Claude Code gives you the richer shortcuts. That gap is the real reason you end up wanting both.

??? note "Claude Code (most shortcuts): get the app, then add the kit"

    **First, the app.** Download and open the **Claude desktop app** (Mac or Windows), then sign in. First sign-in opens your browser, and your computer may ask to store the login (macOS Keychain / Windows Credential Manager) — that's normal; approve it. Then look for the **Code** tab in the app. **On Windows:** the Code tab's local sessions need **Git** installed first — get it from [git-scm.com](https://git-scm.com/downloads/win) and run the installer with its defaults (most Macs already have Git).

    **Don't see a Code tab?** It needs a paid Claude plan (Pro or higher) — the free plan doesn't show it. If you've signed in and there's no Code tab, that's usually an account/plan issue, not a mistake you made. Either upgrade, or use **Codex** above for day one (it runs on a standard ChatGPT account). The Code tab *is* Claude Code; once you see it, you can run the whole loop in plain English right now.

    **To get the kit's shortcuts, add the plugin.** On current app versions you can do this without the Terminal — try this first:

    1. Open **Customize → Plugins**.
    2. Under **Personal plugins**, click **"+" → Add marketplace → "Add from a repository"**, and enter `chrisblattman/claudeblattman`.
    3. Click **Browse plugins**, find **starter-kit**, and **Install**.
    4. In the Code tab, type `/kit-hello`. If it answers, you're done — you can stop here.

    **Don't see those panels, or `/kit-hello` doesn't answer?** Some app versions don't have the in-app installer yet — that's fine, and not something you did wrong. Don't troubleshoot it; do it once in your computer's command line instead, where these commands always work. **On a Mac:** open **Terminal** (⌘-Space, type "Terminal", press Enter). **On Windows:** open **PowerShell** (press the Windows key, type "PowerShell", press Enter). A plain window opens — it's just a place to paste text, and these commands cannot harm your computer. Paste them **into that window, not into Claude**, one at a time:

    **On a Mac**, paste:

    ```bash
    curl -fsSL https://claude.ai/install.sh | bash
    ```

    **On Windows** (into PowerShell), paste:

    ```powershell
    irm https://claude.ai/install.ps1 | iex
    ```

    Both are Anthropic's official installer — they install Claude's command-line helper into your account only, no admin password, nothing system-wide. (Want to see what the Mac one does first? Open <https://claude.ai/install.sh> in a browser and read it.) If that line makes you uneasy, skip Claude Code for day one and use the Codex path — nothing else here depends on it. The install can sit for up to a minute with little output; that's normal — wait for the prompt to come back before the next line.

    Close Terminal, open a new window, and check it:

    ```bash
    claude --version
    ```

    "command not found" (Mac) or "not recognized" (Windows) is common and does **not** mean you broke anything. **On a Mac**, your PATH needs one line: run `echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc` (older Macs on bash: `~/.bash_profile`), then reopen Terminal. **On Windows**, the installer sets the PATH for you — just fully close PowerShell and reopen it (or restart the PC). Run `claude --version` again; once it prints a version, add the kit — the same two commands on both:

    ```bash
    claude plugin marketplace add chrisblattman/claudeblattman
    claude plugin install starter-kit@claudeblattman
    ```

    Each line prints a short ✔ and may pause a few seconds — normal. Back in the Code tab, type `/kit-hello` to confirm; if it's missing, fully quit and reopen Claude, then try again. You won't need the command line after this. (macOS commands verified 2026-06-13 on a clean install, Claude Code v2.1.x; the Windows PowerShell installer and the in-app plugin steps follow Anthropic's current docs.)

    Either way it's a one-time setup. Once the plugin is in, the kit's commands are native to the Code tab — `/prompt` to sharpen a rough request, `/review-plan` to pressure-test the plan, `/done` to write the handoff, `/council` for a panel of critics. They work cleanly because Claude Code is built to carry them.

## Your first folder

Make the folder in your file manager. **On a Mac:** open Finder, go to your **home folder**, and choose **File → New Folder**. **On Windows:** open File Explorer (Windows key + E), go to **This PC → Local Disk (C:) → Users → your name**, and click **New → Folder**. Name it `AI Practice` either way. Use a **local** folder — not one inside Dropbox, iCloud Drive, Google Drive, or (on Windows especially) **OneDrive**. Windows often syncs your Desktop and Documents into OneDrive by default, and that sync can corrupt files while the agent edits them. A synced folder shows a little cloud icon; a local one doesn't. If you're unsure, make the folder straight in your home/user folder — that's the safe bet.

You don't have to create files by hand. Drop in a couple of rough notes if you have them, or just point the agent at the empty folder and say *"create a file called `notes.md` with a few rough notes about X,"* and let the loop start there. (Making a plain `.md` file by hand is fiddly — on a Mac, TextEdit and Word save the wrong format; on Windows, Notepad sneaks in a hidden `.txt` unless you set "Save as type: All Files" — so just let the agent create it.)

The safest first task makes something *new* — turn a few rough notes into a one-page summary, a messy draft into a clean memo, or an empty folder into a project outline — so nothing you already have can be touched. Keep out of this first run: research-participant or human-subjects data, confidential transcripts, private contact lists, inbox exports, and school, medical, legal, or financial records. If a task is sensitive, it is not a first-session task.

## Run the loop

**Opening the folder.** In Codex, use **File → Open** or drag the folder onto the window. In Claude Code's Code tab, use its **Open folder** control or drag the folder in. When the app asks permission, **approve only the `AI Practice` folder** — if it asks for anything wider (all of Documents, your home folder, Dropbox), decline and point it at the one folder.

<div class="starter-steps" markdown>

<label><input type="checkbox"> Open your agent and attach the practice folder.</label>
<label><input type="checkbox"> Confirm it can see the file list, nothing more.</label>
<label><input type="checkbox"> Ask it to read the files and propose one small task.</label>
<label><input type="checkbox"> Read the plan before you approve anything.</label>
<label><input type="checkbox"> Let it finish one small piece of work.</label>
<label><input type="checkbox"> Have it write `HANDOFF.md`, then open the file.</label>
<label><input type="checkbox"> Stop. That is a complete first session.</label>

</div>

Paste this to start — in Claude Code, `/prompt` does the same thing:

```text
Read the files in this folder first. Help me pick one small, useful thing we can
finish in fifteen minutes. Before you change anything, show me a short plan and
wait for my okay.
```

When it proposes a plan, push back before you approve:

```text
What are the top risks in this plan, and what is the safest first step? Don't edit yet.
```

When one small step is done, have it write the handoff. In Claude Code, `/done`:

```text
Write HANDOFF.md in this folder: current status, what you changed, decisions, and
the next step for a future session.
```

You'll know it worked when a new file — `HANDOFF.md` — appears in your `AI Practice` folder. Open it: that file is the point of the exercise — it proves the next session can pick up where this one stopped. Next time, start by asking the agent to read it first.

## You are the stop button

The agent pauses before it edits a file, runs a command, or sends anything outside your computer. That pause is the safety model, and it only works if you read it. The rule that matters most: nothing leaves your machine — no email, no message, no share — without your explicit yes. If the agent offers to send something, ask for the draft first.

The rest is scope. Approve access to the one project folder, never your whole home folder, Dropbox, or email. Reading and drafting are safe; editing or deleting an existing file should stop for your okay — and if something precious might change, have the agent work on a copy.

Here is what the agent actually puts in front of you. Reading files is free and silent — it never interrupts to read. Editing a file, running a command, or reaching outside the folder stops and shows you the change first. Approve the ones you understand; deny, or ask for a plan, when you don't.

Two settings are worth knowing by name. **Default mode** asks before every change — leave it there. It is the safety, not a nuisance. There are faster modes that auto-approve edits, but they also auto-approve deletes and moves, so keep them off until the loop is second nature. And the first time you point the agent at a folder, it asks permission for *that folder* — grant the one project folder and nothing wider.

And if something does go wrong: tell the agent plainly, *"undo your last change and show me what you restored."* Because you are working on new files in one folder, nothing important is at risk — but the undo is there, and it is exactly why the first task makes something new instead of editing what you already have.

## What comes after the first session

You learned the loop in one app. From here you add capability one piece at a time — never all at once, and each only when a real task needs it.

**Add a connector.** Point the agent at the accounts you already work in. Gmail and Calendar connect instantly. Drive, Docs, and Sheets need a short one-time setup, which a helper can do with you. Start read-only — "find this and show me," not "send" — and keep the rule: nothing goes out without your yes.

**Add the second agent.** This is the biggest step, and the reason the kit is built around two. Open the *same folder* in the other app and let it review the work — Claude Code writes the `HANDOFF.md`, Codex checks it, or the reverse. Two agents reading the same folder catch what one misses; that cross-check is the real payoff of running both. (Until you set up the second agent, the kit's review commands still help, but they are one model's opinion, not yet a true second-agent check.)

**Then go deeper, as the work demands.** A routine you run every week. A multi-agent council for a decision that's worth a second and third opinion. Research across many sources at once. Add each when a real task calls for it, and write the new boundary into your `HANDOFF.md` as you go, so the next session knows what you've wired up.

What not to rush: connectors, councils, and deep research are powerful, and none of them is day one. One tool, one loop, one real result first — then build out from there.

## If something looks scary

<details>
<summary>Your computer pops up a security warning during install or sign-in</summary>

During sign-in or install, your computer may ask to store a login (macOS Keychain / Windows Credential Manager), ask an app to access a folder, or warn about an unrecognized app. These are normal OS dialogs, not a sign anything is wrong. Allow the login prompt; for folder access, allow only your one practice folder. **On a Mac**, a "can't verify the developer" warning clears via **System Settings → Privacy & Security → Open Anyway**. **On Windows**, a blue "Windows protected your PC" (SmartScreen) box clears via **More info → Run anyway**. (Apps from the Microsoft Store usually skip this.)
</details>

<details>
<summary>The Terminal or PowerShell window looks frozen after I pasted a command</summary>

Installs can sit with little or no output for up to a minute. That is normal. Don't press anything or close the window — wait for the prompt to come back (it looks like `%` or `$` on a Mac, or `PS C:\Users\you>` on Windows), then run the next line.
</details>

<details>
<summary>The agent asks for folder or account access</summary>

Approve only the one practice folder. Don't approve your whole home folder, Dropbox root, email, or research-data folders in the first session. If the prompt asks for something wider than the one folder, decline and point it at that folder.
</details>

<details>
<summary>A slash command isn't there</summary>

Type the instruction in plain English instead. The shortcut may not be installed yet, or the app may need a restart. The workflow matters more than the shortcut.
</details>

<details>
<summary>The agent changed something I didn't want</summary>

Tell it plainly: *"undo your last change and restore the previous version."* It can put the file back. Because the first task works on new or copied files in one folder, nothing important is at risk — this is what the approval pause and the copy-first habit are for.
</details>

<details>
<summary>The agent wants to send an email, message, or external request</summary>

Stop and ask for a draft first. Nothing should leave your computer without your explicit approval.
</details>

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
