#! /bin/bash

# If the file exists, delete it
if [ -f "$@" ] ; then
    rm "$@"
    cast abi-encode "response(uint256,string)" "1" "$@"
else
    cast abi-encode "response(uint256,string)" "0" "FILE_NOT_FOUND"
fi
