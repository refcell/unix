#! /bin/bash

cast abi-encode "response(uint256,string)" "1" "$($@)"
