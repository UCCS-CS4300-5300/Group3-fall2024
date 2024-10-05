#!/bin/bash

# Find the virtual environment
venv=$(find ~ -wholename "*/Group3*/activate" 2>/dev/null)
if [ -z "$venv" ]; then
    echo "Virtual environment not found."
    exit 1
fi

# Source the virtual environment

# Find requirements.txt and take the first result
requirements=$(find ~ -wholename "*requirements.txt" 2>/dev/null | head -n 1)
if [ -z "$requirements" ]; then
    echo "requirements.txt not found."
    exit 1
fi

# Upgrade pip and clean cache
pip3 install --upgrade pip
pip3 cache purge

# Print the requirements file path
echo
echo "Using requirements file: ${requirements}"
echo
# Install packages from requirements.txt
pip3 install -r "${requirements}"

# Find manage.py
manage=$(find ~ -wholename "*Group3*/manage.py" 2>/dev/null)
if [ -z "$manage" ]; then
    echo "manage.py not found."
    exit 1
fi

echo
echo $manage
echo
# Print success message
source "$venv"
echo "Virtual environment activated."

# Set Git remotes
echo "Setting remotes..."
git remote set-url origin https://github.com/Ditmanson/CS4300
git remote set-url secondary https://github.com/UCCS-CS4300-5300/Group3-fall2024.git
echo
echo "Remotes set:"
git remote -v

python3 $manage runserver 0.0.0.0:3000
