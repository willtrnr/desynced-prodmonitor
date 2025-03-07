#! /usr/bin/env bash

set -e

UPLOADER="${UPLOADER:-../../../DesyncedModUploader}"
WORKSHOP_ID="${WORKSHOP_ID:-3028475425}"

if [ -z "$VERSION" ]; then
  VERSION="$(jq -r .version_name def.json)"
  [ -n "$VERSION" ] || exit 1
fi

release_tag() {
  git tag -s -m "Release v$VERSION" "v$VERSION"
}

release_build() {
  make clean && make dist
}

release_upload() {
  "$UPLOADER" -u "$WORKSHOP_ID" prodmonitor.zip
}

release_prepare_next() {
  # shellcheck disable=SC2206
  local parts=(${VERSION//./ })

  local next="${parts[0]}.${parts[1]}.$((parts[2] + 1))"
  local next_code=$((
    parts[0] * 100000 + 1 +
    parts[1] * 1000 +
    parts[2]
  ))

  jq -r \
    --arg next "$next" \
    --arg next_code "$next_code" \
    '.version_name = $next | .version_code = ($next_code | tonumber)' \
    def.json >def.json.new

  mv def.json.new def.json

  git add def.json
  git commit -S -m 'Prepare next release'
}

release_tag

release_build

release_upload

release_prepare_next
