#!/usr/bin/env zsh

# Check for uncommitted changes in Claude configuration files
# This script is designed to run on shell init to prompt for commits

# Exit if not in an interactive shell
[[ -o interactive ]] || exit 0

# Claude config directory
CLAUDE_DIR="$HOME/.claude"

# Exit if .claude directory doesn't exist
[[ -d "$CLAUDE_DIR" ]] || exit 0

# Change to .claude directory
cd "$CLAUDE_DIR" || exit 0

# Exit silently if not a git repository
git rev-parse --git-dir >/dev/null 2>&1 || exit 0

# Files/directories to track
TRACKED_FILES=(
    "CLAUDE.md"
    "plugins"
    "skills"
    "settings.json"
)

# Check if any tracked files have changes
# Use git diff to check both staged and unstaged changes
if git diff --quiet HEAD -- "${TRACKED_FILES[@]}" 2>/dev/null && \
   git diff --quiet --cached HEAD -- "${TRACKED_FILES[@]}" 2>/dev/null; then
    # No changes detected
    exit 0
fi

# Check for merge conflicts
if git diff --name-only --diff-filter=U | grep -q .; then
    echo "⚠️  Merge conflicts detected in .claude - resolve them first"
    exit 0
fi

# Changes detected - show them to the user
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 Uncommitted changes detected in Claude configuration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Show status summary
echo "Changed files:"
git status --short -- "${TRACKED_FILES[@]}"
echo ""

# Show full diff
echo "Changes:"
echo "────────────────────────────────────────────────────────────────────"
git diff HEAD -- "${TRACKED_FILES[@]}"
echo "────────────────────────────────────────────────────────────────────"
echo ""

# Prompt user
echo -n "Commit these changes? (y/n): "
read -r response

if [[ "$response" != "y" && "$response" != "Y" ]]; then
    echo "Skipping commit."
    exit 0
fi

# Prompt for commit message
echo ""
echo -n "Commit message: "
read -r commit_message

# Check if message is empty
if [[ -z "$commit_message" ]]; then
    echo "❌ Empty commit message - aborting."
    exit 1
fi

# Stage the tracked files that have changes
git add "${TRACKED_FILES[@]}" 2>/dev/null

# Create the commit
if git commit -m "$commit_message" >/dev/null 2>&1; then
    echo "✅ Changes committed successfully!"
else
    echo "❌ Commit failed. Check git status for details."
    exit 1
fi

echo ""
