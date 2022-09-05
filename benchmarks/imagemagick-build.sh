#!/usr/bin/env bash
# see also: https://openbenchmarking.org/innhold/d18befcc4fb18537d42b71fdab18c2aeeb261fed
set -euo pipefail

requirements() {
    echo "gcc"
}

prepare() {
    local out="$1"
    set -x
    mkdir -p "$out/workdir";
    cd "$out/workdir";
    wget -nc http://www.phoronix-test-suite.com/benchmark-files/ImageMagick-6.9.0-0.tar.bz2
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
