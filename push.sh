#!/bin/bash

# Check if a commit message was provided
if [[ -z "$1" ]]; then
    echo "Error: No commit message provided."
    echo "Please provide a commit message using quotes, e.g., './push.sh \"Your commit message\"'"
    exit 1
fi

commitMessage="$1"  # Use double quotes for the commit message
echo "Your commit message: ${commitMessage}"

# Get the current branch name
current=$(git branch --show-current)

# Add all changes
git add -A

# Commit the changes
git commit -m "$commitMessage"
git fetch origin
git rebase origin

# Push to both remotes
git push -u origin "${current}" -f
git push -u secondary "${current}" -f

echo "Proceed to GitHub to create pull requests."
