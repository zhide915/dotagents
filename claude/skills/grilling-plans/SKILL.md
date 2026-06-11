---
name: grilling-plans
description: Attacks a plan or design to find where it breaks before it ships
  — finds contradictions, points out what could fail, and forces a choice when
  two goals clash, then writes the decisions down. Use when the user says "grill
  me", "stress-test this plan", "poke holes in this", "red-team my design", or
  wants a plan challenged before building. Not for friendly co-design or normal
  design help — this one is hard on the plan on purpose.
---

# Grilling Plans

Test a plan by trying to break it before it gets built. A normal design chat
helps *build* the plan; this one looks for where it *fails*. Be hard on the
plan, never on the person.

## Workflow

1. **Make the goal clear first.** Open with an AskUserQuestion (see the rule in
   step 4): what is the plan for, and how will they know it worked? Offer the
   likely goals as the options. Push until it's something you can measure —
   "make it faster" becomes "faster than what, and measured how?" Don't start
   until the goal is clear: you check every later answer against it, so a fuzzy
   goal makes the whole thing pointless.

2. **Look things up yourself.** If a question depends on something the code
   already answers — how it works now, what other code expects, which pattern is
   used — read the code instead of asking. Only spend the user's time on choices
   that need their opinion.

3. **List the decisions the plan depends on, and put them in order.** Write out
   the choices the plan is built on (where does the data live? do it now or
   later? add a new tool?). Start with the one the others depend on, so a later
   answer never rests on a choice that isn't settled yet.

4. **Question one decision at a time.** Ask every question with the
   AskUserQuestion tool — one question per turn. Offer the realistic answers as
   the options, put your recommended answer first and mark it "(recommended)",
   and give each option a one-line reason. The user can always pick "Other" to
   reject the premise. Every question should do one of three things:
   - **Show what could break** — what goes wrong under heavy use, on an error,
     or in a rare case. Example: "What happens when the cached data is old?"
   - **Show a hidden cost** — extra work the plan creates but doesn't mention.
     Example: "Redis is one more service to run — who fixes it at 3am?"
   - **Catch a clash** — an answer that fights the goal or an earlier answer.
     Example: "You said simple matters most, but this adds a service. Which one
     wins?" Make the user choose one — never mix two goals that fight each other
     into a middle option that does neither well.

5. **Pause and point to what's next.** When you've gone deep on the current
   decision and have no more sharp questions for it, stop — don't pad with weak
   ones. Before handing back, tell the user in a few lines: what you've now
   settled, which decisions from step 3 you haven't grilled yet, and the one
   you'd attack next. Ask whether to keep going there or stop. Continue only on
   their go-ahead. The plan is fully grilled when every decision from step 3 is
   settled or dropped on purpose.

6. **When the session ends** — fully grilled, or the user calls it — write the
   decisions to `decisions/<timestamp>-<plan-name>.md` under the working folder,
   one file per session. Get `<timestamp>` by reading the current date and time
   from the system in `YYYY-MM-DD-HHMM` format — run whatever command does that
   on the current shell, never type it from memory; wrong dates break the
   chronological sort. Slugify the plan name to lowercase words joined by
   hyphens. Use the template below.

7. **End with a short look back (2–3 sentences).** Tell the user where the
   choice that really mattered was. Watch for two patterns: the questions got
   stuck on small build details when the real choice was a bigger goal — or
   argued about goals when the answer was just a fact about the existing code.
   Point to where their thinking helped most.

## Decision file template

```markdown
# <Plan name> — decisions

**Goal:** <the one sentence from step 1>
**Done looks like:** <something you can check>

## Settled
- **<Decision>:** <choice> — because <reason>. Said no to <other option>
  because <reason>.

## Open risks
- <A problem that survived but couldn't be closed, and what would make you
  come back to it>

## Where the choice that mattered was
<the look back from step 7>
```

## Example

Input: "Grill me — I'm adding a Redis cache to speed up the API."

A grilling question looks like this — asked with the AskUserQuestion tool:

```
Question: When Redis is down, what should the API do?

  ▸ Fall back to the database (recommended)
      Keeps serving requests. But if the database alone can't hit your
      200ms target, the cache is the only thing keeping you fast — so
      "one server" was never real, and you'll have to give that up.
    Fail the request
      Simplest to build, but users hit errors on every cache blip.
    Other
      Reject the premise — e.g. "the cache must never be load-bearing."
```

One question, doing the real work: it lays out the actual choices, names the one
you'd recommend and why, and still forces the user to face the clash between two
goals that can't both hold (fast vs. one server).
