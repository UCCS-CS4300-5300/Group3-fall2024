#!/bin/bash

# Find the virtual environment
venv=$(find ~ -wholename "*/Group3*/activate" 2>/dev/null)
# Check if the virtual environment was found
if [ -z "$venv" ]; then
    echo "Virtual environment not found."
    exit 1
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
