#!/bin/bash

# Usage:
#   ./obsidian_assets_clean.sh rootDir assetsDir tmpDir
# Delete all obsidian assets which are not referenced anymore.
# Moves all referenced assets to `tmpDir` and then replaces
# `assetsDir` with `tmpDir`.

(( "$#" != 3 )) && echo "Usage: ./obsidian_assets_clean.sh rootDir assetsDir tmpDir" && exit 1

# Usage:
#   parseDirs rootDir assetsDir tmpDir
# Parses all files for ![[fname]] or ![[fname|size]] pattersn
# and copies all files with `fname` in `assetsDir` to `tmpDir`.
function parseDirs
{
    assets="$2"
    tmp="$3"

    IFSBACK=$IFS
    IFS=$'\n'
    matches="$(grep -roG '!\[\[[^][!]*\]\]' "$1")"
    for l in $matches; do
        IFS=':'
        arr=($l)

        [[ "${arr[0]}" == "$assets"* ]] && echo "Skipping ${arr[0]}..." && continue

        file="${arr[1]:3:-2}"
        file="${file//?('\')'|'+([0123456789])/}"

        [[ -f "$tmp/$file" ]] && continue
        echo "Found '$file' in '${arr[0]}'"
        cp "$assets/$file" "$tmp/$file"
    done

    IFS=$IFSBACK
}

tmp="$3"
assets="$2"

[[ -d "$tmp" ]] || echo "Creating dump directory: $tmp"
mkdir -p "$tmp"
shopt -qs extglob
parseDirs "$@"
rm -r "$assets"
mv "$tmp" "$assets"