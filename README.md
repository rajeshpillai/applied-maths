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
  solutions, a "common confusions" callout, a one-line "key insight" aha, a
  short three-bullet *Takeaways* recap, and a self-assessment.
- **Site-wide [glossary](glossary.qmd).** Every term any lesson formally names
  has a plain-English entry, with a link back to the lesson where it was first
  introduced. Forget what an *intercept* is six tiers later? One click.
- **One dependency graph, many paths.** The curriculum is a directed graph, not
  a linear textbook. Arrive curious about cryptography? Start at the end and
  follow the arrows back to the prerequisites you need.
- **Applied throughout.** Every lesson's *Connect* beat names which real
  domains the idea unlocks.

## Status

**All seven tiers are complete: 105 lessons built (Grade 5 through Masters specialisations).**
Begin at [01 · What is a Number?](lessons/tier-1-foundations/01-what-is-a-number/index.qmd) — or jump
to a Tier 7 capstone such as [15 · The Langlands Program](lessons/tier-7-masters-tracks/15-langlands-program/index.qmd).

The full dependency graph is in [`_curriculum.yml`](_curriculum.yml).
See [`CLAUDE.md`](CLAUDE.md) for the authoring contract used to build
every lesson.

### CBSE / NCERT track (Class 8 – Class 12)

A parallel, board-exam-aligned track follows the **rationalised 2023
NCERT** syllabus chapter by chapter. It is for learners sitting CBSE
boards or any other Indian board that follows NCERT. Every CBSE lesson
uses the same six-beat contract and adds two extras:

- a **Board-Pattern Practice** block in *Apply* (1/2/3/4-mark style
  questions plus NCERT Exemplar / previous-year pointers); and
- a **NCERT chapter alignment** block in *Connect* with a link to the
  sister synthesis lesson in the main tiers.

Start at the [CBSE / NCERT Track Overview](cbse/index.qmd), or jump
straight to your class:
[Class 8](lessons/tier-cbse-08-class-8/index.qmd) ·
[Class 9](lessons/tier-cbse-09-class-9/index.qmd) ·
[Class 10 (Board)](lessons/tier-cbse-10-class-10/index.qmd) ·
[Class 11](lessons/tier-cbse-11-class-11/index.qmd) ·
[Class 12 (Board)](lessons/tier-cbse-12-class-12/index.qmd).

### Kiselev — Russian Classical track (pilot)

A third track follows **A. P. Kiselev's** classical Russian textbooks
chapter-by-chapter — *Algebra* (Parts I & II) and *Geometry*
(*Planimetry* and *Stereometry*). It is for learners who want the
rigorous, deductive, problem-first presentation that trained sixty
million Soviet students. Every Kiselev lesson uses the same six-beat
contract and adds two extras:

- a **Kiselev-style problems** block in *Apply* (3 problems adapted
  from Kiselev's own exercise sets, in his terse style); and
- a **Kiselev chapter alignment** block in *Connect* with the source
  book/chapter/section and a link to the sister synthesis lesson.

**Track complete: 36 lessons across all five Kiselev books.** Start
at the [Kiselev Track Overview](kiselev/index.qmd), or jump to a
book:
[Arithmetic](lessons/tier-kiselev-0-arithmetic/index.qmd) ·
[Algebra Part I](lessons/tier-kiselev-1-algebra-1/index.qmd) ·
[Algebra Part II](lessons/tier-kiselev-2-algebra-2/index.qmd) ·
[Planimetry](lessons/tier-kiselev-3-planimetry/index.qmd) ·
[Stereometry](lessons/tier-kiselev-4-stereometry/index.qmd).

## Building locally

You need [Quarto](https://quarto.org/docs/get-started/) installed.

```bash
quarto render        # build the site into _site/
quarto preview       # live-reload server
```

## Deploying to GitHub Pages

The site is published from the `gh-pages` branch of this repo. A helper
script handles the render-and-push:

```bash
./scripts/deploy-gh-pages.sh           # delta deploy (default, fast)
./scripts/deploy-gh-pages.sh --full    # full reset: wipe gh-pages, force-push
```

The default **delta** mode shallow-clones the existing `gh-pages` branch
into `_site/.git`, lets Quarto render on top, then commits and pushes only
what changed — git transfers only the changed objects, so deploys after the
first one are quick. If `gh-pages` doesn't exist yet on the remote, the
script falls back to `--full` automatically so the first deploy bootstraps
cleanly.

Use `--full` when the `gh-pages` history is corrupted, when you want to
reclaim space on that branch, or when you want a guaranteed clean slate.

The script reuses your existing `origin` push credentials (SSH or HTTPS),
so no extra auth setup is needed. Override the destination by exporting
`DEPLOY_REPO=...` before running.

**One-time GitHub setup** (only needed the first time):

1. Go to **Settings → Pages** on the repo.
2. Under *Build and deployment*, set **Source** to *Deploy from a branch*.
3. Pick branch `gh-pages` and folder `/ (root)`. Save.

The site goes live at <https://rajeshpillai.github.io/applied-maths/>
within a minute or two. After that, every deploy is just one command.

### Alternative: GitHub Actions

To deploy automatically on every push to `main`, drop a workflow into
`.github/workflows/publish.yml`:

```yaml
on:
  push:
    branches: [main]
  workflow_dispatch:

name: Quarto Publish

jobs:
  build-deploy:
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
      - uses: actions/checkout@v4
      - uses: quarto-dev/quarto-actions/setup@v2
      - uses: quarto-dev/quarto-actions/publish@v2
        with:
          target: gh-pages
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

Add Python/Julia/R setup steps before `publish` if any lesson uses
executable code blocks in those languages.

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
