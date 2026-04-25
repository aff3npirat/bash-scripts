#!/bin/bash

# Usage: ./obsidian_flat_hierarchy.sh rootDir conflictFile
(( "$#" != 2 )) && echo "Usage ./obsidian_flat_hierarchy.sh rootDir conflictFile" && exit 1

# Usage:
#   dir_to_tag dirName
# Prints tag to stdout. Non-zero exit status means no tag
# should be assigned to `dirName`.
function dir_to_tag
{
    tag="$1"

    # skip tags
    if [[ "$1" == 'Best Practices' ]]; then
        return 1
    elif [[ "$1" == 'Distributions' ]]; then
        return 1
    fi

    if [[ "$1" == 'First order logic' ]]; then
        tag='fol'
    elif [[ "$1" == 'Programming' ]]; then
        tag='coding'
    elif [[ "$1" == 'C++' ]]; then
        tag='cpp'
    elif [[ "$1" == 'Language References' ]]; then
        tag='lang-ref'
    elif [[ "$1" == 'OpenGL' ]]; then
        tag='open-gl'
    fi

    tag="$(echo $tag | tr '[:upper:]' '[:lower:]')"
    tag="${tag//' '/'-'}"
    echo "$tag"
    return 0
}

root="$1"
conflicts="$2"
files=$(find "$root" -name "*.md" -type f)

IFSBACK=$IFS
IFS=$'\n'
for file in $files; do
    IFS='/'
    dirs=(${file/$root'/'/})  # is array of dirNames

    # skip if only contains single entry (file name)
    (( "${#dirs[@]}" == 1 )) && continue
    fname="${dirs[-1]}"
    unset dirs[-1]  # remove file name from tags

    echo '' >>"$file"
    echo '' >>"$file"
    for name in "${dirs[@]}"; do
        tag="$(dir_to_tag "$name")"
        if (( $? != 0 )); then
            echo "    Skipping dir $name"
            continue
        fi

        printf "#%s " "$tag" >>"$file"  # append tag at EOF
    done

    if [[ -f "$root/$fname" ]]; then
        echo "Duplicate fname $file"
        echo "$file" >>"$conflicts"
        continue
    fi

    mv "$file" "$root/$fname"
done

IFS=$IFSBACK