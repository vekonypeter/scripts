#!/bin/bash

if [ "$1" == "-h" ] || [ "$1" == "--help" ]
then
    echo "dgb: delete all local git branches that lost their remote tracking counterparts"
    exit 1
fi

branchnames=($(git branch -v | grep '\[gone\]' | awk '{print $1}'))
count=${#branchnames[@]}

if (( count < 1 )); then
    echo "No 'gone' branch found"
    exit 0;
fi

echo "The following $count branch(es) lost their remote-tracking pair:"

for branchname in "${branchnames[@]}"
do
    echo " - $branchname"
done

read -p "Do you want to delete them? (Y/N) " deleteBranches

if [ "$deleteBranches" == "Y" ] || [ "$deleteBranches" == "y" ]
then
    function join_by { local IFS="$1"; shift; echo "$*"; }
    cmd="git branch -D `join_by " " "${branchnames[@]}"`"
    echo "Running command: '$cmd'"
    eval $cmd
    echo "Done"
else
    echo "Skipped"
fi