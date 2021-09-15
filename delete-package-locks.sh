#!/bin/sh

if [ "$1" == "-h" ] || [ "$1" == "--help" ]
then
    echo "dpl: delete all package-lock.json files found under the current directory"
    exit 1
fi

files=`find . \! -path \*node_modules\* -name package-lock.json`

if [ -z "$files" ]
then
    echo "No package-lock.json found"
else
    echo "Deleting the following files:"
    echo "  ${files//[[:space:]]/\\n  }"

    if [ "$1" == "-f" ] || [ "$1" == "--force" ]
    then
        deleteFiles="Y"
    else
        read -p 'Are you sure? (Y/N) ' deleteFiles
    fi

    if [ "$deleteFiles" == "Y" ] || [ "$deleteFiles" == "y" ]
    then
        `find . \! -path \*node_modules\* -name package-lock.json -delete`
        echo "Done!"
    fi
fi