#!/bin/bash

if [[ $# -eq 0 ]]; then
  echo "Please provide at least one directory as an argument"
  exit 1
fi

for dir in "$@"; do
  if [[ ! -d $dir ]]; then
    echo "$dir is not a directory"
    continue
  fi

  file_count=$(find "$dir" -type f | wc -l)

  echo "Number of files in $dir and its subdirectories: $file_count"
done
