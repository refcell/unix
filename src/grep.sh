#! /bin/bash

data=$(grep $@)
cast abi-encode "response(uint256,string)" "1" "$data"
