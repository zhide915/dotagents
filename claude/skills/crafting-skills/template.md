# SKILL.md template

Annotated skeleton for a new agent skill. Copy, fill, delete every annotation
comment and any section the skill doesn't need. The directory name typically
becomes the invocation name; the frontmatter `name` is a display label.

````markdown
---
name: <skill-name>
# ≤64 chars, lowercase/numbers/hyphens, no "anthropic"/"claude".
# Prefer gerund form: processing-pdfs, summarizing-changes.
description: <What it does, concrete verbs and nouns>. Use when <trigger
  contexts and terms the user would type>. Not for <nearby task that must
  not trigger it>.
# ≤1024 chars, third person, key use case first. This line alone decides
# triggering — write it from the trigger test set, not from the body.
---

# <Skill Title>

<One sentence: what this skill produces or decides.>

## Workflow

<!-- Number every step. For fragile operations give exact commands and forbid
     deviation; for judgment steps give goals and heuristics. For 5+ steps,
     provide a checklist the agent copies into its response and checks off. -->

1. <Step — exact command or clear action>
2. <Step. If validation applies: run validator → fix → repeat until pass.>
3. <Conditional? Make it explicit: "Creating new? → A. Editing? → B.">

## Example

<!-- One real input→output pair wherever format or style matters.
     Concrete beats abstract: real field names, real commands. -->

Input: <real request>
Output:
```
<expected result, exact format>
```

## Files

<!-- Only if the skill has supporting files. Each linked directly from here
     (one level deep) with a load cue. Reference files >100 lines start with
     a table of contents. Scripts: say "Run X" (execute) or "See X" (read).
     Reference bundled files relative to the skill directory, never with
     absolute paths. -->

- [reference.md](reference.md) — <contents>. Load when <situation>.
- `scripts/check.py` — Run `python scripts/check.py <args>` from the skill
  directory.
````

## Host-specific frontmatter extensions

Some hosts extend the format with extra fields. Support varies — verify the
target host honors a field before relying on it. Unknown fields are silently
ignored, which can void a safety property: an unsupported manual-invocation
flag means the agent CAN still auto-trigger the skill.

| Field | Add when |
|---|---|
| `disable-model-invocation: true` | The skill has side effects (deploy, commit, send) — only the user should decide when it runs. |
| `user-invocable: false` | Background knowledge, not an action — hides it from the command menu. |
| `allowed-tools: <list>` | The workflow needs specific tools without per-use permission prompts. Grants, doesn't restrict. |
| `disallowed-tools: <list>` | An autonomous skill must never call certain tools. |
| `when_to_use: <phrases>` | The description alone can't hold all trigger context; appended to it in the listing. |
| `paths: src/**/*.sql` | The skill applies only when working with matching files — narrows auto-trigger. |
| `argument-hint: [issue-number]` | The skill takes arguments; shown in autocomplete. |
| `context: fork` | The skill is a self-contained task to run in an isolated subagent — it won't see conversation history, so the body must be a complete prompt. |

## String substitutions (host-dependent)

Where the host supports them, the body can use:

- `$ARGUMENTS`, `$ARGUMENTS[N]`, `$N` — invocation arguments (`/skill foo bar`).
- A skill-directory variable (e.g. `${CLAUDE_SKILL_DIR}`) — for bundled-file
  paths when the working directory differs from the skill directory; prefer
  plain relative paths when targeting multiple hosts.
- `` !`command` `` — runs at load time, output replaces the placeholder before
  the agent reads the skill. Use to inject live state (`` !`git diff HEAD` ``)
  so instructions arrive grounded in actual data.

A skill meant to travel across hosts should degrade gracefully: keep the core
workflow functional even if every substitution above is left unexpanded.
