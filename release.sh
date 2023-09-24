#! /usr/bin/env bash

set -e

UPLOADER="${UPLOADER:-../../../DesyncedModUploader}"
WORKSHOP_ID="${WORKSHOP_ID:-3028475425}"

if [ -z "$VERSION" ]; then
    VERSION="$(python -c 'import json;print(json.load(open("def.json"))["version_name"])')"
    [ -n "$VERSION" ] || exit 1
fi

release_tag() {
    git tag -s -m "Release v$VERSION" "v$VERSION"
}

release_build() {
    ./build.sh
}

release_upload() {
    "$UPLOADER" -u "$WORKSHOP_ID" prodmonitor.zip
}

release_prepare_next() {
    local parts=($(echo "$VERSION" | tr '.' ' '))

    local next="${parts[0]}.${parts[1]}.$((${parts[2]} + 1))"
    local next_code=$((${parts[2]} + ${parts[1]} * 1000 + ${parts[0]} * 100000 + 1))

    sed -i \
        -e 's/"version_name": ".*"/"version_name": "'"$next"'"/' \
        -e 's/"version_code": [0-9]*/"version_code": '"$next_code"'/' \
        def.json

    git add def.json
    git commit -S -m 'Prepare next release'
}

release_tag

release_build

release_upload

release_prepare_next
