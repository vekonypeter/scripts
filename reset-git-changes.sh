#!/bin/sh

if [ "$1" == "-h" ] || [ "$1" == "--help" ]
then
    echo "Resets all git changes from the current directory, including staged, non-staged, and non-tracked ones"
    exit 1
fi

read -p "Are you sure you want to reset everything? (Y/N) " resetEverything

if [ "$resetEverything" == "Y" ] || [ "$resetEverything" == "y" ]
then
    eval "git reset HEAD ."
    eval "git checkout -- ."
    eval "git clean -df"
else
    echo "Skipped"
fi