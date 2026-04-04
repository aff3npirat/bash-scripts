#!/bin/bash

function mcdir
{
    dir="."
    for arg in "$@"; do
        if [ "${arg:0:1}" != "-" ]; then
            dir="$arg"
            break
        fi
    done

    mkdir "$@" && cd "$dir"
    return
}
