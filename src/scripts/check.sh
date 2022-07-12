#! /bin/bash

# If the file exists, return 01 otherwise return 00
if [ -f "$@" ] ; then
    echo -n 01
else
    echo -n 00
fi

