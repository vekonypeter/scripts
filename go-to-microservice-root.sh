#!/bin/bash

function msetver {
    mvn versions:set -DnewVersion=$1 && mvn versions:commit
}