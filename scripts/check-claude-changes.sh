#!/usr/bin/env zsh

# Check for uncommitted changes in Claude configuration files
# This script is designed to run on shell init to prompt for commits

# Exit if not in an interactive shell
[[ -o interactive ]] || exit 0

# Claude config directory
CLAUDE_DIR="$HOME/.claude"

# Exit if .claude directory doesn't exist
[[ -d "$CLAUDE_DIR" ]] || exit 0

# Exit silently if not a git repository
git -C "$CLAUDE_DIR" rev-parse --git-dir >/dev/null 2>&1 || exit 0

# Files/directories to track
TRACKED_FILES=(
    "CLAUDE.md"
    "plugins"
    "skills"
    "settings.json"
)

# Check if any tracked files have changes
# Use git diff to check both staged and unstaged changes
if git -C "$CLAUDE_DIR" diff --quiet HEAD -- "${TRACKED_FILES[@]}" 2>/dev/null && \
   git -C "$CLAUDE_DIR" diff --quiet --cached HEAD -- "${TRACKED_FILES[@]}" 2>/dev/null; then
    # No changes detected
    exit 0
fi

# Check for merge conflicts
if git -C "$CLAUDE_DIR" diff --name-only --diff-filter=U | grep -q .; then
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
git -C "$CLAUDE_DIR" status --short -- "${TRACKED_FILES[@]}"
echo ""

# Show full diff
echo "Changes:"
echo "────────────────────────────────────────────────────────────────────"
git -C "$CLAUDE_DIR" diff HEAD -- "${TRACKED_FILES[@]}"
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
git -C "$CLAUDE_DIR" add "${TRACKED_FILES[@]}" 2>/dev/null

# Create the commit
if git -C "$CLAUDE_DIR" commit -m "$commit_message" >/dev/null 2>&1; then
    echo "✅ Changes committed successfully!"

    # Push to remote
    echo "Pushing to remote..."
    if git -C "$CLAUDE_DIR" push 2>&1; then
        echo "✅ Changes pushed successfully!"
    else
        echo "⚠️  Push failed. You may need to push manually later."
        echo "    Run: git -C ~/.claude push"
    fi
else
    echo "❌ Commit failed. Check git status for details."
    exit 1
fi

echo ""
