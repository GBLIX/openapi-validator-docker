#!/bin/bash

# $ ./update.sh [NEW VERSION]
# Update the ibm-openapi-validator version pinned in the Dockerfile.
# Where:
#   [NEW VERSION] is a version string, with or without the leading
#   "ibm-openapi-validator@" prefix (e.g. "1.37.14" or
#   "ibm-openapi-validator@1.37.14").
#
# Outputs (written as GitHub Actions step outputs when running in Actions,
# otherwise printed to stdout):
#   make_pr  "yes" when the Dockerfile was changed, "no" otherwise
#   version  the resolved version string without the prefix

set -eo pipefail

# Emit a step output. Writes to $GITHUB_OUTPUT in GitHub Actions, otherwise
# prints to stdout so the script is usable locally.
# $1 name
# $2 value
function output {
    if [ -n "$GITHUB_OUTPUT" ]; then
        echo "$1=$2" >>"$GITHUB_OUTPUT"
    else
        echo "$1=$2"
    fi
}

# === Check for version passed ===

if [ -z "$1" ]; then
    echo "Please pass [NEW VERSION]"
    exit 1
fi

# Release tags use the "ibm-openapi-validator@X.Y.Z" format, e.g:
# https://github.com/IBM/openapi-validator/releases/tag/ibm-openapi-validator%401.37.14
new_version=${1//ibm-openapi-validator@/}

# === Read current version from Dockerfile ===

current_version=$(grep -Eo '^ARG version=[0-9.]+$' Dockerfile | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')

echo "Current version = '$current_version'"
echo "Latest version  = '$new_version'"

if [ "$current_version" = "$new_version" ]; then
    echo "Already up to date."
    output "make_pr" "no"
    output "version" "$new_version"
    exit 0
fi

# === Update Dockerfile ===

echo ""
echo "=== Updating Dockerfile to '$new_version' ==="

sed --in-place "s/^ARG version=[0-9.]*$/ARG version=$new_version/" Dockerfile

output "make_pr" "yes"
output "version" "$new_version"

cat Dockerfile
