#! /bin/bash

data=$(sed $@)
data=$(tail -n1 <<< "$data")
data=$(echo "$data" | tr -d '\n')
cast abi-encode "response(uint256,string)" "1" "$data"
