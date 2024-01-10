#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

digest_file=$1

if [[ -z "$digest_file" ]]; then
    echo "Usage: $0 <digest_file>"
    exit 1
fi

if [[ ! -f "$digest_file" ]]; then
    echo "Digest file $digest_file does not exist, skipping cleanup"
    exit 0
fi

while read -r artifact; do
    artifact_name="${artifact%%@*}"
    artifact_digest="${artifact##*@}"

    artifact_new_digest="$(crane digest "$artifact_name")"

    if [[ "$artifact_digest" != "$artifact_new_digest" ]]; then
        echo "Deleting $artifact_name@$artifact_digest"
        crane delete "$artifact_name@$artifact_digest"
    fi
done < "$digest_file"
