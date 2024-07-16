#!/bin/bash

# Define the path to the .gitignore file and the output exclude file
GITIGNORE_FILE="${PWD}/.gitignore"
EXCLUDE_FILE="${PWD}/.env/rsync_exclude"

# Create the .env directory if it doesn't exist
mkdir -p "${PWD}/.env"

# Read the .gitignore file and convert it to rsync exclude format
if [ -f "$GITIGNORE_FILE" ]; then
    # Add additional excludes if needed
    echo ".git" > "$EXCLUDE_FILE"
    echo ".env" >> "$EXCLUDE_FILE"
    cat "$GITIGNORE_FILE" >> "$EXCLUDE_FILE"
else
    echo ".git" > "$EXCLUDE_FILE"
    echo ".env" >> "$EXCLUDE_FILE"
fi