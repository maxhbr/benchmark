#!/usr/bin/env bash

set -euo pipefail

prepare() {
    echo "prepare"
}

run() {
    echo "run"
}

cleanup() {
    echo "cleanup"
}

cmd="$1"
out="$2"

"$cmd" "$out"
