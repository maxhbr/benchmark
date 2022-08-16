#!/usr/bin/env bash

set -euo pipefail

prepare() (
    local out="$1"
    set -x
    git clone \
        --depth 1 \
        https://github.com/HeinrichApfelmus/reactive-banana \
        --branch "v1.3.1.0" \
        --single-branch \
        "$out/reactive-banana"
    cabal update
)

run() {
    local out="$1"
    cd "$out/reactive-banana"
    cd reactive-banana
    cabal build
    cabal clean
}

cleanup() {
    local out="$1"
    rb="$out/reactive-banana"
    rm -rf "$rb"
}

cmd="$1"
out="$2"

"$cmd" "$out"