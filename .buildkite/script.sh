#!/bin/bash
set -euo pipefail

BaseBranch=$BUILDKITE_PULL_REQUEST_BASE_BRANCH

git diff --stat "$BaseBranch"

if ! git diff --name-only "$BaseBranch".. | grep -qvE '(.md)'; then
    echo "Only doc files were updated, not running the CI."
    exit
fi

echo "Running pr-pipeline."


buildkite-agent pipeline upload  <<YAML
steps:
  - label: ":building_construction: Quick Build"
    command: "buildkite-agent pipeline upload .buildkite/pr-pipeline.yml"
YAML
