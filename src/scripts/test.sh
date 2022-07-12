#! /bin/bash

echo -n $(if [[ -n $(rm  __test.txt 2>&1) ]]; then echo -n 00; else echo -n 01; fi)