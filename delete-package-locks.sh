#!/bin/sh

cmd="find . ! -path *node_modules* -name package-lock.json"
eval $cmd

read -p 'Do you want to delete them? (Y/N) ' deleteFiles

if [ "$deleteFiles" == "Y" ] || [ "$deleteFiles" == "y" ]
then
    eval $cmd + " -delete"
    echo "Deleted!"
fi