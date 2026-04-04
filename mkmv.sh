#!/bin/bash

# Usage:
#   mkmv SOURCE DESTINATION
#   mkmv -t DESTINATION SOURCE...
function mkmv
{
    if [[ ( $# -ne 2 || $1 == "-t" ) && ( "$1" != "-t" || $# -lt 3 ) ]]; then
        mv "$@"
        return
    fi

    for arg in "$@"; do
        if [[ "${arg:0:1}" == "-" && "$arg" != "-t" ]]; then
            mv "$@"
            return
        fi
    done

    dir="$2"
    [ "$1" != "-t" ] && [ "${dir: -1}" != "/" ] && dir="$(dirname "$dir")"
    mkdir -p -v "$dir"

    mv "$@"
    return
}
