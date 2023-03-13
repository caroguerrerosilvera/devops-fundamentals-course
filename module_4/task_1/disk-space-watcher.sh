#!/bin/bash
THRESHOLD=${1:-10}
FREE_SPACE=$(df --block-size=1 / | awk 'NR==2{print $4}')
if [[ $FREE_SPACE -lt $THRESHOLD ]]
then
    echo "Warning: Free space is less than $THRESHOLD bytes"
fi