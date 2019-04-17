#!/bin/sh
# parameter 1 (optional): git hooks directory
# example: ./entrypoint.sh "../.git/hooks"
# parameter 2 (optional): hooks to enable
# example: ./entrypoint.sh "../.git/hooks" "update,commit-msg"
{
set -e
    # default location
    configLocation="$PWD/.hooks/"
    configSet=false;

    while getopts "c:" opt; do
        case $opt in
            c | config ) configSet=true; configLocation=$OPTARG;;
            \? ) echo "Unknown option: -$OPTARG" >&2; exit 127;;
             : ) echo "Missing option argument for -$OPTARG" >&2; exit 127;;
             * ) echo "Invalid option -$OPTARG" >&2; exit 127;;
        esac
    done

    if $configSet
    then
        echo -n "Set GitHook location: [$configLocation]\n";
        $(git config --local core.hooksPath "$configLocation") || { echo -n "Status: Failed.\n"; exit 127; }
        echo -n "Status: Success.\n";
        exit 0;
    fi

    #
    # allow for default param: 1, but keep params 2-n
    #if [ "$1" = "config-set" ] && [ ! -n "$2" ]; then
    #    $(git config --local core.hooksPath "$2" || echo "Error setting git config. Error: $!"; exit 1);
    #else
    #    echo "Missing directory location for second parameter.";
    #    exit 127;
    #fi
    githooks=$(git config --get core.hooksPath);
    # make sure .git exists
    if [ ! -d "$githooks" ]; then
        echo "Unable to find git hooks directory. (Provided: $githooks)";
        exit 127;
    fi
    GHD=$(git config --get core.hooksPath);
    EXT=".hook.sh";
    STR="$GHD*$EXT";
    echo "Looking in: $STR";
    for f in $STR; do
        newfilen=${f%%$EXT};
        header="##\n## This file is generated automatically. Do not update this file directly. \n## Original file: $f\n##\n"
        $(touch "$newfilen" \
            && echo "$header" > "$newfilen" \
            && $(cat $f >> $newfilen)\
        ) \
        || echo "New file Error: $!"; exit 1;
    done
} || echo "Something went wrong. Error: $!"; exit 1;