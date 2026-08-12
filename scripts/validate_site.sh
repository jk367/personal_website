#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
build_dir="$(mktemp -d)"

cleanup() {
  rm -rf -- "$build_dir"
}
trap cleanup EXIT

cd "$repo_dir"
hugo --gc --minify --destination "$build_dir"
ruby scripts/validate_site.rb "$build_dir" "$repo_dir"
