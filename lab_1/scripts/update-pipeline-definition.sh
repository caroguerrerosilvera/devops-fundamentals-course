#!/bin/bash

# Checking if JQ is installed
if ! command -v jq &> /dev/null; then
    echo "JQ is not installed. Please install it before running this script."
    echo "For Ubuntu, you can install it using: sudo apt-get install jq"
    echo "For macOS, you can install it using: brew install jq"
    echo "On Windows using Chocolatey: choco install jq"
    exit 1
fi

# Checking if pipeline definition path is provided
if [ -z "$1" ]; then
    echo "Please provide the path to the pipeline definition JSON file."
    exit 1
fi

# Checking if necessary properties are present in the JSON definition
if ! jq '.pipeline.version and .pipeline.stages[].actions[].configuration.Branch and .pipeline.stages[].actions[].configuration.Owner' "$1" > /dev/null 2>&1; then
    echo "The pipeline definition JSON file is missing some necessary properties."
    exit 1
fi

# Setting default values for parameters
file=$1
branch="main"
owner=""
poll_for_source_changes=false

# Parsing command line arguments
while [[ $# -gt 1 ]]; do
    key="$1"
    case $key in
        --configuration)
        configuration="$2"
        shift
        ;;
        --owner)
        owner="$2"
        shift
        ;;
        --branch)
        branch="$2"
        shift
        ;;
        --poll-for-source-changes)
        poll_for_source_changes="$2"
        shift
        ;;
    esac
    shift
done

pipeline=$(cat "$file")

# Removing the metadata property
pipeline=$(echo "$pipeline" | jq 'del(.metadata)')

# Incrementing the pipeline version property by 1
pipeline=$(echo "$pipeline" | jq '.pipeline.version += 1')

# Setting the Branch, Owner, and PollForSourceChanges properties
pipeline=$(echo "$pipeline" | jq --arg branch "$branch" '.pipeline.stages[0].actions[0].configuration.Branch = $branch')
pipeline=$(echo "$pipeline" | jq --arg owner "$owner" '.pipeline.stages[0].actions[0].configuration.Owner = $owner')
pipeline=$(echo "$pipeline" | jq --argjson poll_for_source_changes "$poll_for_source_changes" '.pipeline.stages[0].actions[0].configuration.PollForSourceChanges = $poll_for_source_changes')

pipeline=$(echo "$pipeline" | jq --arg configuration "$configuration" 'walk(
    if type == "object" and has("EnvironmentVariables") then
        .EnvironmentVariables |= (fromjson | map(
            if has("value") then
                .value = $configuration
            else
                .
            end
        ))
    else
        .
    end
)')


# Save the updated JSON to the pipeline.json file
echo "$pipeline" > pipeline-$(date +"%Y-%m-%d").json

