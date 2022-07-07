#! /bin/bash

# Grab the file name
filename=$(echo "$@" | sed 's|.*/||')

# Delete the file
if [ -f "$filename" ] ; then
    rm "$filename"
fi
