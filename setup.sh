#!/bin/bash

# Find the virtual environment
venv=$(find ~ -wholename "*/Group3*/activate" 2>/dev/null)
# Check if the virtual environment was found
if [ -z "$venv" ]; then
    python3 -m venv venv
    source venv/bin/activate
fi

# Find requirements.txt
requirements=$(find ~ -wholename "*requirements.txt" | head -n 1)
if [ -z "$requirements" ]; then
    echo "requirements.txt not found."
    exit 1
fi

source "$venv"

# Pip installs
pip3 install --upgrade pip
pip3 cache purge
echo "Using requirements file: ${requirements}"
pip3 install -r "${requirements}"

# Find manage.py
manage=$(find ~ -wholename "*/manage*" 2> /dev/null)
if [ -z "$manage" ]; then
    echo "manage.py not found"
    exit 1
fi

echo "Found virtual environment at: $venv"
# Source the virtual environment
source "$venv"
# Print success message
echo "Virtual environment activated."

# Setting remotes
git remote set-url origin https://github.com/Ditmanson/CS4300
git remote set-url secondary https://github.com/UCCS-CS4300-5300/Group3-fall2024.git
echo "Remotes set:"
git remote -v

function run {
    manage=$(find ~ -wholename "*Group3*/manage.py" 2>/dev/null)
if [ -z "$manage" ]; then
    echo "manage.py not found."
    exit 1
fi
python3 $manage runserver 0.0.0.0:3000
}
function push {
    local commitMessage="$1"  # Use local variable for the commit message

    # Check if a commit message was provided
    if [[ -z "$commitMessage" ]]; then
        echo "Error: No commit message provided."
        echo "Please provide a commit message using quotes, e.g., 'git_push_with_message \"Your commit message\"'"
        return 1
    fi

    echo "Your commit message: ${commitMessage}"

    # Get the current branch name
    local current
    current=$(git branch --show-current)

    # Add all changes
    git add -A

    # Commit the changes
    git commit -m "$commitMessage"
    
    # Fetch and rebase
    git fetch origin
    git rebase origin

    # Push to both remotes
    git push -u origin "${current}"
    git push -u secondary "${current}"

    echo "Proceed to GitHub to create pull requests."
}

