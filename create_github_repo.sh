#!/usr/bin/env bash
# create_github_repo.sh
# Creates a public GitHub repository named "mqtt-hvac-control" and pushes
# the local project files.
#
# Prerequisites:
#   - git installed
#   - GitHub CLI (gh) installed and authenticated  OR  a GITHUB_TOKEN env var
#
# Usage:
#   bash create_github_repo.sh

set -euo pipefail

REPO_NAME="mqtt-hvac-control"
REPO_DESC="MQTT-based HVAC control — YAML configuration, automations, and topic definitions"
VISIBILITY="public"

echo "══════════════════════════════════════════════"
echo " Creating GitHub repository: ${REPO_NAME}"
echo "══════════════════════════════════════════════"

# ── Option A: GitHub CLI (recommended) ────────────────────────────────────
if command -v gh &>/dev/null; then
  echo "Using GitHub CLI (gh)..."
  gh repo create "$REPO_NAME" \
    --description "$REPO_DESC" \
    --"$VISIBILITY" \
    --source=. \
    --remote=origin \
    --push
  echo ""
  echo "✓ Repository created and pushed:"
  gh repo view "$REPO_NAME" --json url -q .url

# ── Option B: GitHub REST API via curl ────────────────────────────────────
elif [[ -n "${GITHUB_TOKEN:-}" ]]; then
  echo "Using GITHUB_TOKEN via curl..."

  # Get authenticated username
  USERNAME=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" \
    https://api.github.com/user | grep '"login"' | head -1 | cut -d'"' -f4)

  # Create the repo
  curl -s -X POST \
    -H "Authorization: token ${GITHUB_TOKEN}" \
    -H "Accept: application/vnd.github.v3+json" \
    https://api.github.com/user/repos \
    -d "{
      \"name\": \"${REPO_NAME}\",
      \"description\": \"${REPO_DESC}\",
      \"private\": false,
      \"auto_init\": false
    }" | grep '"html_url"' | head -1

  # Init and push
  git init
  git add -A
  git commit -m "Initial commit: MQTT HVAC control configuration"
  git branch -M main
  git remote add origin "https://${GITHUB_TOKEN}@github.com/${USERNAME}/${REPO_NAME}.git"
  git push -u origin main

  echo "✓ Pushed to https://github.com/${USERNAME}/${REPO_NAME}"

else
  echo "ERROR: Neither 'gh' CLI nor GITHUB_TOKEN found."
  echo ""
  echo "Please do one of:"
  echo "  1) Install GitHub CLI:  https://cli.github.com/  then run 'gh auth login'"
  echo "  2) Set GITHUB_TOKEN=<your_personal_access_token> and re-run this script"
  exit 1
fi
