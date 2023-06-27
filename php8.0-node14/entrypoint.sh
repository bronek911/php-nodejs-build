#!/bin/bash

# run the command
args="$@"

if [ -z "${args}" ]
then
    # empty cmd
    /bin/bash --login
elif [[ ${args} =~ ^sh\ -c\  ]]
then
    # most likely gitlab runnner
    /bin/bash --login
else
    if [[ "$-" =~ i ]]
    then
        # interactive
        /bin/bash --login -i -c "${args}"
    else
        # non-interactive
        /bin/bash --login -c "${args}"
    fi
fi
