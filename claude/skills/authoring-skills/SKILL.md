---
name: authoring-skills
description: Evaluates, writes, and improves agent skills (SKILL.md packages). Use when the user asks to write a new skill, evaluate or review an existing skill, fix a skill that triggers wrongly or too often, or improve or extend an existing skill — its description, structure, features, or supporting files. Not for general writing, coding, or prompt tasks that don't involve a skill package.
---

# Authoring Skills

Evaluate, write, or improve agent skills (SKILL.md packages). All three
modes apply the same rubric; the full criteria with strong/weak examples
live in [rubric.md](rubric.md).

## Mode dispatch

Infer the mode from the request; ask only when genuinely ambiguous:

- Existing skill + evaluate/review/assess/audit → **Evaluate**
- Stated purpose, no existing skill → **Write**
- Existing skill + improve/fix/tighten/add/extend, or "won't trigger"/"fires too often" → **Improve**

## Hard constraints (from the SKILL.md format — a violation is an automatic FAIL)

- `name`: ≤64 chars; lowercase letters, numbers, hyphens only; no XML tags; no
  reserved words "anthropic" or "claude".
- `description`: non-empty, ≤1024 chars, no XML tags, written in third person,
  states both what the skill does and when to use it. Key use case first —
  hosts truncate long listing text.
- SKILL.md body: under 500 lines. Count, don't estimate.
- Reference files: linked one level deep from SKILL.md; each needs a table of
  contents if over 100 lines.
- Forward slashes in all paths, even on Windows.

## Rubric — one line per dimension (full criteria: [rubric.md](rubric.md))

1. **Trigger** — description has concrete trigger terms a user would type; what + when; third person
2. **Scope** — one job; what it will NOT do is statable in a sentence; no overlap with other skills
3. **Structure** — numbered workflows; decision points explicit; freedom level matches task fragility
4. **Disclosure** — body holds only what every invocation needs; detail in references with load cues
5. **Clarity** — imperative instructions; one default approach; nothing the agent already knows
6. **Examples** — input→output pairs where format matters; anti-patterns named for known failures
7. **Portability** — no machine-specific paths; bundled files referenced relative to the skill directory; dependencies declared
8. **Testability** — trigger test set exists; checkable success criteria; validation loops for fragile steps

## Mode: Evaluate

1. Read [rubric.md](rubric.md).
2. Read every file in the target skill — SKILL.md, all reference files, all
   scripts. Note files SKILL.md never links: they are dead weight or a
   missing link.
3. Check each dimension against the full criteria. Verify the hard constraints
   mechanically (character counts, line counts) — do not eyeball them.
4. Report in exactly this format:

```markdown
## Evaluation: <skill-name>

| Dimension   | Verdict |
|-------------|---------|
| Trigger     | pass / flag / FAIL |
| ...         | ... |

### Issues (priority order)

1. **[Dimension/VERDICT]** Evidence — quote the offending text from the skill.
   Fix: the concrete replacement text or change.
```

Verdicts: **pass** = meets criteria; **flag** = works but has a concrete,
fixable weakness; **FAIL** = violates a hard constraint or will predictably
malfunction (won't trigger, misleads, breaks). Every flag and FAIL gets a
numbered issue with quoted evidence and a suggested fix. No numeric scores.

## Mode: Write

1. Check for overlap first: read the descriptions of the skills already in
   the collection. If one substantially covers the request, propose Mode:
   Improve on that skill instead of writing a new one.
2. Interview relentlessly, one question at a time, each with a recommended
   answer. Walk every branch of the design tree, resolving dependencies
   between decisions one by one — sequence questions so each builds on
   already-settled answers, never on guesses. Continue until shared
   understanding: every branch listed below covered, plus any branch an answer
   opens, and no decision left that would change the draft.
   - Trigger set: 2–3 requests that should fire the skill, 2–3 nearby
     requests that must not.
   - Scope boundary: what is explicitly out.
   - Worked example: one real input and its expected output.
   - Wrapped tools or scripts: any the skill will drive.
   - Side effects: if any, restrict the skill to manual invocation (e.g.
     `disable-model-invocation: true` where the host supports it).
3. Research the domain before drafting: search authoritative, well-known,
   widely-used sources — official docs, specs, canonical tools, and published
   skills — for how people conventionally solve the problem the skill
   addresses. Ground the skill's instructions in those findings, not in
   assumption, and carry the load-bearing facts (commands, limits, defaults)
   into the skill. If the host has no web access, say so and flag every
   unverified claim in the draft.
4. Read [template.md](template.md) and [rubric.md](rubric.md). Draft from the
   template. Decide anything not covered by the interview yourself and list
   each decision as a stated assumption when presenting.
5. Self-evaluate the draft against the rubric before presenting. Fix what you
   find; do not present a draft with known FAILs.
6. Default location: a sibling directory of this skill, so new skills join
   the same collection wherever it lives. If the collection is symlink-deployed
   from a config repo, the write passes through the symlink — the new skill is
   version-controlled and live immediately. For a project-scoped skill, use
   the project's own skills directory instead.
7. Deliver: the files, the stated assumptions, and the trigger set from step 2
   formatted as a test plan per [testing.md](testing.md).

## Mode: Improve

1. Run Mode: Evaluate in full and present the results.
2. When the request extends the skill's behavior or trigger surface —
   add/extend, "won't trigger"/"fires too often" — interview as in Write
   step 2, scoped to the delta: new trigger and non-trigger cases, the
   scope boundary shift, a worked example of the new behavior. Skip for
   pure evaluate-and-patch fixes.
3. Apply fixes for **flag**-level issues directly — wording, structure, missing
   examples; edits within the skill's existing intent. When a fix changes a
   domain fact (a command, API, limit, or convention), research authoritative
   sources first, as in Write step 3 — don't patch a claim with another
   unverified claim.
4. Stop and confirm before **FAIL**-level rewrites that change scope, split the
   skill, or rewrite the description's trigger surface — those change when the
   skill fires, which the user may depend on.
5. After any description edit, re-run the trigger checks in
   [testing.md](testing.md) and report the results with the diff summary.

## Files

- [rubric.md](rubric.md) — full criteria per dimension with strong/weak
  examples, plus the anti-pattern catalog. Load when evaluating or improving.
- [template.md](template.md) — annotated SKILL.md skeleton and frontmatter
  field reference. Load when writing a new skill.
- [testing.md](testing.md) — trigger checks, no-skill baseline, iteration
  loop. Load when testing or when a skill misfires.
