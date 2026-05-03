#!/bin/bash
# Deploy the rendered Quarto site to GitHub Pages.
# Usage: ./scripts/deploy-gh-pages.sh
#
# The push URL is inherited from the parent repo's `origin` remote so
# whichever auth (SSH or HTTPS credential helper) you already have set
# up for normal pushes is reused. Override by exporting DEPLOY_REPO.

set -e

REPO="${DEPLOY_REPO:-$(git remote get-url origin)}"
DIST_DIR="_site"

if [ -z "$REPO" ]; then
  echo "error: could not determine push URL — set DEPLOY_REPO or add an 'origin' remote." >&2
  exit 1
fi
echo "Pushing to: $REPO"

echo "=== Rendering Quarto site ==="
quarto render

if [ ! -d "$DIST_DIR" ]; then
  echo "error: $DIST_DIR not found after render." >&2
  exit 1
fi

echo "=== Preparing deployment ==="
cd "$DIST_DIR"

# Tell GitHub Pages not to run Jekyll (it would otherwise drop _-prefixed dirs).
touch .nojekyll

git init -q
git checkout -q -b gh-pages
git add -A
git commit -q -m "Deploy to GitHub Pages"

echo "=== Pushing to gh-pages branch ==="
git push -f "$REPO" gh-pages

cd ..
rm -rf "$DIST_DIR/.git"

echo ""
echo "=== Deployed! ==="
echo "1. Go to https://github.com/rajeshpillai/applied-maths/settings/pages"
echo "2. Set Source: Deploy from a branch → gh-pages → / (root)"
echo "3. Site will be live at: https://rajeshpillai.github.io/applied-maths/"
