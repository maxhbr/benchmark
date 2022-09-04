#!/usr/bin/env bash

set -euo pipefail

cleanup() {
    local out="$1"
    rm -rf "$out/tmp"
}

prepare() (
    local out="$1"
    set -x
    cleanup "$out"
    git clone \
        --depth 1 \
        https://github.com/HeinrichApfelmus/reactive-banana \
        --branch "v1.3.1.0" \
        --single-branch \
        "$out/tmp/reactive-banana"
    cabal update
)

run() {
    local out="$1"
    cd "$out/tmp/reactive-banana"
    cd reactive-banana
    cabal build
    cabal clean
}

cmd="$1"
out="$2"

"$cmd" "$out"
