#!/bin/bash

##  argument validation
# make sure correct number of arguments were passed
if [ $# -eq 0 ] || [ $# -gt 1 ]; then
    echo "Usage: publish <tag>"
    exit
fi

# check first argument (tag name) is valid - v#.#.#
if ! [[ "$1" =~ ^(v[1-9][0-9]{0,2})(\.[0-9]{1,3}){2,3}$ ]]; then
    echo "Invalid tag name"
    exit
fi

retail="$1-retail"
classic="$1-classic"
bcc="$1-bcc"

## Check tag can be published
echo "Checking for local tag existence"

result=$(($(git tag -l | grep -cx "$retail")+$(git tag -l | grep -cx "$classic")+$(git tag -l | grep -cx "$bcc")))

if [ $result -gt 0 ]; then
    echo "Tag already exists locally"
    exit
fi

echo "Checking for remote tag existence"

result=$(($(curl -s "https://api.github.com/repos/brodyreeves/PartyMarker/tags" | grep -Po '"name":.*?[^\\]",' | grep -cP "\"$retail\"")+$(curl -s "https://api.github.com/repos/brodyreeves/PartyMarker/tags" | grep -Po '"name":.*?[^\\]",' | grep -cP "\"$classic\"")+$(curl -s "https://api.github.com/repos/brodyreeves/PartyMarker/tags" | grep -Po '"name":.*?[^\\]",' | grep -cP "\"$bcc\"")))

if [ $result -gt 0 ]; then
    echo "Tag already exists on remote"
    exit
fi

echo "Publishing retail as '$retail'"
git tag $retail
git push origin $retail

echo "Publishing classic as '$classic'"
git tag $classic
git push origin $classic

echo "Publishing bcc as '$bcc'"
git tag $bcc
git push origin $bcc

echo "Done"
