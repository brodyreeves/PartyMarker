#!/bin/bash

##  argument validation
# make sure correct number of arguments were passed
if [ $# -eq 0 ] || [ $# -gt 1 ]; then
    echo "Usage: publish <tag>"
    exit
fi

# check first argument (tag name) is valid - v#.#.#
if ! [[ "$1" =~ ^(v[1-9][0-9]{0,2})(\.[0-9]{1,3}){2,3}$ ]]; then
    echo "Error: Invalid tag name"
    exit
fi

# retail="$1-retail"
classic="$1-classic"
bcc="$1-bcc"

echo

## Check tags do not exist on local
# echo "Checking for local tag existence: $retail"
# if [ $(git tag -l | grep -cx "$retail") -gt 0 ]; then
#     echo "Error: Tag already exists on local"
#     exit
# fi

echo "Checking for local tag existence: $classic"
if [ $(git tag -l | grep -cx "$classic") -gt 0 ]; then
    echo "Error: Tag already exists on local"
    exit
fi

echo "Checking for local tag existence: $bcc"
if [ $(git tag -l | grep -cx "$bcc") -gt 0 ]; then
    echo "Error: Tag already exists on local"
    exit
fi

echo

## Check tags do not exist on remote
# echo "Checking for remote tag existence: $retail"
# if [ $(curl -s "https://api.github.com/repos/brodyreeves/PartyMarker/tags" | grep -Po '"name":.*?[^\\]",' | grep -cP "\"$retail\"") -gt 0 ]; then
#     echo "Error: Tag already exists on remote"
#     exit
# fi

echo "Checking for remote tag existence: $classic"
if [ $(curl -s "https://api.github.com/repos/brodyreeves/PartyMarker/tags" | grep -Po '"name":.*?[^\\]",' | grep -cP "\"$classic\"") -gt 0 ]; then
    echo "Error: Tag already exists on remote"
    exit
fi

echo "Checking for remote tag existence: $bcc"
if [ $(curl -s "https://api.github.com/repos/brodyreeves/PartyMarker/tags" | grep -Po '"name":.*?[^\\]",' | grep -cP "\"$bcc\"") -gt 0 ]; then
    echo "Error: Tag already exists on remote"
    exit
fi

echo

# echo "Tagging: $retail"
# git tag $retail
# echo "Pushing: $retail"
# git push origin $retail

echo

echo "Tagging: $classic"
git tag $classic
echo "Pushing: $classic"
git push origin $classic

echo

echo "Tagging: $bcc"
git tag $bcc
echo "Pushing: $bcc"
git push origin $bcc

echo
echo "Done"
