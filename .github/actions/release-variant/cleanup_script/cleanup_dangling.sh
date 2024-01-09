#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

digest_file=$1
out_file=$2

if [[ -z "$digest_file" || -z "$out_file" ]]; then
    echo "Usage: $0 <digest_file> <out_file>"
    exit 1
fi

# Write an empty array to the output file in case we return early
mkdir -p "$(dirname "$out_file")"
echo "[]" > "$out_file"

if [[ ! -f "$digest_file" ]]; then
    echo "Digest file $digest_file does not exist, skipping cleanup"
    exit 0
fi

digests_to_delete=()

while read -r artifact; do
    artifact_name="${artifact%%@*}"
    artifact_digest="${artifact##*@}"

    artifact_new_digest="$(crane digest "$artifact_name")"

    if [[ "$artifact_digest" != "$artifact_new_digest" ]]; then
        echo "Deleting $artifact_name@$artifact_digest"
        digests_to_delete+=("$artifact_digest")
    fi
done < "$digest_file"

# Write the digests to delete to the output file, encoded as a JSON array
printf '%s\n' "${digests_to_delete[@]}" | jq -R . | jq -s . > "$out_file"
