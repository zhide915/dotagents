# CLAUDE.md

Guidance for agents working in this repo. `README.md` explains usage; this file
covers what bites: the hazards and conventions you can't see from any single
file.

## This repo is the live config

`bin/link.ps1` deploys by symlinking entries under `~/.claude` into this repo,
and that is the usual state of this machine (verify: `Get-Item
~/.claude/CLAUDE.md | Select-Object LinkType, Target`). While linked:

- Editing `claude/skills/`, `claude/settings.json`, or `instructions.md` changes
  the running Claude Code environment immediately — including the session making
  the edit.
- `instructions.md` deploys as `~/.claude/CLAUDE.md`: the user's **global**
  instructions for every project on this machine, not repo-local config. Edit
  with that blast radius in mind.
- The skills entry is a single directory symlink, so everything inside it is
  live whatever it's called — renaming a skill folder in place does not disable
  it. To test without a skill, move its folder out of `claude/skills/` entirely.
- This file is not in the manifest and never deploys; it applies only when
  working inside this repo.

Test: before touching any file here, you can say whether the edit lands in the
live environment.

## How sync works — and bites

- `manifest.json` is the single source of truth for what syncs where. A new
  config path does nothing until it has a manifest entry — and the scripts
  silently print `skip:` for source paths that don't exist, so a typo'd entry
  fails quietly. Read the script output.
- `apply.ps1` and `capture.ps1` mirror directories with `robocopy /MIR`: files
  absent on the source side get **deleted** at the destination. `apply.ps1` can
  delete live config; `capture.ps1` can delete repo files. Never run either with
  unsynced changes on the losing side.
- The directions are opposites: `link.ps1`/`apply.ps1` push repo → live;
  `capture.ps1` pulls live → repo. Know which way data flows before running
  anything.
- There are no tests. All three scripts take `-DryRun`; verify script changes by
  reading the planned operations it prints before running for real.

Test: you've seen the `-DryRun` output of a script run before its real one.

## Conventions

- Scripts target Windows PowerShell 5.1 (`#requires -Version 5.1`). `cmd /c
  mklink` instead of `New-Item -ItemType SymbolicLink` is deliberate 5.1
  compatibility — keep edits compatible; PS7-native syntax is a `ROADMAP.md` row
  whose trigger hasn't fired.
- Document placement: `README.md` describes only the present. Future work goes
  in `ROADMAP.md` as a row with a trigger, built when the trigger fires, not
  before. This file holds repo-local hazards only.
- `instructions.md` is agent-agnostic and follows its own rules: promote
  guidance into it only after the same correction recurs across projects, and
  cut bullets that stop earning their keep.
