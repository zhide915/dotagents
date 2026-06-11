# Roadmap

Future work for dotagents. `README.md` covers the present; this file
covers what's planned — each row gets built when its trigger fires, not before.

| Add | When |
|-----|------|
| MCP servers (`claude/mcp.json`, registered via `claude mcp add-json`) | You add your first MCP server |
| Plugin marketplaces (trimmed `known_marketplaces.json`, no `installLocation`) | You add a marketplace beyond the built-in official one |
| Secrets (gitignored `.env` + a load step) | An MCP server or hook needs a credential |
| Codex (`codex/` + a `manifest.json` entry) | You adopt Codex |
| Hermes (`hermes/` + a `manifest.json` entry) | You adopt Hermes |
| Shared skills across agents (one source folder, per-agent manifest entries) | You deploy a second agent and it needs a skill from `claude/skills/` |
| Bash scripts (`apply.sh` / `capture.sh`) | You work where PowerShell isn't available |
| PS7 native symlinks (`New-Item -SymbolicLink`, drops `cmd /c mklink`) | Every target machine runs PowerShell 7+ |
