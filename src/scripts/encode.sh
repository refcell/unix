#! /bin/bash

cast abi-encode "$1" "$(${@: 2})"
