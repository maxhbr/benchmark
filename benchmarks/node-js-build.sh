#!/usr/bin/env nix-shell
#! nix-shell -i bash -p gcc
# see also: https://openbenchmarking.org/innhold/2ebe0891102137cce40ec271559957c7c518c984
set -euo pipefail

prepare() {
    local out="$1"
    set -x
    mkdir -p "$out/workdir";
    cd "$out/workdir"
    wget -nc https://nodejs.org/download/release/v18.8.0/node-v18.8.0.tar.xz
}

run() {
    local out="$1"
    cd "$out/workdir"
    rm -rf node-v18.8.0
    tar -xf node-v18.8.0.tar.xz
    cd node-v18.8.0
    ./configure
    make -s -j "$(nproc)"
}

cleanup() {
    local out="$1"
    rm -rf "$out/workdir"
}

cmd="$1"
out="$2"

"$cmd" "$out"
