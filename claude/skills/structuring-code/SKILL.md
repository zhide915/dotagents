---
name: structuring-code
description: Designs and restructures code toward deep modules — the most
  behavior behind the smallest interfaces — with the least code that works.
  Use when building a new feature or module that spans multiple files, or when
  asked to refactor, restructure, modularize, decompose, or untangle existing
  code — "this file is too big", "split this up", "clean up this module",
  "improve the architecture", "make this more testable". Not for one-line
  fixes or simple bug fixes, reviewing a finished diff, or runtime performance
  profiling and benchmarking.
---

# Structuring Code

Deliver the smallest well-placed change: behavior concentrated in deep
modules — small interfaces hiding substantial implementation — with no code
that didn't earn its place.

## Mode dispatch

Infer the mode from the request; ask only when genuinely ambiguous:

- Something new to build (feature, module, endpoint, component) → **Build**
- Existing code to restructure (refactor, split, modularize, untangle) →
  **Improve**
- A feature blocked by tangled code → **Improve** only the area that blocks
  it, then **Build**

## Rules (both modes)

**The ladder.** Before writing any code, stop at the first rung that holds:

1. Doesn't need to exist? Don't build it.
2. The codebase already does it? Reuse that helper or pattern.
3. The standard library does it? Use it.
4. A native platform feature does it? Use it.
5. An already-installed dependency does it? Use it.
6. It can be one line? Make it one line.
7. Only then: write the minimum new code that works.

Climb only after understanding: read the code the change touches and trace
the real flow end to end first. The smallest change in the wrong place is a
second bug, and a symptom fix that skips the shared root cause leaves sibling
callers broken.

**Depth.** A module (function, class, package — anything with an interface)
is deep when a small interface hides a lot of behavior, shallow when the
interface is nearly as complex as the implementation. Prefer one deep module
over several shallow ones. Judge suspects with the **deletion test**: imagine
deleting the module — if complexity just vanishes it was a pass-through; if
it reappears across callers it earns its keep.

**Seams.** Add an interface, abstraction, or layer only when at least two
concrete implementations sit behind it (typically production + test). One
implementation means no seam — inline it.

**Never trade away.** Minimal is not flimsy: keep input validation at trust
boundaries, error handling the caller can act on, and the failure paths that
actually occur. Non-trivial new logic gets a test at its interface.

## Mode: Build

1. Read the code the feature touches — callers, callees, and how the project
   already solves similar problems. Name the pattern you're following.
2. Climb the ladder for each piece of the feature.
3. If new modules are needed, design each interface before its
   implementation: fewest entry points, simplest parameters, complexity
   hidden inside. Load [deep-modules.md](deep-modules.md) for
   interface-design and testability patterns.
4. Place logic with the data it uses so each module changes for one reason;
   match the project's existing names.
5. Implement, then verify: run the project's build and tests; add a test at
   each new interface.
6. Final sweep: deletion test on every new module, two-implementations rule
   on every new abstraction. Delete what fails.

## Mode: Improve

1. Pin the scope and the goal: which files or area, and what "better" means
   for this request — smaller, more testable, less duplicated, easier to
   navigate.
2. Read the code in scope (use an Explore agent when it exceeds ~10 files)
   and hunt friction:
   - Shallow modules and pass-throughs that fail the deletion test
   - One concept's logic scattered across files — no single place to fix it
   - The same shape duplicated
   - A file edited for many unrelated reasons
   - Code untestable through its current interface
3. Present candidates in the format below, ranked, ending with the one you'd
   do first and why. **Stop and wait for the user's pick — do not start
   rewriting.**
4. Implement the pick in behavior-preserving steps, running tests between
   steps. Write tests at the new interface and delete the old tests they
   replace — don't keep both layers.
5. Report: what moved where, the interface before and after, and test
   results.

## Candidate format

For each candidate: **name — Strong / Worth exploring / Speculative**, then
Files, Problem, Change, Payoff, Effort (S/M/L).

## Example

Input: "The orders code is a mess — clean up how validation works."

One Improve-mode candidate, in the format above:

```markdown
**1. Merge the three validators into `OrderIntake` — Strong**
- Files: `orders/validate_shape.ts`, `orders/validate_stock.ts`,
  `orders/validate_payment.ts`, `orders/handler.ts`
- Problem: `handler.ts` calls three shallow validators in a fixed order and
  stitches their errors together — the ordering rule lives in the caller, so
  every new validation means editing two files.
- Change: one `OrderIntake.accept(order): Accepted | Rejected` that owns
  ordering and error shaping; the handler shrinks to a single call.
- Payoff: validation changes land in one file; the handler tests with one
  fake instead of three; the interface drops from three functions plus glue
  to one method.
- Effort: S
```

## Files

- [deep-modules.md](deep-modules.md) — module/interface/seam vocabulary, deep
  vs shallow, designing for testability, and dependency categories
  (in-process → third-party) with how each is tested. Load when designing a
  module interface, judging shallowness, or choosing where a seam goes.
