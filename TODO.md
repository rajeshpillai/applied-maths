# TODO

## Close the FA-arc gap in MFRL track — Projected Bellman + Gradient-TD

**Status:** Planned and approved, paused mid-execution. Resume after the break.

**Plan file (full detail):** `/home/rajesh/.claude/plans/can-we-fix-the-immutable-harbor.md`

### Why this is on the list

Public reply on the curriculum's MFRL track claimed the FA arc "mentions
projected Bellman and the gradient-TD family in *what this unlocks* but
hasn't written those lessons yet." Exploration confirmed: L29's Stretch S1
*uses* the projected Bellman operator implicitly but never names it; L30
explains the deadly-triad symptom but not the operator that's broken; L31
(DQN) is honest about not solving the triad but points forward to nothing.

Reader currently leaves the FA arc thinking DQN's engineering tricks are the
only route. The gradient-TD family (GTD, GTD2, TDC) is the alternative —
slower, more bookkeeping, but mathematically defuses the triad. Zhao
*MFRL* §8.4 covers it; the curriculum doesn't yet.

### Scope (agreed)

**Two new lessons**, inserted between current L31 (DQN) and current L32
(Policy Parameterization). Existing L32–L38 renumber to L34–L40 (folder
paths + title strings only — lesson-IDs are stable, so prereq chains do
not break).

- **New L32 — Projected Bellman Operator & MSPBE**
  `lesson-id: mfrl.projected-bellman-operator`
  Touch = projection onto feature-span plane. Discover builds
  Π_μ T_π as a γ-contraction on-policy, breaks it off-policy. Names
  MSPBE.

- **New L33 — Gradient-TD: GTD, GTD2, TDC**
  `lesson-id: mfrl.gradient-td`
  Touch = the "other half" of the semi-gradient. Discover derives MSPBE's
  true gradient, double-sampling problem, auxiliary parameter u,
  two-time-scale GTD/TDC updates. Apply runs Baird's counterexample
  (diverges semi-grad, converges TDC).

### Execution checklist (resume order)

The conversation paused before picking a pacing. Decide first:

- [ ] **Choose pacing** — three options on the table:
  1. One lesson at a time, review between drafts (best fit for iterative style)
  2. Mechanical changes (renames + manifest + render) first, then both lessons together
  3. Full execution in one go

Then do the work:

- [ ] **Rename folders** (git mv, in this order to avoid clashes):
  - `32-policy-parameterization/` → `34-policy-parameterization/`
  - `33-policy-gradient-theorem/` → `35-policy-gradient-theorem/`
  - `34-reinforce/` → `36-reinforce/`
  - `35-actor-critic-qac/` → `37-actor-critic-qac/`
  - `36-advantage-actor-critic/` → `38-advantage-actor-critic/`
  - `37-off-policy-actor-critic/` → `39-off-policy-actor-critic/`
  - `38-deterministic-actor-critic/` → `40-deterministic-actor-critic/`
- [ ] **Update `_curriculum.yml`** — insert two new entries after
      `mfrl.deep-q-network`; update `title:` and `path:` for the seven
      renumbered lessons. **Do not change `id:` fields** — they're the
      stable references prereqs depend on.
- [ ] **Author new L32** (`lessons/tier-mfrl-rl-math/32-projected-bellman-operator/index.qmd`)
      following the six-beat template. Required: pre-flight, ≥1 fun-fact,
      exactly 1 key-insight, common-confusions, Takeaways (3 intuitive
      bullets), Self-Assessment, full Connect block. Tsitsiklis–Van Roy 1997
      as the fun-fact citation.
- [ ] **Author new L33** (`lessons/tier-mfrl-rl-math/33-gradient-td/index.qmd`)
      same six-beat structure. Sutton/Maei 2009 GTD as fun-fact. Baird's
      counterexample as the Apply worked example.
- [ ] **Glossary** — add 4 entries to `glossary.qmd` with stable anchors and
      "First named in" backlinks:
  - `#projected-bellman-operator` → new L32
  - `#mspbe` → new L32
  - `#gradient-td` → new L33
  - `#tdc` → new L33
- [ ] **Backfill *What this unlocks*** in three existing lessons:
  - `29-td-with-function-approximation/index.qmd` → point at `mfrl.projected-bellman-operator`
  - `30-q-learning-with-fa/index.qmd` → point at `mfrl.gradient-td`
  - `31-deep-q-network/index.qmd` → point at `mfrl.gradient-td`
- [ ] **`quarto render`** from repo root — no warnings expected. Verifies
      renumbered folders still resolve and the new lessons typeset.
- [ ] **Walk new lessons cold** as a learner straight off L31. Pre-flight
      should pass; no forward references; the new idea should feel
      inevitable by the last Discover problem.

### Out of scope (do not expand)

- Emphatic TD as its own lesson (referenced only in L33 Stretch).
- Full Tsitsiklis–Van Roy proof (L32 cites; intuition only).
- Rewriting the renumbered L39 (off-policy actor-critic) to use gradient-TD
  — Zhao uses importance sampling there; existing lesson is faithful.
