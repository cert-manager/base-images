#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

image=$1
out_file=$2

if [[ -z "$image" || -z "$out_file" ]]; then
    echo "Usage: $0 <image> <out_file>"
    exit 1
fi

# If the image is not an OCI image index, or it does not exist, skip it
crane_manifest_output="$(crane manifest "$image" || echo \"{}\")" 
if [[ "$(echo "$crane_manifest_output" | jq -r .mediaType)" != "application/vnd.oci.image.index.v1+json" ]]; then
    echo "Image does not exist or is not an OCI image index: $image, skipping"
    exit 0
fi

# Get the latest digest from the registry
digests=()

digests+=("$(crane digest "$image")")

for combo in $(echo "$crane_manifest_output" | jq -r '.manifests[] | .platform.architecture + .platform.variant + "_" + .digest'); do
    arch="$(echo "${combo}" | cut -d "_" -f1)"
    digest="$(echo "${combo}" | cut -d "_" -f2)"
    echo "Found architecture: ${arch}"
    digests+=("$digest")
done

sigs=()
sigs_digests=()

for digest in "${digests[@]}"; do
    sig="${digest/:/-}.sig"
    sig_digest="$(crane digest "${image%%:*}:$sig")"

    sigs+=("$sig")
    sigs_digests+=("$sig_digest")
done

sboms=()
sboms_digests=()

for digest in "${digests[@]}"; do
    sbom="${digest/:/-}.sbom"
    sbom_digest="$(crane digest "${image%%:*}:$sbom")"

    sboms+=("$sbom")
    sboms_digests+=("$sbom_digest")
done


mkdir -p "$(dirname "$out_file")"

echo -n "" > "$out_file"
for i in "${!digests[@]}"; do
    echo "${image%%:*}:${sboms[$i]}@${sboms_digests[$i]}" >> "$out_file"
    echo "${image%%:*}:${sigs[$i]}@${sigs_digests[$i]}" >> "$out_file"
done
