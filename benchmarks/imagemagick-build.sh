#!/usr/bin/env nix-shell
#! nix-shell -i bash -p gcc
# see also: https://openbenchmarking.org/innhold/d18befcc4fb18537d42b71fdab18c2aeeb261fed
set -euo pipefail

prepare() {
    local out="$1"
    set -x
    if [[ ! -f "$out/ImageMagick-6.9.0-0.tar.bz2" ]]; then
        (cd "$out"; wget http://www.phoronix-test-suite.com/benchmark-files/ImageMagick-6.9.0-0.tar.bz2)
    fi
    rm -rf node-v18.8.0
    tar -xjf ImageMagick-6.9.0-0.tar.bz2
    cd ImageMagick-6.9.0-0/
    ./configure > /dev/null
    make clean
}

run() {
    local out="$1"
    cd "$out"
    make -s -j "$(nproc)"
    make clean
}

cleanup() {
    local out="$1"
    cd "$out"
    rm -rf ImageMagick-6.9.0-0/
}

cmd="$1"
out="$2"

"$cmd" "$out"
