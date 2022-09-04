#!/usr/bin/env nix-shell
#! nix-shell -i bash -p gcc
# see also: https://openbenchmarking.org/innhold/d18befcc4fb18537d42b71fdab18c2aeeb261fed
set -euo pipefail

prepare() {
    local out="$1"
    set -x
    mkdir -p "$out/workdir";
    cd "$out/workdir";
    if [[ ! -f "ImageMagick-6.9.0-0.tar.bz2" ]]; then
        wget http://www.phoronix-test-suite.com/benchmark-files/ImageMagick-6.9.0-0.tar.bz2
    fi
    rm -rf ImageMagick-6.9.0-0/
    tar -xjf ImageMagick-6.9.0-0.tar.bz2
    cd ImageMagick-6.9.0-0/
    ./configure > /dev/null
    make clean
}

run() {
    local out="$1"
    cd "$out/workdir/ImageMagick-6.9.0-0/"
    make -s -j "$(nproc)"
    make clean
}

cleanup() {
    local out="$1"
    rm -rf "$out/workdir"
}

cmd="$1"
out="$2"

"$cmd" "$out"
