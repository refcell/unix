#! /bin/bash

# We can just encode the input directly
cast abi-encode "response(uint256,string)" "1" "$(pwd)"