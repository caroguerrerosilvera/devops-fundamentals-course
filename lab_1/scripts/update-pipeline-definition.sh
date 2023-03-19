#!/bin/bash

# Getting flags
file=${1:-pipeline.json}
branch=${2:-main}

# Install jq if it is not already installed
if ! command -v jq > /dev/null; then
  echo "jq not found. Installing..."
  sudo apt-get install jq
fi

# Load the pipeline.json file into a variable
pipeline=$(cat "$file")

# Use jq to remove the metadata property
pipeline=$(echo "$pipeline" | jq 'del(.metadata)')

# Increment the version in 1
pipeline=$(echo "$pipeline" | jq '.pipeline.version += 1')

# Branch property in the Source action’s configuration is set as "main"
pipeline=$(echo "$pipeline" | jq --arg branch "$branch" '.pipeline.stages[0].actions[0].configuration.Branch = $branch')

# Save the updated JSON to the pipeline.json file
echo "$pipeline" > pipeline-$(date +"%Y-%m-%d").json
