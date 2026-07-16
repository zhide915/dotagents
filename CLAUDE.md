# CLAUDE.md

Guidance for agents working in this repo. `README.md` explains usage; this
file covers what bites: the hazards and conventions you can't see from any
single file.

## How releases work — and bite

- `.claude-plugin/plugin.json` omits `version` on purpose: Claude Code
  treats every commit as a new version, so installs update without manual
  bumps. Every push to `main` is therefore a release.
- The marketplace `name` is `zhide915` and is the install suffix
  (`zee-kit@zhide915`). Changing it breaks the documented install
  commands and any project settings that reference it.

Test: before touching a skill, you can say how (and when) the edit reaches
a running session.

## Conventions

- `README.md` describes only the present. Future work goes in
  `ROADMAP.md` as a row with a trigger, built when the trigger fires, not
  before.
- This file holds repo-local hazards only; it never ships with the
  plugin.
