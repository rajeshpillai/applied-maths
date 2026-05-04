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

**All seven tiers are complete: 105 lessons built (Grade 5 through Masters specialisations).**
Begin at [01 · What is a Number?](lessons/tier-1-foundations/01-what-is-a-number/index.qmd) — or jump
to a Tier 7 capstone such as [15 · The Langlands Program](lessons/tier-7-masters-tracks/15-langlands-program/index.qmd).

The full dependency graph is in [`_curriculum.yml`](_curriculum.yml).
See [`CLAUDE.md`](CLAUDE.md) for the authoring contract used to build
every lesson.

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
./scripts/deploy-gh-pages.sh
```

That script renders the site into `_site/`, drops a `.nojekyll` marker,
force-pushes the build to the `gh-pages` branch on `origin`, and prints a
summary. It reuses your existing `origin` push credentials (SSH or HTTPS),
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
