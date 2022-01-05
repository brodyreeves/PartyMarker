#!/bin/bash

addon=PartyMarker

if [ $# -gt 1 ]; then
    echo "Usage: test [retail|classic|bcc]"
    exit
fi

if [ $# -eq 0 ]; then
    version=_retail_
elif [ $1 = "retail" ]; then
    version=_retail_
elif [ $1 = "classic" ]; then
    version=_classic_era_
elif [ $1 = "bcc" ]; then
    version=_classic_
else
    echo "Usage: test [retail|classic|bcc]"
    exit
fi

# copy files with code changes
dest="/c/Program Files (x86)/Games/Blizzard/World of Warcraft/$version/Interface/AddOns/$addon"

# PartyMarker.lua
cp -u -v "./PartyMarker.lua" "$dest"

echo "Done"
