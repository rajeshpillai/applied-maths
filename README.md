# Applied Maths — Grade 5 to Masters

An interactive, prerequisite-linked, **self-study** mathematics curriculum that
spans Grade 5 through Masters level. Every concept is connected to where it is
used in **Research, AI/ML, Game Development, Databases, Systems, and
Encryption**.

The aspiration is plain: *the best self-study mathematics curriculum in the
world*, reached incrementally.

## How this is different

- **Six-beat lesson template**, the same at every level: *Touch → Wonder →
  Discover → Name → Apply → Connect.* Synthesised from Pestalozzi & Froebel,
  the Socratic / Boole tradition, the Russian problem-first school, and the
  Indian Bhāskara sūtra style.
- **No teacher required.** Every lesson includes a pre-flight check, multiple
  representations of every idea, graduated hints on every exercise, full worked
  solutions, a "common confusions" callout, and a self-assessment.
- **One dependency graph, many paths.** The curriculum is a directed graph, not
  a linear textbook. Arrive curious about cryptography? Start at the end and
  follow the arrows back to the prerequisites you need.
- **Applied throughout.** Every lesson's *Connect* beat names which real
  domains the idea unlocks.

## Status

**Tiers 1, 2, 3, and 4 are complete: 60 lessons built (Grades 5 to 12).**
Begin at [01 · What is a Number?](lessons/tier-1-foundations/01-what-is-a-number/index.qmd).

Tiers 5–7 are outlined in [`_curriculum.yml`](_curriculum.yml) and will be
built next. See [`CLAUDE.md`](CLAUDE.md) for the authoring contract.

## Building locally

You need [Quarto](https://quarto.org/docs/get-started/) installed.

```bash
quarto render        # build the site into _site/
quarto preview       # live-reload server
```

## Contributing a lesson

Read [`CLAUDE.md`](CLAUDE.md) end to end. Then:

1. Add a new lesson entry to [`_curriculum.yml`](_curriculum.yml).
2. Create `lessons/tier-N-{slug}/{NN}-{title-slug}/index.qmd`.
3. Author the lesson against the six-beat template and the Self-Study
   Guarantees.
4. Tick every box on the "Done" checklist in `CLAUDE.md` before opening a PR.

## Influences

We learn from the best. Lessons are reviewable against: Gelfand Correspondence
School, Kiselev's *Geometry*, Hadamard's *Lessons in Geometry*, Art of Problem
Solving, 3Blue1Brown, Better Explained, NRICH, Khan Academy, Math Academy.
Where a problem or framing is borrowed, the source is named.
