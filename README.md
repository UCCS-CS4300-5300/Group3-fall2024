# Mountian Lion Movie Application

### Group 3
*  **Travis** Dittmanson
*  **Nathan** Engler
*  **Ashley** Judson 
*  **Kory** Mayberry 
*  **Bob** Kroleski
*  **Garrett** Smith

### HOW TO RUN THE PROGRAM
1. `source setup.sh`
2. `run`

### A little about setup.sh
- sources your venv, assuming you named it venv
- If you don't have a venv named venv it makes one for you and sources it
- apt install jq
- pip isntalls from requirements.txt
- creates some dev tools
    - push, run, pushsh, and get_csv
#### push
push command will stage all changed files, commit them with the argument you provide, and push them to origin and secondary upstream remotes
#### pushsh
is the same as push but sets your origin and secondary remotes to ssh urls
#### run
just runs the application no matter where you are in the repo
#### get_csv
This takes 3 arguments. A start page, end page, and output file name for your csv. It then takes those and uses tmdb to access the api and create a csv file from their popular movie lists. TMDB makes their api key's paginated which allows you to choose how much to grab.