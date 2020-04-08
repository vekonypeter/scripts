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
    echo "Found the following package-locks:"
    echo "  ${files//[[:space:]]/\\n  }"

    read -p 'Do you want to delete them? (Y/N) ' deleteFiles

    if [ "$deleteFiles" == "Y" ] || [ "$deleteFiles" == "y" ]
    then
        `find . \! -path \*node_modules\* -name package-lock.json -delete`
        echo "Done!"
    fi
fi