#!/usr/bin/env bash

set -euo pipefail

requirements() {
    echo "git cabal"
}

cleanup() {
    local out="$1"
    rm -rf "$out/workdir"
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
        "$out/workdir/reactive-banana"
    cabal update
)

run() {
    local out="$1"
    cd "$out/workdir/reactive-banana"
    cd reactive-banana
    cabal build
    cabal clean
}

cmd="$1"
out="$2"

"$cmd" "$out"
