#!/usr/bin/env sh

rm -f prodmonitor.zip

7z a prodmonitor.zip \
    def.json \
    LICENSE \
    skin \
    src
