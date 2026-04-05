#!/bin/bash

# Usage:
#   mkmv SOURCE DESTINATION
#   mkmv -t DESTINATION SOURCE...
function mkmv
{
    mv $@
    ret=$?
    # if mv succeeded return
    (( ! $ret )) && return $ret
    
    # if -t specified -> mkdir -pv $dest
    # if not -> 
    # src is dir -> mkdir -pv $dest
    # src is file ->
    #     dest ends with / -> mkdir -pv $dest
    #     dest no trailing / -> mkdir -pv dirname $dest

    args=("$@"); i=0
    for (( i=0; $i < ${#}-2; i++ )); do
        [[ ${args[i] == "-t"} || ${args[i]:0:1} != "-" ]] && break
    done

    dest=${args[i+1]}
    # if dest already exists, mkdir wont fix
    [[ -e $dest ]] && return $ret
    [[ -f ${args[i]} && ${dest: -1} != "/" ]] && dest="$(dirname $dest)"
    mkdir -pv $dest

    mv $@
    return $?
}
