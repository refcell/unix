#! /bin/bash

data=$(sed $@)
# data=$(echo "$data" | tr -d '\n')
# data=$(tail -n1 <<< "$data")
cast abi-encode "response(uint256,string)" "1" "$data"
