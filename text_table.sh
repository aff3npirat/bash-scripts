#!/bin/bash

# Usage: text_table start stop step cellW group cols...
function time_table
{
    function time_le
    {
        H="${1:0:2}"
        H="${H/:/}"
        M="${1: -2}"
        M="${M/:/}"
        H_="${2:0:2}"
        H_="${H_/:/}"
        M_="${2: -2}"
        M_="${M_/:/}"

        (( H < H_ )) && return 0
        (( H == H_ && M <= M_ )) && return 0
        return 1
    }

    start="$1"
    stop="$2"
    step="$3"
    cellW="$4"
    group="$5"
    offset=5
    nCols=$(($# - offset))

    colHeader=${@:offset+1}
    if [[ $cellW == "auto" ]]; then
        cellW=0
        for name in $colHeader; do
            [[ $cellW < ${#name} ]] && cellW=${#name}
        done
        cellW=$((cellW + 2))
    fi

    # print column headers
    row="| Time  |"
    for name in $colHeader; do
        pad=$(($cellW - ${#name}))
        left=$((pad / 2))
        right=$left
        (( pad%2 == 1 )) && ((right++))
        if (( left > 0 )); then
            left=$(printf ' %.0s' $(seq $left))
        else
            left=""
        fi
        if (( right > 0)); then
            right=$(printf ' %.0s' $(seq $right))
        else
            right=""
        fi
        row="$row$left$name$right|"
    done
    echo "$row"

    # create empty cell string
    cell="$(printf ' %.0s' $(seq $cellW))"

    # create seperator line
    sepCell="+$(printf -- '-%.0s' $(seq $cellW))"
    sepRow="+-------"
    for ((i=0; i < $nCols; i++)); do
        sepRow="$sepRow$sepCell"
    done
    sepRow="${sepRow}+"

    echo $sepRow

    H=${start:0:2}
    H=${H/:/}
    M=${start: -2}
    M=${M/:/}
    i=0
    while (time_le "${H}:${M}" "$stop"); do
        row="| $(printf '%02d:%02d' $H $M) |"
        for ((j=0; j < nCols; j++)); do
            row="$row$cell|"
        done

        echo "$row"

        (( group > 0 && ++i % group == 0 )) && echo $sepRow

        M=$((M + step))
        (( M < 60 )) && continue
        M=$((M - 60))
        ((H++))
    done

    return 0
}