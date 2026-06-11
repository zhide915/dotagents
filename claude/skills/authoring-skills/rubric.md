# Skill evaluation rubric

Full criteria for the eight dimensions, each with a weak and a strong example,
followed by the anti-pattern catalog. Verdicts: pass / flag / FAIL as defined
in SKILL.md.

## Contents

- 1. Trigger quality
- 2. Scope tightness
- 3. Structure
- 4. Progressive disclosure
- 5. Instruction clarity
- 6. Examples and anti-patterns
- 7. Portability
- 8. Testability
- Anti-pattern catalog

## 1. Trigger quality

The description is the only thing the agent sees when deciding whether to load
the skill — it competes against every other skill's description.

Check:
- Third person throughout ("Extracts text…", never "I can help…" or
  "You can use this…").
- States what the skill does AND when to use it, with concrete terms a user
  would actually type: file types, operation names, domain nouns.
- Key use case first — hosts truncate long listing text.
- A "not for X" clause when a nearby skill or common task could collide.
- The `name` itself carries signal (gerund form preferred: `processing-pdfs`,
  `authoring-skills`) — vague names (`helper`, `utils`, `tools`) FAIL.

Weak (FAIL):
```yaml
description: Helps with documents
```
No operations, no trigger terms, nothing to match a real request against.

Strong (pass):
```yaml
description: Extracts text and tables from PDF files, fills forms, merges
  documents. Use when working with PDF files or when the user mentions PDFs,
  forms, or document extraction.
```

## 2. Scope tightness

One skill, one job. A skill that does several things triggers wrongly for all
of them and loads irrelevant content into context.

Check:
- The skill's purpose fits in one sentence without "and".
- What the skill will NOT do is statable in one sentence — if you can't say
  what's out of scope, the scope is untested.
- No overlap with another installed skill's trigger surface; if two skills
  could both plausibly fire on the same request, at least one needs a "not
  for X" boundary.

Weak (flag): a `data-tools` skill covering CSV parsing, chart generation, SQL
queries, and report emailing — four trigger surfaces, four chances to misfire,
and every invocation pays for the other three jobs' content.

Strong (pass): `analyzing-spreadsheets` — "Analyze Excel spreadsheets, create
pivot tables, generate charts. Use when analyzing Excel files, spreadsheets,
tabular data, or .xlsx files." Charts are in scope only as spreadsheet output.

## 3. Structure

The agent runs the body as written, in order — a step out of sequence or a
decision point left as prose becomes a wrong turn at runtime.

Check:
- Multi-step procedures are numbered workflows; complex ones provide a
  checklist the agent copies into its response and checks off.
- Decision points are explicit conditionals ("Creating new content? → follow
  Creation workflow"), not prose the agent must untangle.
- Degrees of freedom match fragility:
  - Fragile/sequential operations → low freedom: exact commands, "do not
    modify or add flags".
  - Judgment tasks → high freedom: goals and heuristics, trust the model.
  - Mismatch in either direction is a flag — exact commands for a judgment
    task over-constrain; vague guidance for a fragile sequence breaks things.
- One term per concept throughout (always "field", not field/box/element).

Weak (flag):
```markdown
Process the document, validate it when appropriate, and handle any issues.
```
No steps, no order, no definition of "appropriate" or "handle".

Strong (pass):
```markdown
1. Make edits to `word/document.xml`
2. Validate immediately: `python ooxml/scripts/validate.py unpacked_dir/`
3. If validation fails: fix the XML, run validation again
4. Only proceed when validation passes
```

## 4. Progressive disclosure

Three loading levels: description (always in context), SKILL.md body (loaded
on trigger, then stays in context for the session), reference files (loaded
on demand). Every body line is a recurring cost once loaded.

Check:
- Body under 500 lines (hard constraint); only content every invocation needs.
- Per-situation detail lives in reference files, each linked directly from
  SKILL.md with a cue saying when to load it ("For tracked changes: see
  REDLINING.md").
- References one level deep — a reference linking to another reference gets
  partially read (FAIL).
- Reference files over 100 lines start with a table of contents.
- Scripts are executed, not pasted into context; instructions say which
  ("Run `analyze.py`" vs "See `analyze.py` for the algorithm").
- No content duplicated between body and references.

Weak (flag): a 480-line SKILL.md where 300 lines are an API reference used by
one of its five workflows — within the limit but every invocation pays for it.

Strong (pass): body holds the workflow and links `reference/finance.md`,
`reference/sales.md` — a sales question loads only sales.md.

## 5. Instruction clarity

The body is an instruction to the agent, not a description of the skill — every
sentence it must read is one it can misread, or already knew.

Check:
- Imperative, addressed to the agent: "Run X", "Check Y" — not "the user might
  want" or narration about what the skill does.
- Nothing the agent already knows: no explaining what PDFs are, what a library
  is, what git is, how to install pip packages in general. Challenge every
  sentence with "does this justify its token cost?"
- One default approach with an escape hatch — not a menu ("use pdfplumber;
  for scanned PDFs requiring OCR, use pdf2image instead"). Option menus
  without a default are a flag.
- All constants justified ("timeout 30s: typical requests finish in under 30s") —
  unexplained magic numbers are a flag: if the author can't say why 47,
  neither can the agent.
- Standing instructions, not one-time steps — skill content persists across
  the session, so write rules that hold for the whole task.

Weak (flag):
```markdown
PDF files are a common format containing text and images. There are many
libraries available; pdfplumber is recommended because it is easy to use.
First install it with pip. Then you can use the code below…
```

Strong (pass):
```markdown
Extract text with pdfplumber:
    import pdfplumber
    with pdfplumber.open("file.pdf") as pdf:
        text = pdf.pages[0].extract_text()
```

## 6. Examples and anti-patterns

Output format is caught from examples, not from adjectives — where the shape
matters, one concrete input→output pair pins it better than a paragraph.

Check:
- Where output format or style matters, the skill shows input→output pairs —
  examples communicate level of detail better than description.
- Output templates exist where structure matters, with strictness declared
  ("ALWAYS use this exact structure" vs "sensible default, adapt as needed").
- Known failure modes are named as anti-patterns with the fix, not just
  "be careful".
- Examples are concrete (real commands, real field names), not abstract
  placeholders ("process the data appropriately").

Weak (flag): "Generate commit messages following conventional commits" — the
convention has variants; without an example the output style is a coin flip.

Strong (pass): three input→output commit-message pairs followed by "Follow
this style: type(scope): brief description, then detailed explanation."

## 7. Portability

A path or tool that exists only on the author's machine works in testing and
breaks for everyone else — portability is what survives the move to another
project, host, or model.

Check:
- No machine- or repo-specific absolute paths in skill logic; bundled files
  referenced relative to the skill's directory. (Exception: a personal skill may
  encode its owner's conventions — a default output directory is fine when
  that's the skill's job. The test is whether the path is the skill's
  *subject* or an unstated *assumption*.)
- Forward slashes everywhere, including on Windows.
- Required tools and packages declared before use ("Install: `pip install
  pypdf`"), never assumed.
- MCP tools referenced by fully qualified name (`ServerName:tool_name`).
- No time-sensitive content ("before August 2025 use the old API") — move
  legacy info to a collapsed "old patterns" section or delete it.
- Works at the capability floor: if the skill will run on smaller models,
  instructions are explicit enough for them ("test with all models you plan
  to use").

Weak (FAIL): `Run C:\Users\me\tools\validate.py before committing` — breaks on
any other machine and uses backslashes.

Strong (pass): `Run scripts/validate.py before committing` — path relative to
the skill's own directory.

## 8. Testability

A skill you can't check is one you can't trust fired right — testability turns
"should work" into a result you can see.

Check:
- A trigger test set exists or is derivable: prompts that should fire the
  skill and nearby prompts that must not (see testing.md).
- Success criteria are checkable: "extracts text from all pages, saves to
  output.txt" — not "handles the PDF well".
- Quality-critical steps have validation loops: run validator → fix → repeat
  until pass, with the validator named.
- Skills with side effects (deploy, commit, send) are restricted to manual
  invocation (`disable-model-invocation: true` where the host supports it) —
  a side-effecting skill the agent can fire on its own is a FAIL.
- Bundled scripts handle their own error conditions with specific messages
  ("Field 'signature_date' not found. Available fields: …") rather than
  crashing for the agent to debug.

Weak (flag): a deploy skill whose only check is "verify the deployment
succeeded" — no command, no expected output, not falsifiable.

Strong (pass): "Step 5: Run `verify_output.py output.pdf`. If verification
fails, return to Step 2."

## Anti-pattern catalog

| Anti-pattern | Smell | Fix |
|---|---|---|
| Vague description | "Helps with documents" | Name operations + trigger terms users would type |
| Wrong person | "I can help you…" / "You can use this…" | Rewrite third person; inconsistent POV breaks discovery |
| Explaining the known | Defines PDFs, libraries, git | Delete; assume a smart reader |
| Option menu | "Use pypdf, or pdfplumber, or PyMuPDF, or…" | One default + escape hatch for the named exception |
| Deep nesting | SKILL.md → advanced.md → details.md | All references link directly from SKILL.md |
| Time bomb | "Before August 2025 use the old API" | Current method only; legacy in a collapsed section |
| Terminology drift | field/box/element for one concept | One term, used everywhere |
| Windows paths | `scripts\helper.py` | Forward slashes everywhere |
| Voodoo constants | `TIMEOUT = 47  # why?` | Justify every value in a comment |
| Punting script | `return open(path).read()` and let the agent debug | Script handles its own errors with specific messages |
| Assumed tools | "Use the pdf library" | Declare installs before use |
| Kitchen sink | One skill, four jobs | Split, or cut to the one job the trigger promises |
| Narration | Body describes what the skill does instead of instructing | Imperative voice: Run, Check, Stop |
| Unmarked side effects | Deploy/commit skill auto-invocable | Restrict to manual invocation (`disable-model-invocation: true` where supported) |
