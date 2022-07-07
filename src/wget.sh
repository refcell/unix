#! /bin/bash

response=$(wget "$@")


# echo "${response}"
# status=$(tail -n1 <<< "$response")  # get the last line
# data=$(sed '$ d' <<< "$response")   # get all but the last line which contains the status code

# # Remove newline char from data str
# data=$(echo "$data" | tr -d '\n')

# Encode the response data
cast abi-encode "response(uint256,string)" "$status" "$data"
