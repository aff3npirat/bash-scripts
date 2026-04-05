#!/bin/bash

# Usage: mcdir [OPTION]... DIRECTORY...
function mcdir
{
    mkdir $@ && cd $_
}
