# dotagents

One home for my AI agent configs.

## How it works

`manifest.json` maps each agent's repo folder to its live config folder. Three
scripts move config along that map:

```
               link.ps1   ->
  dotagents/   apply.ps1  ->   ~/.claude   (Claude Code)
              <-  capture.ps1
```

- `link.ps1`    symlinks live config to the repo (zero-drift: live edits ARE repo edits)
- `apply.ps1`   copies the repo into live config (a snapshot)
- `capture.ps1` pulls live config back into the repo (after `apply.ps1`), ready to commit

`link.ps1` needs Windows Developer Mode (or an elevated shell); it checks and
tells you.

## What it manages

| Path | Holds |
|------|-------|
| `instructions.md` | Global instructions, shared across agents |
| `claude/settings.json` | Claude Code settings |
| `claude/agents/` | Subagents |
| `claude/skills/` | Skills |
| `claude/hooks/` | Hooks |

Paths are 1:1 — `claude/agents/foo.md` lives at `~/.claude/agents/foo.md`. The
shared `instructions.md` is the exception: it deploys as `~/.claude/CLAUDE.md`.

## Usage

```powershell
.\bin\link.ps1                   # repo -> ~/.claude as symlinks (zero-drift)
.\bin\apply.ps1                  # repo -> ~/.claude as copies instead
.\bin\capture.ps1                # ~/.claude -> repo (after apply.ps1), then commit
# every script takes -DryRun to preview without writing
```

## Another agent

Add a top-level folder (e.g. `codex/`) and a `manifest.json` entry pointing it
at that agent's config folder. To share the global instructions, give it an
`"instructions": { "from": "instructions.md", "to": "<that agent's filename>" }`
field (e.g. `AGENTS.md`).
