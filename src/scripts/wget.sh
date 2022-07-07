#! /bin/bash

# Download the file
response=$(wget -q "$@")

# Get the filename
filename=$(echo "$@" | sed 's|.*/||')

# Remove newline chars
filename=$(echo "$filename" | tr -d '\n')

# Grab the response
http_code=$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' "$@")

# Encode the response data
cast abi-encode "response(uint256,string)" "$http_code" "$filename"
