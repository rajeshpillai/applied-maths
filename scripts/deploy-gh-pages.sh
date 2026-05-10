#!/bin/bash
# Deploy the rendered Quarto site to GitHub Pages.
#
# Usage:
#   ./scripts/deploy-gh-pages.sh           # delta deploy (default, fast)
#   ./scripts/deploy-gh-pages.sh --full    # full reset: wipe gh-pages history and force-push
#
# Delta mode shallow-clones the existing gh-pages branch into _site/.git, lets
# Quarto render on top, then commits & pushes only what changed. Git transfers
# only the changed objects, so deploys after the first one are quick.
#
# Full mode is the original behavior: `git init` a fresh history in _site/ and
# force-push it to gh-pages. Use it when gh-pages history is corrupted, when
# you want to reclaim space, or for the very first deploy of a new repo.
#
# The push URL is inherited from the parent repo's `origin` remote so whichever
# auth (SSH or HTTPS credential helper) you already have set up for normal
# pushes is reused. Override by exporting DEPLOY_REPO.

set -e

MODE="delta"
case "${1:-}" in
  --full) MODE="full" ;;
  "")     ;;
  *)      echo "error: unknown flag '$1' (expected --full or no flag)" >&2; exit 2 ;;
esac

REPO="${DEPLOY_REPO:-$(git remote get-url origin)}"
DIST_DIR="_site"
BRANCH="gh-pages"

if [ -z "$REPO" ]; then
  echo "error: could not determine push URL — set DEPLOY_REPO or add an 'origin' remote." >&2
  exit 1
fi
echo "Pushing to: $REPO  (mode: $MODE)"

echo "=== Rendering Quarto site ==="
quarto render

if [ ! -d "$DIST_DIR" ]; then
  echo "error: $DIST_DIR not found after render." >&2
  exit 1
fi

# Tell GitHub Pages not to run Jekyll (it would otherwise drop _-prefixed dirs).
touch "$DIST_DIR/.nojekyll"

# Always start with no leftover .git inside _site, then re-attach as needed.
rm -rf "$DIST_DIR/.git"

# If the user asked for delta but gh-pages doesn't exist on the remote yet,
# fall back to full so the first deploy bootstraps cleanly.
if [ "$MODE" = "delta" ]; then
  if ! git ls-remote --exit-code --heads "$REPO" "$BRANCH" >/dev/null 2>&1; then
    echo "note: '$BRANCH' not found on remote — falling back to --full for first deploy."
    MODE="full"
  fi
fi

if [ "$MODE" = "full" ]; then
  echo "=== Preparing full (force-push) deployment ==="
  cd "$DIST_DIR"
  git init -q
  git checkout -q -b "$BRANCH"
  git add -A
  git commit -q -m "Deploy to GitHub Pages"
  echo "=== Pushing (force) to $BRANCH ==="
  git push -f "$REPO" "$BRANCH"
  cd ..
else
  echo "=== Preparing delta deployment ==="
  # Shallow-clone gh-pages into a tmpdir, then move its .git on top of the
  # freshly-rendered _site/. Git will see the rendered tree as the working
  # copy and diff it against gh-pages HEAD.
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
  git commit -q -m "Deploy: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "=== Pushing delta to $BRANCH ==="
  git push "$REPO" "HEAD:$BRANCH"
  cd ..
fi

rm -rf "$DIST_DIR/.git"

echo ""
echo "=== Deployed! ==="
echo "1. Go to https://github.com/rajeshpillai/applied-maths/settings/pages"
echo "2. Set Source: Deploy from a branch → $BRANCH → / (root)"
echo "3. Site will be live at: https://rajeshpillai.github.io/applied-maths/"
