#! /bin/bash

# Usage
# @base64 DSC_0251.JPG
# cat DSC_0251.JPG | @base64
# Base64 encoding function
@base64() {
  if [[ "${OSTYPE}" = darwin* ]]; then
    # OSX
    if [ -t 0 ]; then
      base64 "$@"
    else
      cat /dev/stdin | base64 "$@"
    fi
  else
    # Linux
    if [ -t 0 ]; then
      base64 -w 0 "$@"
    else
      cat /dev/stdin | base64 -w 0 "$@"
    fi
  fi
}

# Base64 encode the file argument
data=$(@base64 $@)

# Encode the response data
cast abi-encode "response(uint256,string)" "200" "$data"
