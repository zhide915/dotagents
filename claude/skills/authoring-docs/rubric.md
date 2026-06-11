# Documentation evaluation rubric

Full criteria for the six shared dimensions and the type-specific ones, each
with a weak and a strong example, followed by the anti-pattern catalog.
Verdicts: pass / flag / FAIL as defined in SKILL.md. Classify first (see
[types.md](types.md)); type-specific criteria apply only to that type.

## Contents

- Shared 1. Type fit
- Shared 2. Audience
- Shared 3. Accuracy
- Shared 4. Structure
- Shared 5. Clarity
- Shared 6. Maintainability
- Type: Tutorial
- Type: How-to
- Type: Reference
- Type: Explanation
- Behavior-governing docs
- Anti-pattern catalog

## Shared 1. Type fit

The cardinal rule: one purpose per doc, or per section of a mixed doc.

Check:
- Serves one purpose: teaching, doing, informing, or explaining.
- No detours — a tutorial doesn't enumerate every option; a reference doesn't
  explain rationale; a how-to doesn't teach theory.
- Where types coexist (a README), they're in separate labeled sections, not
  blended paragraph by paragraph.

Weak (FAIL): a "Getting started" page that opens as a tutorial, drops a full
config-flag table mid-lesson, then argues why the architecture is event-driven.

Strong (pass): a tutorial that links "see the configuration reference" instead
of inlining it.

## Shared 2. Audience

This is where most docs fail: written for no reader in particular, they land too
basic for the expert and too terse for the novice at once.

Check:
- The intended reader is identifiable, and the doc holds one altitude for them.
- Assumes what that reader knows; explains what they won't. Nothing they already
  know (don't define `git` for engineers), nothing unexplained they don't.
- Prerequisites stated up front, not discovered halfway in.

Weak (flag): a how-to that says "authenticate as usual", then three steps later
explains how to install the CLI from scratch.

Strong (pass): "Assumes a deployed project and an API key (see Setup)."

## Shared 3. Accuracy

The dimension most worth verifying against the code rather than trusting.

Check:
- Every command, sample, path, and output is current and runs as written —
  verified by running or tracing, not by reading.
- API names, signatures, flags, defaults match the source.
- Reflects present behavior, not a past version's.
- Anything unverifiable in this environment is flagged, not stated as confirmed.

Weak (FAIL): a quickstart whose `npm run dev` is no longer in `package.json`.

Strong (pass): examples copied from a passing test run, with real output shown.

## Shared 4. Structure

A fact the reader can't locate isn't documented; structure is what makes it
findable by scanning, not by reading end to end.

Check:
- Descriptive headings ("Configuring TLS", not "Advanced"); navigable
  hierarchy; a table of contents for long docs.
- Scannable: short paragraphs, lists for sequences and sets, code in code
  blocks.
- One term per concept throughout — don't drift between "field" and "attribute".
- Ordered for the reader (prerequisites before steps, conditions before
  instructions).

Weak (flag): a 600-word reference entry in one paragraph, the concept called
"field" here and "attribute" two lines down.

Strong (pass): each entry a short definition list, identical structure across
entries, one consistent term.

## Shared 5. Clarity

Every clause the reader must decode is friction; grounded in the Google
developer documentation style guide.

Check:
- Active voice, second person: "Run the migration", not "the migration should be
  run".
- Present tense ("the command returns", not "will return").
- Conditions before instructions: "To skip tests, pass `--no-test`".
- Concrete, not vague: "wait up to 30 seconds", real names and values.
- Descriptive link text, never "click here".
- No filler, no pre-announcing ("in this section we will…").

Weak (flag): "It is recommended that the appropriate configuration be applied
before the system is utilized."

Strong (pass): "Set `MAX_CONNS` before you start the server. The default, 100,
is enough for most workloads."

## Shared 6. Maintainability

Docs rot silently when the system moves on — nothing fails a build — and every
line is paid on each read, so each must earn its place.

Check:
- Deletion test on every line: would removing it lose something the reader
  needs? Length is paid on every read.
- No time-bombs: "currently", "soon", "the new API", "as of v2" go stale
  silently — state the durable fact or pin to a version.
- No content duplicated across docs that must update in lockstep — link the
  single source.
- Lives close to what it documents, so it's updated in the same change.

Weak (flag): "We recently switched to the new auth flow (the old one is still
around for now)."

Strong (pass): "Authentication uses OAuth 2.0 (since v3.0)."

## Type: Tutorial

Check:
- The whole path is guaranteed to work as written — the author has run it.
- Teaches by doing; theory deferred or linked.
- No branches or "you could also…" — it chooses for the beginner.
- Concrete throughout: real commands, real output.
- Builds an early, visible win.

Weak (flag): "configure your database (see your provider's docs) and set it up
as appropriate" — outsources the lesson, breaks the guarantee.

Strong (pass): "Run `createdb tutorial`. No output means success. Verify with
`psql -l`."

## Type: How-to

Check:
- Titled by the task, from the user's goal ("How to rotate API keys").
- Starts at the goal, ends when it's met; no setup-from-zero teaching.
- A sequence of actions that assumes competence to adapt.
- Handles real-world messiness (failure cases, variations).
- Omits explanation — links it.

Weak (flag): "How to deploy" that opens by explaining what containers are.

Strong (pass): "How to deploy a hotfix: 1. `git checkout -b hotfix/…` … If the
canary alarms, roll back with `…`."

## Type: Reference

Applies to reference docs, docstrings, and API pages.

Check:
- Structure mirrors the code and is identical across entries.
- Describes, doesn't instruct: what each thing is, its type, parameters, return,
  errors, defaults.
- Complete for what it covers — every public parameter documented, none
  invented.
- Austere: minimal prose, no rationale, no walkthroughs.

Weak (flag): a function reference documenting three of five parameters,
explaining why the function exists, omitting what it raises.

Strong (pass): every parameter as `name (type, default): meaning`, return and
raises listed, one minimal example, same layout as every sibling.

## Type: Explanation

Check:
- Centers on the *why*: design reasons, trade-offs, history, alternatives.
- Makes connections; gives the bigger picture.
- May hold and defend opinions (a reference may not).
- No step-by-step instructions — points to the how-to.

Weak (flag): an "Architecture overview" that's really a numbered setup procedure
with no rationale.

Strong (pass): "Why we chose event sourcing: the audit requirement made state
mutation a liability… the cost is read complexity, which we accept because…".

## Behavior-governing docs

Applies to rules, guidelines, conventions, runbooks, CLAUDE.md/AGENTS.md. Judged
on **adherence** — a clear rule that's ignored has failed.

Check:
- **Falsifiable** — each rule carries a check that can fail. No check → flag.
- **Enforce, don't advise** — must-every-time belongs in automation, not prose.
  Prose stating what a hook should enforce → flag.
- **Counterweighted** — names the failure on both sides, or it overcorrects.
- **Concrete + why** — specific action plus reason, never "write good code".
- **Attention budget** — deletion test on every line. CLAUDE.md ceiling ~200
  lines; a global file far less. Claiming imports save context → FAIL.
- **Right mechanism** — must-every-time → hook/permission; sometimes-relevant
  knowledge → a skill; judgment → the instruction file. Don't restate what the
  harness already enforces.
- **Layer-aware** — stacked files reviewed together for contradictions.
- **Not stale; markers sparing** — pruned on a trigger; more than one or two
  `IMPORTANT`/`YOU MUST` → flag (they over-trigger on current models).

Weak (FAIL): a 400-line global CLAUDE.md half-restating what the harness already
does, no test on any rule, `IMPORTANT` every third line.

Strong (pass): a 60-line file, each rule an imperative title + one-line why +
falsifiable `Test:`, with the must-every-time checks in a pre-commit hook.

## Anti-pattern catalog

| Anti-pattern | Smell | Fix |
|---|---|---|
| Type blend | Tutorial with a config table; reference that explains why | Split by purpose; link instead of inlining |
| Untested example | `npm run dev` that isn't in package.json | Run every example; paste real output |
| Time bomb | "currently", "the new API", "as of v2" | State the durable fact or pin to a version |
| Altitude lurch | Assumes expertise here, defines `git` there | Name the reader; hold one level; state prerequisites once |
| Wall of text | 600-word paragraph, no headings or lists | Descriptive headings, lists for sequences/sets |
| Terminology drift | field/attribute/property for one thing | One term per concept, everywhere |
| Passive vagueness | "it is recommended that config be applied" | Active voice, second person, concrete values |
| Click here | "click here", "this link", "read this" | Descriptive link text naming the destination |
| Narration comment | `// increment the counter` above `i++` | Delete; comment only what code can't say |
| Docstring-as-essay | Docstring explaining the algorithm's history | Reference only: params, returns, raises |
| Outsourced tutorial | "set it up as appropriate (see their docs)" | Spell out every step — tutorials guarantee the path |
| Advice for a must | Prose "always run the formatter" | Move to a hook/CI; prose is for judgment calls |
| Unchecked rule | A guideline with no way to tell if it's met | Add a `Test:` line that can fail |
| CLAUDE.md bloat | 300-line global file restating the harness | Deletion test; ~200-line ceiling; cut what's enforced elsewhere |
| Marker spray | `IMPORTANT`/`YOU MUST` on many rules | One or two at most; they over-trigger now |
| Duplicated source | Same facts in three docs, updated in lockstep | One source of truth; the rest link to it |
