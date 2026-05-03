# CLAUDE.md — Authoring Contract

This file is the contract every lesson in this repository must honour. It is
read by both human authors and AI collaborators (including Claude Code) before
writing or editing any lesson. **If a lesson cannot satisfy the checklist at the
end of this file, it is not done — no matter how much content it contains.**

## The Mission

Build the best self-study mathematics curriculum in the world, from Grade 5 to
Masters, with every concept connected to where it is used in **Research, AI/ML,
Game Development, Databases, Systems, and Encryption**.

The reader is alone. There is no teacher to ask. Every lesson must respect that.

## The Six-Beat Lesson Template

Every lesson — at every level, in every tier — uses these six headings, in this
order, with these names. No exceptions, no renames, no reordering.

```markdown
## Touch
## Wonder
## Discover
## Name
## Apply
## Connect
```

### 1. Touch — Pestalozzi / Froebel

Open with a concrete object the learner can manipulate. A widget, a printable
cut-out, a physical thing they have in their kitchen, a drag-able diagram. **Do
not name the concept yet.** The goal is direct sensory contact.

> *"Anschauung ist das absolute Fundament aller Erkenntnis." — Pestalozzi.*
> Direct perception is the absolute foundation of all knowledge.

If you cannot find a Touch for your topic, your topic is wrong — break it down
further. Every mathematical idea has a concrete shadow.

### 2. Wonder — Socratic / Mary Everest Boole

Two to four open questions about what the learner just touched. **No answers.**
The questions surface the learner's existing intuitions before any new
vocabulary lands.

> *"Take the child's mind, as you find it, ... and let questions be your
> chisel." — Mary Everest Boole.*

Bad Wonder questions: "What do you notice?" (too vague). "Is this addition?"
(leading; gives away the answer).
Good Wonder questions: "If you doubled the longer stick, what would happen to
the shape?" "Could you make this with three objects instead of four?"

### 3. Discover — Russian problem-first (Gelfand, Shen, Kiselev)

A short ordered sequence — **3 to 7 problems** — that forces the new idea to
crystallise in the learner's head before the text names it. The text only
nudges; it never gives the technique away.

> *"A good problem is a small theorem the student proves themselves." —
> attributed to Gelfand.*

Each problem should be solvable using only the prerequisites. The sequence
should make the new concept feel inevitable by the last problem.

### 4. Name — Bhāskara sūtra

State the formal definition or theorem **once, compactly**. One or two
sentences. Where appropriate, write a short verse-style mnemonic the learner can
memorise.

> *Bhāskara's Līlāvatī states each rule in a single Sanskrit verse, then
> illustrates it with a vivid problem set in a real scene.*

This beat is short. If it is long, you have not understood the idea well enough
to name it.

### 5. Apply — Bhāskara worked example + graded practice

One vivid worked problem, fully solved with reasoning shown step-by-step. Then
a graded practice set:
- **Warm (3 problems):** direct application of the definition.
- **Working (3 problems):** mild twist; combine with one earlier idea.
- **Stretch (1–2 problems):** non-trivial; rewards thought.

**Every problem has graduated hints and a full worked solution** (see Self-Study
Guarantees below).

### 6. Connect — Curriculum-wide

This beat has three required sub-sections:

- **Prerequisites used.** Bullet list of the lesson IDs (from `_curriculum.yml`)
  this lesson relied on, with one-line reminders.
- **What this unlocks.** Bullet list of the lesson IDs that become accessible
  after this one.
- **Where this matters.** At least one applied-domain callout — a single
  sentence per domain — explaining how this idea is used in the real world. Use
  the `.applied-callout` class.

## Self-Study Guarantees

Because the learner has no teacher to ask, every lesson must include:

1. **Pre-flight check.** A boxed section *above* `## Touch` with 3-5 yes/no
   questions: "Are you ready for this lesson?" Each question links to the
   prerequisite lesson the learner should revisit if they answered no. Use the
   `.preflight-check` class.

2. **Multiple representations.** Every new idea is shown in at least three of:
   visual diagram, numerical example, algebraic statement, plain-English
   verbal. Different intuitions land for different learners.

3. **Graduated hints on every exercise.** Use this exact disclosure structure:

   ```markdown
   <details class="hint"><summary>Hint 1 — a nudge</summary>
   ...
   </details>
   <details class="hint"><summary>Hint 2 — the technique</summary>
   ...
   </details>
   <details class="hint"><summary>Hint 3 — the first step</summary>
   ...
   </details>
   <details class="hint"><summary>Full solution</summary>
   ...
   </details>
   ```

4. **Worked solution for every exercise.** No exceptions. The learner must be
   able to see how a competent solver thinks, not just the final answer.

5. **Common confusions.** A `.common-confusion` callout naming the 1-3
   misconceptions a learner typically forms about this topic, with a short
   explanation of why each is wrong.

6. **Self-assessment.** At the very bottom, before `## Connect`, three honest
   questions the learner answers themselves, with a recommendation. Example:

   ```markdown
   ### Self-Assessment

   Be honest with yourself.

   1. Could you explain *why* [the rule] works to a friend, without notes?
   2. Did you solve at least 5 of the 7 practice problems without peeking at
      hints?
   3. Can you spot when a problem in the wild calls for this idea?

   - **3 yes:** move on.
   - **2 yes:** do the Stretch problems again, then move on.
   - **0–1 yes:** re-read Discover and Apply; the idea hasn't landed yet.
   ```

## Voice and Style

- **Address the learner directly.** "You" not "the student" or "one."
- **Concrete before abstract, always.** A noun the reader can picture beats a
  precise but unimaginable definition every single time.
- **Short sentences. Short paragraphs.** The reader is doing hard cognitive work
  already; do not add prose-parsing to it.
- **No jargon without naming it in *Name*.** If you use a term in *Discover*,
  it must be either (a) common English or (b) defined in a prior lesson and
  declared as a prerequisite.
- **No forward references.** A lesson never says "as you'll see later." Every
  idea used must already exist for this learner.
- **Cite the touchstone.** Where a problem or framing is borrowed from Gelfand,
  Kiselev, NRICH, AoPS, 3Blue1Brown, Better Explained, etc. — name them. Steal
  the inspiration, never the wording.

## File and Folder Conventions

A lesson lives at:
```
lessons/tier-N-{slug}/{NN}-{kebab-case-title}/index.qmd
```

The lesson's directory may also contain:
- `widgets/` — Observable JS, Plotly, or static SVG specific to this lesson.
- `exercises.qmd` — extra problems beyond the *Apply* graded set, optional.
- `images/` — diagrams. Prefer SVG; PNG only if needed.

### Required YAML front matter

Every lesson `index.qmd` starts with:

```yaml
---
title: "Lesson Title — Short and Vivid"
lesson-id: "t1.what-is-a-number"          # matches _curriculum.yml entry
tier: 1
prerequisites: []                          # list of lesson-ids
unlocks: ["t1.number-line"]                # list of lesson-ids
applied-domains: ["encryption", "ai-ml"]   # zero or more
estimated-minutes: 25
---
```

### Math typesetting

- Inline math: `$x^2 + 1$`.
- Display math: `$$ \int_0^1 x^2 \, dx = \frac{1}{3} $$`.
- KaTeX is the renderer (configured in `_quarto.yml`). Test that complex
  expressions render before committing.

### Widget conventions

- Reusable widgets (number line, fraction bar, unit circle, vector arrow) live
  at the repo root in `widgets/`.
- Lesson-specific widgets live in `lessons/.../widgets/`.
- Prefer Observable JS (`{ojs}` blocks in Quarto) for browser interactivity —
  no extra build step.
- Static visualisations (Matplotlib, Plotly) go in `{python}` blocks; cache
  with `execute: freeze: auto` (already configured).
- Every widget gets a one-line caption explaining what to manipulate.

## Design Influences (Touchstones)

We do not invent in a vacuum. Each lesson should be reviewable against at least
one of these:

- **Gelfand Correspondence School** — terse, problem-first sequencing for
  older learners.
- **Kiselev's *Geometry* / Hadamard's *Lessons in Geometry*** — the gold
  standard for proof exposition; clarity through restraint.
- **Art of Problem Solving** — graduated problem difficulty; "discover the
  technique" pedagogy.
- **3Blue1Brown** — visual intuition for ideas usually taught only
  symbolically.
- **Better Explained (Kalid Azad)** — the "Aha!" framing; lead with the
  intuitive metaphor.
- **NRICH (Cambridge)** — rich, low-floor-high-ceiling problems that work
  across ability levels.
- **Khan Academy** — mastery-based progression; we borrow philosophy, not
  format.
- **Math Academy** — explicit prerequisite graphs; spaced review.

When borrowing a problem or framing, **name the source** in a footnote.

## The "Done" Checklist

A lesson is not done until **every box** is checked.

### Six-Beat Template
- [ ] `## Touch` — concrete, no vocabulary, manipulable.
- [ ] `## Wonder` — 2–4 questions, no answers.
- [ ] `## Discover` — 3–7 ordered problems forcing the idea.
- [ ] `## Name` — definition stated compactly, one or two sentences.
- [ ] `## Apply` — worked example + Warm / Working / Stretch problems.
- [ ] `## Connect` — Prerequisites used, Unlocks, Where this matters.

### Self-Study Guarantees
- [ ] Pre-flight check at the top.
- [ ] Multiple representations of every new idea (≥3 of: visual, numerical,
      algebraic, verbal).
- [ ] Graduated hints (Hint 1, 2, 3, Full solution) on every exercise.
- [ ] Worked solution for every exercise.
- [ ] Common-confusions callout.
- [ ] Self-assessment block above `## Connect`.

### Curriculum Hygiene
- [ ] YAML front matter present and matches `_curriculum.yml`.
- [ ] No forward references; nothing used that isn't a declared prerequisite.
- [ ] At least one applied-domain callout in `## Connect`.
- [ ] Reviewable against at least one design touchstone (named in a comment or
      footnote).

### Build
- [ ] `quarto render` succeeds with no warnings.
- [ ] Walked the lesson straight through as a learner would; it makes sense
      with only the prerequisites.

## When in Doubt

- **Cut, don't add.** A short lesson the learner finishes beats a thorough
  lesson they abandon halfway.
- **One idea per lesson.** If your *Name* beat has two definitions, you have
  two lessons.
- **The widget proves the idea before the text does.** If the widget feels
  decorative, redesign it until it carries weight.
- **Read the lesson aloud.** If you stumble, the learner will too.
