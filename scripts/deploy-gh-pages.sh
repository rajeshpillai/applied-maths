#!/bin/bash
# Deploy the rendered Quarto site to GitHub Pages.
#
# Usage:
#   ./scripts/deploy-gh-pages.sh             # full render + delta push (safe default)
#   ./scripts/deploy-gh-pages.sh --changed   # render only .qmd files changed since
#                                            # the last deploy, then delta push.
#                                            # Falls back to full render if any
#                                            # "global" file changed.
#   ./scripts/deploy-gh-pages.sh --full      # full render + force-push fresh history
#                                            # (use to reset gh-pages or for the
#                                            # very first deploy of a new repo).
#
# Wall-clock honesty: the default and --full both run a full `quarto render`,
# which dominates total deploy time (~2–3 min for ~250 pages). Delta push only
# saves bandwidth and preserves gh-pages history. --changed is the actual speed
# lever: it skips Quarto for every unchanged lesson and brings deploy time down
# to seconds when you've touched one or two .qmd files.
#
# Each deploy commit on gh-pages carries a `Source-SHA:` trailer pointing back
# at the main-branch commit it was built from. --changed reads that trailer to
# decide which files to re-render. If the trailer is missing or unreadable
# (e.g. very old gh-pages history), --changed falls back to a full render.
#
# Files that trigger a full re-render even in --changed mode (because they
# affect every rendered page):
#   - styles/*.scss, styles/*.css      (theme)
#   - _quarto.yml                       (navbar, sidebar, project config)
#   - _curriculum.yml                   (lesson graph, used by listings)
#   - assets/**                         (site-wide includes)
#   - widgets/**                        (shared widget resources)
#
# The push URL is inherited from the parent repo's `origin` remote so whichever
# auth (SSH or HTTPS credential helper) you already have set up for normal
# pushes is reused. Override by exporting DEPLOY_REPO.

set -e

MODE="delta"
case "${1:-}" in
  --full)    MODE="full" ;;
  --changed) MODE="changed" ;;
  "")        ;;
  *)         echo "error: unknown flag '$1' (expected --full, --changed, or no flag)" >&2; exit 2 ;;
esac

REPO="${DEPLOY_REPO:-$(git remote get-url origin)}"
DIST_DIR="_site"
BRANCH="gh-pages"
SOURCE_SHA="$(git rev-parse HEAD)"

if [ -z "$REPO" ]; then
  echo "error: could not determine push URL — set DEPLOY_REPO or add an 'origin' remote." >&2
  exit 1
fi
echo "Pushing to: $REPO  (mode: $MODE)"
echo "Source SHA: $SOURCE_SHA"

# --- Bootstrap fallback for --changed and delta -----------------------------
# If gh-pages doesn't exist on the remote, no incremental story is possible —
# fall back to --full so the first deploy bootstraps cleanly.
if [ "$MODE" != "full" ]; then
  if ! git ls-remote --exit-code --heads "$REPO" "$BRANCH" >/dev/null 2>&1; then
    echo "note: '$BRANCH' not found on remote — falling back to --full for first deploy."
    MODE="full"
  fi
fi

# --- Helper: extract Source-SHA from gh-pages HEAD commit message -----------
read_last_source_sha() {
  local tmp="$1"
  git -C "$tmp" log -1 --pretty=%B | sed -n 's/^Source-SHA:[[:space:]]*\([0-9a-f]\{7,\}\).*$/\1/p' | head -1
}

# --- Files that force a full re-render even in --changed mode ---------------
is_global_file() {
  case "$1" in
    styles/*|_quarto.yml|_curriculum.yml|assets/*|widgets/*) return 0 ;;
    *) return 1 ;;
  esac
}

# --- --changed planning -----------------------------------------------------
# Decide whether --changed can actually skip work. If anything looks off we
# downgrade to a normal delta deploy (full render + delta push).
CHANGED_QMDS=""
if [ "$MODE" = "changed" ]; then
  TMP_PEEK="$(mktemp -d)"
  git clone --quiet --branch "$BRANCH" --single-branch --depth 1 "$REPO" "$TMP_PEEK/repo" || {
    echo "warn: couldn't fetch '$BRANCH' to read last Source-SHA — downgrading to full render."
    MODE="delta"
  }

  if [ "$MODE" = "changed" ]; then
    LAST_SHA="$(read_last_source_sha "$TMP_PEEK/repo")"
    if [ -z "$LAST_SHA" ]; then
      echo "warn: no Source-SHA trailer on last gh-pages commit — downgrading to full render."
      MODE="delta"
    elif ! git cat-file -e "$LAST_SHA" 2>/dev/null; then
      echo "warn: last Source-SHA $LAST_SHA not found locally (try 'git fetch --all') — downgrading to full render."
      MODE="delta"
    else
      echo "Last deploy was from: $LAST_SHA"
      # Look for any global-trigger file in the diff range.
      GLOBAL_HIT=""
      while IFS= read -r f; do
        if is_global_file "$f"; then GLOBAL_HIT="$f"; break; fi
      done < <(git diff --name-only "$LAST_SHA" "$SOURCE_SHA")
      if [ -n "$GLOBAL_HIT" ]; then
        echo "note: global file changed since last deploy ($GLOBAL_HIT) — full re-render required."
        MODE="delta"
      else
        # Collect changed .qmd files only.
        CHANGED_QMDS="$(git diff --name-only "$LAST_SHA" "$SOURCE_SHA" -- '*.qmd' | tr '\n' ' ')"
        if [ -z "${CHANGED_QMDS// }" ]; then
          echo "Nothing to deploy: no .qmd files changed since $LAST_SHA."
          rm -rf "$TMP_PEEK"
          exit 0
        fi
        echo "Will render only:"
        for f in $CHANGED_QMDS; do echo "  - $f"; done
      fi
    fi
  fi
  rm -rf "$TMP_PEEK"
fi

# --- Render -----------------------------------------------------------------
if [ "$MODE" = "changed" ]; then
  # Clone gh-pages into _site FIRST so we keep all previously-deployed HTML.
  # Per-file `quarto render` then overwrites just the changed pages.
  rm -rf "$DIST_DIR"
  TMP_CLONE="$(mktemp -d)"
  trap 'rm -rf "$TMP_CLONE"' EXIT
  git clone --quiet --branch "$BRANCH" --single-branch --depth 1 "$REPO" "$TMP_CLONE/repo"
  mv "$TMP_CLONE/repo" "$DIST_DIR.tmp"
  mv "$DIST_DIR.tmp/.git" "$DIST_DIR.tmp/.git_pending"
  mv "$DIST_DIR.tmp" "$DIST_DIR"
  mv "$DIST_DIR/.git_pending" "$DIST_DIR/.git"

  echo "=== Rendering changed files ==="
  for f in $CHANGED_QMDS; do
    if [ -f "$f" ]; then
      echo "--- $f"
      quarto render "$f"
    else
      # File was deleted in the source — drop the corresponding HTML too.
      html="$DIST_DIR/${f%.qmd}.html"
      if [ -f "$html" ]; then
        echo "--- removing $html (source deleted)"
        rm -f "$html"
      fi
    fi
  done
else
  echo "=== Rendering Quarto site (full) ==="
  quarto render
fi

if [ ! -d "$DIST_DIR" ]; then
  echo "error: $DIST_DIR not found after render." >&2
  exit 1
fi

touch "$DIST_DIR/.nojekyll"

# --- Push -------------------------------------------------------------------
if [ "$MODE" = "full" ]; then
  rm -rf "$DIST_DIR/.git"
  echo "=== Preparing full (force-push) deployment ==="
  cd "$DIST_DIR"
  git init -q
  git checkout -q -b "$BRANCH"
  git add -A
  git commit -q -m "Deploy: $(date -u +%Y-%m-%dT%H:%M:%SZ)

Source-SHA: $SOURCE_SHA"
  echo "=== Pushing (force) to $BRANCH ==="
  git push -f "$REPO" "$BRANCH"
  cd ..

elif [ "$MODE" = "delta" ]; then
  rm -rf "$DIST_DIR/.git"
  echo "=== Preparing delta deployment ==="
  TMP_CLONE="$(mktemp -d)"
  trap 'rm -rf "$TMP_CLONE"' EXIT
  git clone --quiet --branch "$BRANCH" --single-branch --depth 1 "$REPO" "$TMP_CLONE/repo"
  mv "$TMP_CLONE/repo/.git" "$DIST_DIR/.git"

  cd "$DIST_DIR"
  git add -A
  if git diff --cached --quiet; then
    echo "No changes since last deploy — nothing to push."
    cd ..
    rm -rf "$DIST_DIR/.git"
    exit 0
  fi
  git commit -q -m "Deploy: $(date -u +%Y-%m-%dT%H:%M:%SZ)

Source-SHA: $SOURCE_SHA"
  echo "=== Pushing delta to $BRANCH ==="
  git push "$REPO" "HEAD:$BRANCH"
  cd ..

else  # changed
  echo "=== Preparing --changed deployment ==="
  cd "$DIST_DIR"
  git add -A
  if git diff --cached --quiet; then
    echo "Per-file render produced no changes vs. last deploy — nothing to push."
    cd ..
    rm -rf "$DIST_DIR/.git"
    exit 0
  fi
  git commit -q -m "Deploy (changed): $(date -u +%Y-%m-%dT%H:%M:%SZ)

Source-SHA: $SOURCE_SHA"
  echo "=== Pushing changed delta to $BRANCH ==="
  git push "$REPO" "HEAD:$BRANCH"
  cd ..
fi

rm -rf "$DIST_DIR/.git"

echo ""
echo "=== Deployed! ==="
echo "1. Go to https://github.com/rajeshpillai/applied-maths/settings/pages"
echo "2. Set Source: Deploy from a branch → $BRANCH → / (root)"
echo "3. Site will be live at: https://rajeshpillai.github.io/applied-maths/"
