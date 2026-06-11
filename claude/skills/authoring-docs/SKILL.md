---
name: authoring-docs
description: Evaluates, writes, and improves documentation — READMEs,
  tutorials, how-to guides, reference pages, explanations, rules/guidelines
  files, CLAUDE.md/AGENTS.md, and docstrings/comments. Classifies the doc by
  Diátaxis type, then applies type-specific and shared quality criteria. Use
  when documentation quality is the explicit task — reviewing a README,
  drafting a guide, tightening docstrings, or fixing a guidelines file. Not for
  code whose comments are an incidental byproduct of writing it.
---

# Authoring Docs

Evaluate, write, or improve documentation. Every mode classifies the doc first
(Step 0), then applies the shared rubric plus the type's own criteria.

## Mode dispatch

Infer the mode from the request; ask only when genuinely ambiguous:

- Existing doc + evaluate/review/audit → **Evaluate**
- A doc needed, nothing written → **Write**
- Existing doc + improve/fix/tighten/restructure → **Improve**

## Step 0 — Classify (all modes)

Name the type before applying any criterion; the type sets the standard.
Decision guide in [types.md](types.md).

| Type | Its one job |
|---|---|
| Tutorial | teach a beginner by doing |
| How-to | get a competent user to a goal |
| Reference | state what is (incl. docstrings, API pages) |
| Explanation | give the why and the trade-offs |
| Behavior-governing | be obeyed (rules, guidelines, CLAUDE.md) |
| Code comments | say what the code can't |

A README or landing page mixes types by design — classify each section, and
check the sections aren't blurred together.

## Cardinal rule (violation = FAIL)

**One doc, one purpose.** Don't blend Diátaxis types — a tutorial with reference
tables, a how-to that teaches theory. Split, don't balance.

Two more conditions fail a doc just as hard, whatever its type: an example that
doesn't run as written, and stale content stated as current.

## Rubric — shared dimensions (full criteria in [rubric.md](rubric.md))

1. **Type fit** — one purpose per doc/section; types not blended
2. **Audience** — written for a named reader at the right altitude
3. **Accuracy** — matches the system; every example and command runs
4. **Structure** — findable: headings, scannable, one term per concept
5. **Clarity** — active voice, second person, concrete; conditions before
   instructions
6. **Maintainability** — deletion test; no time-bombs or stale content

Type-specific dimensions (per type) are in [rubric.md](rubric.md).

## Mode: Evaluate

1. Read [rubric.md](rubric.md).
2. Read the doc. If it documents code, read that code to check accuracy.
3. Classify (Step 0); for a mixed doc, classify each section.
4. Check every dimension — shared and type-specific — against the full criteria.
   Verify the checkable parts mechanically, never by reading alone — run each
   example; flag any you couldn't verify.
5. Report in exactly this format:

```markdown
## Evaluation: <doc name> (<type>)

| Dimension       | Verdict |
|-----------------|---------|
| Type fit        | pass / flag / FAIL |
| Audience        | ... |
| Accuracy        | ... |
| Structure       | ... |
| Clarity         | ... |
| Maintainability | ... |
| <type-specific> | ... |

### Issues (priority order)

1. **[Dimension/VERDICT]** Quote the offending text. Fix: the concrete
   replacement text or change.
```

Verdicts: **pass** = meets criteria; **flag** = works but has a concrete,
fixable weakness; **FAIL** = misleads, breaks, or defeats the doc's purpose.
Every flag and FAIL gets a numbered issue with quoted evidence and a suggested
fix. No numeric scores.

## Mode: Write

1. Check for overlap first: look for a doc that already covers this topic. If
   one does and it's the right type, propose Mode: Improve on it instead of
   writing a new doc. If it exists but is the wrong type — an explanation when
   you need a how-to — write the new doc and cross-link, never duplicating the
   shared facts.
2. Classify the intended doc (Step 0). If it needs more than one type, write
   them as separate docs.
3. Interview one question at a time, each with a recommended answer. Before
   asking, map the design tree the doc's type forces — the reader's prior
   knowledge, the worked path, what the doc must not cover, where it could go
   stale — and sequence questions so each builds on a settled answer, never a
   guess. Ask until no unanswered decision would still change the draft; the
   bullets are the floor, not the ceiling:
   - **Reader** — who reads this, and what they already know.
   - **Success** — what they can do or know afterward that they couldn't before.
   - **Scope** — what the doc deliberately omits.
   - **Examples** — the real commands, paths, and output the doc will show.
   - **Behavior-governing** — also name the recurring failure each rule answers,
     and where it's enforced.
4. Verify facts directly — read the code, run the commands. Flag any you can't
   verify.
5. Draft from the skeleton in [types.md](types.md). List decisions the
   interview didn't settle as assumptions.
6. Self-check against [rubric.md](rubric.md); run every example. Present no
   draft with a known FAIL.
7. Place it alongside the project's existing docs, matching their format.
8. Deliver: the doc, the assumptions, and how you verified the examples.

## Mode: Improve

1. Run Mode: Evaluate in full and present the results.
2. When the change alters the doc's purpose, audience, or type, interview as in
   Write step 3, scoped to the delta: the new reader, the scope shift, fresh
   examples. Skip for pure evaluate-and-patch fixes.
3. Apply fixes for **flag**-level issues directly — wording, structure, missing
   examples; edits within the doc's existing intent. When a fix changes a fact
   (a command, signature, path, default), verify it against the code first —
   don't patch a claim with another unverified claim.
4. Stop and confirm before **FAIL**-level rewrites that split the doc, change
   its type, or change who it's for — those change what the doc is and who
   depends on it.
5. Report the diff and how you verified any example you touched.

## Files

- [types.md](types.md) — the Diátaxis types and the two extensions
  (behavior-governing docs, code comments), the classification decision guide,
  and a structure skeleton per type. Load at Step 0 to classify, and in Write
  mode to draft.
- [rubric.md](rubric.md) — full criteria for every shared and type-specific
  dimension, each with a weak and a strong example, plus the anti-pattern
  catalog. Load when evaluating or improving.
