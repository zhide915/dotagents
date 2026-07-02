# Documentation types

Classify the doc, then judge or write it by its type's standard. Built on
Diátaxis (diataxis.fr), extended with two forms it doesn't cover:
behavior-governing docs and code comments.

## Contents

- The four Diátaxis types
- Two distinctions worth getting right
- Decision guide
- Behavior-governing docs
- Code comments and docstrings
- Skeletons

## The four Diátaxis types

| Type | Orientation | Serves | The one rule |
|---|---|---|---|
| Tutorial | learning | a beginner studying | a path *guaranteed to work*; teach by doing, don't explain |
| How-to | a task | a competent user working | reach the goal in steps; omit teaching and theory |
| Reference | information | someone who needs a fact | describe what *is*, systematically; don't instruct |
| Explanation | understanding | someone studying to understand | give the *why* — context, trade-offs; don't instruct |

## Two distinctions worth getting right

- **Tutorial vs how-to** — does the reader know what they want yet? No →
  tutorial (you pick the path, guarantee the outcome). Yes → how-to (assume
  competence, may branch).
- **Reference vs explanation** — reference states facts the way the code is
  structured (austere, no opinions). Explanation connects and justifies them. A
  reference that starts saying *why* has drifted into explanation — split it.

## Decision guide

Ask in order; stop at the first yes:

1. Exists to change how the reader *behaves* later (rules, conventions, agent
   instructions)? → **Behavior-governing**.
2. An inline comment in source code? → **Code comment**.
3. Reader is learning, no goal of their own yet? → **Tutorial**.
4. Reader has a specific goal right now? → **How-to**.
5. Reader needs a fact (what exists, signatures, options, behavior, or a
   docstring)? → **Reference**.
6. Reader wants to understand why or how things relate? → **Explanation**.

A README or long wiki page is several of these by design. Classify each section
and check they're kept distinct.

## Behavior-governing docs

Rules, guidelines, conventions, runbooks, CLAUDE.md/AGENTS.md. The type exists to
be *obeyed*, not just understood, so it's judged on adherence. The two traits
that most set it apart:

- **Falsifiable** — every rule carries a check that can fail.
- **Enforce, don't advise** — a must-every-time rule belongs in automation
  (linter, CI, hook), not prose.

The full gradeable criteria are in [rubric.md](rubric.md#behavior-governing-docs).

## Code comments and docstrings

In scope when documentation is the explicit task. Two jobs:

- **Docstrings** — reference embedded in code: what it does, parameters, return,
  what it raises — not how it works inside. Judge by Reference criteria; follow
  the language's convention (NumPy/Google, JSDoc/TSDoc, rustdoc) consistently.
- **Comments** — only what the code *can't* say: a constraint, a gotcha, a
  non-obvious why. Narrating what the code does (`// increment the counter`) is
  noise. Test: would removing it lose information a competent reader couldn't
  recover from the code? No → cut it.

## Skeletons

Draft from the skeleton for the classified type, adapting to the project's
existing docs.

**Tutorial**
```markdown
# <Do X, end to end> — a beginner's lesson

What you'll build, shown as the finished result.
Prerequisites: <exact versions/setup — the only assumed knowledge>.

## Step 1 — <smallest first win>
<Exact commands. Show expected output. Every step works as written.>

## Step 2 — <next>
...

## What you did
<Recap. Link onward to a how-to or explanation — don't branch here.>
```

**How-to**
```markdown
# How to <accomplish the specific goal>

When to use this. Assumes you already <competence/state assumed>.

1. <Step toward the goal.>
2. <Step. Condition before instruction: "If on Windows, …".>
3. <Step.>

Result: <how to confirm the goal is met.> Related: <links, not detours>.
```

**Reference**
```markdown
# <Component / API / config> reference

<One line: what this is.>

## <item — e.g. function or field name>
- **Signature / type:** <exact>
- **Description:** <what it is/does — factual>
- **Parameters / fields:** <each: name, type, meaning, default>
- **Returns / raises:** <exact>
- **Example:** <minimal, runnable>

<Repeat per item — identical structure and order throughout.>
```

**Explanation**
```markdown
# Understanding <topic>

## The problem this solves
## How it works, and why it's shaped this way
<Context, design reasons, trade-offs, alternatives. May hold opinions. No
step-by-step — link to the how-to.>

## See also
```

**Behavior-governing**
```markdown
# <Scope> guidelines

<One line: who this binds and when.>

## <Imperative rule naming a behavior>
*<One-line tagline — the counterweight or the why.>*
- <Operational specifics.>
- Test: <a check that can fail.>
```
