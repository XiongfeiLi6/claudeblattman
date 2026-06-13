# Claude Blattman

**A professor's guide to building AI workflows — from chatbots to self-improving systems.**

Website: [claudeblattman.com](https://claudeblattman.com)

---

## What This Is

A free, open-source resource for non-developers who want to build real AI workflows. Three paths:

1. **The Essentials** — Tools and foundations. Chatbots done right, dictation, transcription, prompt engineering.
2. **The Toolkit** — Claude Code setup, configuration, and downloadable skills. From "what is this?" to a working system.
3. **Build Your Own** — Creating custom skills, agents, and self-improving workflows.

## Who It's For

- Academics and researchers managing multiple projects
- Professionals buried in email, meetings, and coordination
- Anyone who wants to move beyond casual chatbot use

No coding background required. Everything is built with markdown and AI tools.

## Quick Start

New to the desktop agent apps? Start with the **Desktop Agent Starter Kit**:

1. Install Claude Code, then sign in.
2. In Claude Code, add and install the starter plugin:

   ```text
   /plugin marketplace add chrisblattman/claudeblattman
   /plugin install starter-kit@claudeblattman
   ```

3. After your first Claude Code handoff, optionally install the Codex starter pack:

```bash
git clone https://github.com/chrisblattman/claudeblattman.git
cd claudeblattman/codex-starter
python3 install-codex-starter.py install
```

Then follow [Start Here: Desktop Agent Starter Kit](https://claudeblattman.com/starter-kit/).

The older `skills/` library remains available as advanced/reference material,
but it is not the recommended first-run path.

## Repo Structure

```
claudeblattman/
├── docs/               # Website source (MkDocs Material)
├── plugins/starter-kit/ # Claude plugin for the desktop-agent starter kit
├── codex-starter/      # Codex starter pack installer + skills
├── skills/             # Downloadable skill files
├── agents/             # Downloadable agent files
├── templates/          # Starter templates (CLAUDE.md, goals.yaml)
├── mkdocs.yml          # Site configuration
├── CONTRIBUTING.md     # Maintenance guide
└── LICENSE             # MIT
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to edit content, add skills, and maintain the site.

## Release Notes

The starter kit is versioned separately from the broader docs. Each public
starter-kit release should have a matching tag such as `starter-kit-v0.1.0` and
a current `public-manifest.json`. If a plugin release needs rollback, install
from the last known-good tag and avoid changing the marketplace/plugin names.

## License

MIT — use anything here however you want.

---

Built by [Chris Blattman](https://chrisblattman.com). The name is a joke. The tools are real.
