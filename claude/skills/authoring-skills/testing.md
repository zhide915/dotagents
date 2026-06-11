# Testing a skill

Manual but repeatable. Run the trigger check on every new skill and after any
description edit; run the baseline test once before investing in a large skill.

## 1. Trigger check

The trigger test set comes from write-mode's interview: 2–3 prompts that
should fire the skill, 2–3 nearby prompts that must not. If the set doesn't
exist yet, write it now — from how the user would actually phrase requests,
not from the skill's own vocabulary.

For each prompt, in a **fresh session** (skill loading is per-session state):

1. Type the prompt as the user would, with no mention of the skill's name.
2. Record whether the skill activated (the skill's content visibly shapes the
   response; ask "What skills are available?" first if unsure the skill is
   registered at all).
3. Score: every should-fire prompt fired, every must-not prompt didn't.

| Result | Fix |
|---|---|
| Should-fire missed | Add the words the prompt used to the description — match user vocabulary, not author vocabulary |
| Must-not fired | Tighten the description; add a "Not for X" clause naming the collision; scope activation by file path where the host supports it |
| Skill not listed | Check directory location and frontmatter parse; with many skills installed, check the host's listing budget hasn't truncated the description |

## 2. Baseline (no-skill) test

A skill must earn its tokens: it should fix a demonstrated failure, not
document what the agent already does.

1. In a fresh session **without** the skill (move its folder out of the skills
   directory — renaming in place does not disable it), run the worked example
   task from the skill's interview.
2. Diff the output against what the skill specifies. What the baseline already
   gets right, the skill should not explain — cut it.
3. What the baseline gets wrong is the skill's actual content. If the baseline
   gets nothing wrong, the skill isn't needed.

Build the test before writing extensive content: identify gaps → write minimal
instructions that close them → re-run → iterate. Three scenarios is the
recommended floor for a skill worth keeping.

## 3. Iteration loop

Improve from observed behavior, not assumptions:

1. Use the skill in real tasks, not test scenarios.
2. Watch how the agent navigates it: files read in unexpected order → structure
   isn't intuitive; a reference never loaded → cut it or fix its load cue; the
   same reference loaded every time → its content belongs in SKILL.md.
3. When the agent misses a rule mid-task, make the rule more prominent or
   stronger ("MUST filter") rather than adding more prose around it.
4. After each edit, re-run the trigger check (step 1) if the description
   changed, and the failing scenario if the body changed.
