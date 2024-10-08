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
# install jq for get_csv function
apt install jq
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

    #set remotes
    git remote set-url origin https://github.com/Ditmanson/CS4300
    git remote set-url secondary https://github.com/UCCS-CS4300-5300/Group3-fall2024.git
    echo "Remotes set:"
    git remote -v

    # Push to both remotes
    git push -u origin "${current}"
    git push -u secondary "${current}"

    echo "Proceed to GitHub to create pull requests."
}

function pushsh {
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

     #set remotes
    git remote set-url origin git@github.com:Ditmanson/CS4300.git
    git remote set-url secondary git@github.com:UCCS-CS4300-5300/Group3-fall2024.git
    echo "Remotes set:"
    git remote -v

    # Push to both remotes
    git push -u origin "${current}"
    git push -u secondary "${current}"

    echo "Proceed to GitHub to create pull requests."
}

function get_csv {
    if [ "$#" -ne 3 ]; then
        echo "Error: You must provide exactly three arguments."
        echo "Usage: $0 <start_page> <end_page> <output_csv>"
        return 1
    fi

    # Your TMDB API key
    api="caa36da1b9fe8e132d1eca3c0d70a28c"
    
    # Get start and end pages from arguments
    start_page=$1
    end_page=$2

    # Output CSV file
    output_file=$3

    # Create CSV file and add header
    echo "id,original_language,original_title,overview,popularity,poster_path,release_date,title,video,vote_average,vote_count,adult,backdrop_path,genre_ids" > "$output_file"
    
    # Start timer
    start_time=$(date +%s)

    # Loop through the specified range of pages
    for PAGE in $(seq "$start_page" "$end_page"); do
        # Fetch the response
        RESPONSE=$(curl -s "https://api.themoviedb.org/3/movie/popular?api_key=${api}&language=en-US&page=${PAGE}")

        # Get the total number of pages from the response
        TOTAL_PAGES=$(echo "$RESPONSE" | jq '.total_pages')

        # If the total pages are less than the current page, break the loop
        if [ "$PAGE" -gt "$TOTAL_PAGES" ]; then
            echo "Fetched all available pages. Total pages: $TOTAL_PAGES"
            break
        fi

        # Convert results to CSV and append to file
        echo "$RESPONSE" | jq -r '.results[] | [.id, .original_language, .original_title, .overview, .popularity, .poster_path, .release_date, .title, .video, .vote_average, .vote_count, .adult, .backdrop_path, (.genre_ids | join(","))] | @csv' >> "$output_file"

        echo "Fetched page $PAGE of $TOTAL_PAGES"
    done

    # End timer
    end_time=$(date +%s)

    # Calculate elapsed time
    elapsed_time=$((end_time - start_time))

    # Print elapsed time
    echo "Time taken: $elapsed_time seconds"
}
