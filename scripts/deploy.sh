#!/usr/bin/env bash
# deploy.sh — Deploy a built slide HTML file to a local directory or gh-pages branch.
#
# Usage:
#   ./deploy.sh --file <path-to-slides.html> --dest <local|gh-pages>
#
# Options:
#   --file    Path to the HTML slide file to deploy (required)
#   --dest    Deployment target: "local" or "gh-pages" (required)
#   --name    Optional filename to use at the destination (default: basename of --file)
#   --help    Show this help text
#
# Targets:
#   local     Copies the file to ~/Public/slides/
#             Creates the directory if it does not exist.
#             Opens the file in the default browser after copying.
#
#   gh-pages  Commits the file to the gh-pages branch of the current git repo
#             and pushes to origin. The branch is created if it doesn't exist.
#             The file is placed in the repo root (or subdir via --name).
#
# Examples:
#   ./deploy.sh --file ./my-deck.html --dest local
#   ./deploy.sh --file ./my-deck.html --dest gh-pages
#   ./deploy.sh --file ./my-deck.html --dest gh-pages --name index.html
#
# Requirements:
#   local:    No special requirements
#   gh-pages: git, with a remote named "origin" configured

set -euo pipefail

# ── Defaults ────────────────────────────────────────────────────────────────
FILE=""
DEST=""
NAME=""
LOCAL_DIR="${HOME}/Public/slides"

# ── Usage ────────────────────────────────────────────────────────────────────
usage() {
  grep '^#' "$0" | sed 's/^# \?//' | head -30
  exit 0
}

# ── Argument parsing ─────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --file)
      FILE="$2"
      shift 2
      ;;
    --dest)
      DEST="$2"
      shift 2
      ;;
    --name)
      NAME="$2"
      shift 2
      ;;
    --help|-h)
      usage
      ;;
    *)
      echo "Unknown option: $1" >&2
      echo "Run with --help for usage." >&2
      exit 1
      ;;
  esac
done

# ── Validation ───────────────────────────────────────────────────────────────
if [[ -z "$FILE" ]]; then
  echo "Error: --file is required." >&2
  exit 1
fi

if [[ ! -f "$FILE" ]]; then
  echo "Error: File not found: $FILE" >&2
  exit 1
fi

if [[ -z "$DEST" ]]; then
  echo "Error: --dest is required. Choose 'local' or 'gh-pages'." >&2
  exit 1
fi

# Determine output filename
if [[ -z "$NAME" ]]; then
  NAME="$(basename "$FILE")"
fi

# ── Absolute path to source file ─────────────────────────────────────────────
FILE="$(cd "$(dirname "$FILE")" && pwd)/$(basename "$FILE")"

# ── Deploy: local ────────────────────────────────────────────────────────────
deploy_local() {
  echo "Deploying to local: ${LOCAL_DIR}/${NAME}"

  mkdir -p "$LOCAL_DIR"
  cp "$FILE" "${LOCAL_DIR}/${NAME}"

  echo "✔  Copied to ${LOCAL_DIR}/${NAME}"

  # Try to open in browser
  DEST_PATH="${LOCAL_DIR}/${NAME}"
  if command -v xdg-open &>/dev/null; then
    xdg-open "file://${DEST_PATH}" &
    echo "    Opened in browser via xdg-open"
  elif command -v open &>/dev/null; then
    open "file://${DEST_PATH}" &
    echo "    Opened in browser via open"
  else
    echo "    Open manually: file://${DEST_PATH}"
  fi
}

# ── Deploy: gh-pages ─────────────────────────────────────────────────────────
deploy_gh_pages() {
  echo "Deploying to gh-pages branch..."

  # Verify we're inside a git repo
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "Error: Not inside a git repository." >&2
    exit 1
  fi

  # Verify origin remote exists
  if ! git remote get-url origin &>/dev/null; then
    echo "Error: No remote named 'origin' found." >&2
    exit 1
  fi

  REPO_ROOT="$(git rev-parse --show-toplevel)"
  ORIGINAL_BRANCH="$(git symbolic-ref --short HEAD 2>/dev/null || echo 'HEAD')"
  STASH_NEEDED=false

  # Stash any uncommitted changes so we can safely switch branches
  if ! git diff --quiet HEAD 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
    echo "    Stashing uncommitted changes..."
    git stash push --quiet --include-untracked --message "deploy.sh auto-stash"
    STASH_NEEDED=true
  fi

  # Create or switch to gh-pages branch
  if git show-ref --quiet "refs/heads/gh-pages"; then
    echo "    Switching to existing gh-pages branch..."
    git checkout --quiet gh-pages
  elif git show-ref --quiet "refs/remotes/origin/gh-pages"; then
    echo "    Checking out remote gh-pages branch..."
    git checkout --quiet --track origin/gh-pages
  else
    echo "    Creating new orphan gh-pages branch..."
    git checkout --quiet --orphan gh-pages
    # Remove all tracked files from the index (orphan branch starts dirty)
    git rm -rf --quiet . 2>/dev/null || true
  fi

  # Copy the slide file
  DEST_FILE="${REPO_ROOT}/${NAME}"
  cp "$FILE" "$DEST_FILE"

  # Add a minimal index.html redirect if deploying a non-index file
  if [[ "$NAME" != "index.html" ]] && [[ ! -f "${REPO_ROOT}/index.html" ]]; then
    cat > "${REPO_ROOT}/index.html" <<INDEXEOF
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="refresh" content="0; url=./${NAME}">
  <title>Slides</title>
</head>
<body>
  <p><a href="./${NAME}">View slides</a></p>
</body>
</html>
INDEXEOF
    git add "${REPO_ROOT}/index.html"
    echo "    Created index.html redirect"
  fi

  git add "$DEST_FILE"

  COMMIT_MSG="deploy: update ${NAME} [$(date '+%Y-%m-%d %H:%M')]"
  git commit --quiet -m "$COMMIT_MSG" || {
    echo "    Nothing to commit — file is unchanged."
  }

  echo "    Pushing to origin/gh-pages..."
  git push --quiet origin gh-pages

  echo "✔  Deployed ${NAME} to gh-pages"

  # Get the GitHub Pages URL if possible
  REMOTE_URL="$(git remote get-url origin)"
  if [[ "$REMOTE_URL" =~ github\.com[:/]([^/]+)/([^/.]+) ]]; then
    GH_USER="${BASH_REMATCH[1]}"
    GH_REPO="${BASH_REMATCH[2]}"
    if [[ "$NAME" == "index.html" ]]; then
      echo "    URL: https://${GH_USER}.github.io/${GH_REPO}/"
    else
      echo "    URL: https://${GH_USER}.github.io/${GH_REPO}/${NAME}"
    fi
  fi

  # Return to original branch
  echo "    Returning to branch: ${ORIGINAL_BRANCH}"
  git checkout --quiet "$ORIGINAL_BRANCH"

  # Restore stashed changes
  if [[ "$STASH_NEEDED" == true ]]; then
    echo "    Restoring stashed changes..."
    git stash pop --quiet
  fi
}

# ── Dispatch ─────────────────────────────────────────────────────────────────
case "$DEST" in
  local)
    deploy_local
    ;;
  gh-pages)
    deploy_gh_pages
    ;;
  *)
    echo "Error: Unknown destination '${DEST}'. Use 'local' or 'gh-pages'." >&2
    exit 1
    ;;
esac

echo "Done."
