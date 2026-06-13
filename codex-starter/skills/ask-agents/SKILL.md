---
name: ask-agents
description: Send a task or question to Claude Code and/or Gemini as external subagents and report back what they said. Use when the user asks to ask Claude, ask Gemini, ask both, get a second opinion, split reviewer roles, or compare external agents.
---

# Ask Agents

## Default Rule

When the user asks to ask Claude, ask Gemini, ask both, split work between them, or get an outside opinion, do it directly with the bundled runner. Do not turn it into an integration discussion.

## Privacy Gate

Sending a task to Claude Code or Gemini sends the prompt, listed context files,
and any quoted material to another AI service. Before every run, check whether
the prompt or context includes confidential records, personal contact details,
human-subjects or research-participant data, private transcripts, unpublished
sensitive work, or anything the user would not paste into a public website. If
so, do not run the external agent. Offer a local Codex-only answer or a redacted
prompt for the user to approve first.

If the privacy check passes, ask for explicit send confirmation before every
external run: "Send this prompt to Claude/Gemini as an outside opinion? (yes/no)"
Proceed only if the user answers yes. If they answer no or do not answer
clearly, stop and offer a Codex-only answer.

## Requirements

- Node.js 18 or newer (`node` on your PATH)
- For `--agent claude`: the Claude Code CLI (`claude`) installed, signed in, and on your PATH
- For `--agent gemini`: the Gemini CLI (`gemini`) installed, signed in, and on your PATH

If a required tool is missing, the runner stops with a plain-language message naming it. Never substitute your own answer while implying the external agent ran.

## Runner

The runner is bundled inside this skill at `scripts/run-external-agent.mjs`:

```text
node ~/.codex/skills/ask-agents/scripts/run-external-agent.mjs --agent claude --prompt "..."
node ~/.codex/skills/ask-agents/scripts/run-external-agent.mjs --agent gemini --prompt "..."
node ~/.codex/skills/ask-agents/scripts/run-external-agent.mjs --agent both --prompt "..."
```

(If your skills live somewhere other than `~/.codex/skills`, adjust the path — the script is in this skill's own folder.)

Defaults:

- `cwd`: the folder the command is run from (your current project)
- Run records: a temporary folder under the system temp directory
- Timeout: 300 seconds
- Output cap: 50,000 bytes
- Claude caps: 8 turns, $2 budget

External runs are read-only: the runner snapshots the working folder before and after, reports any file changes, and instructs the external agent to propose patches rather than apply them.

Useful options:

```text
--cwd /path/to/workspace
--context relative/path/under/cwd
--timeout 600
--max-output 100000
--max-turns 10
--max-budget 4
--claude-prompt "implementation/reliability role..."
--gemini-prompt "strategy/alternative role..."
```

## Workflow

1. Run the privacy gate above. If the task is sensitive, do not dispatch.
2. Decide the agent set:
   - Claude Code: implementation risk, code review, repo reasoning, operational details.
   - Gemini: alternatives, product/strategy critique, broad outside read, second opinion.
   - Both: ambiguous plans, high-stakes design, migration/setup decisions, disagreement checks.
3. If both are useful, give them distinct roles in their prompts instead of identical vague requests.
4. Ask for explicit send confirmation. If the user does not clearly say yes, stop and offer a Codex-only answer.
5. Run the external calls.
6. Report each external result honestly: agent, state, and a short summary of its report.
7. Synthesize: agreements, disagreements, what you conclude, and the concrete next action.

## Prompt Patterns

Claude implementation review:

```text
Review this as Claude Code. Focus on implementation risk, missing tests, operational failure modes, and the smallest robust next step.
```

Gemini outside view:

```text
Review this as Gemini. Focus on alternative approaches, strategy/product tradeoffs, hidden assumptions, and what we may be overcomplicating.
```

## Failure Handling

If an external run fails, say it failed and include the details that matter (state, error, missing tool). If the command was blocked by sandboxing or approvals, ask the user to approve that specific command and rerun it.

## Output Shape

```text
External agents:
Claude:
Gemini:
Synthesis:
Next action:
```
