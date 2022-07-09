#! /bin/bash

# If the directory doesn't exist, create else return error
if [ ! -d "$@" ] ; then
    mkdir "$@"
    cast abi-encode "response(uint256,string)" "1" "$@"
else
    cast abi-encode "response(uint256,string)" "0" "DIRECTORY_EXISTS"
fi
