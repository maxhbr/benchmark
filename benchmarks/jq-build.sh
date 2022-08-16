#!/usr/bin/env nix-shell
#! nix-shell -i bash -p oniguruma autoconf

set -euo pipefail

prepare() {
    local out="$1"
    set -x
    git clone \
        --depth 1 \
        https://github.com/stedolan/jq \
        --branch "jq-1.6" \
        --single-branch \
        "$out/jq"
    cd "$out/jq"
    git submodule update --init
}

run() {
    local out="$1"
    cd "$out/jq"
    autoreconf -fi              # if building from git
    ./configure --with-oniguruma=builtin
    make -j8
    make check
}

cleanup() {
    local out="$1"
    rm -rf "$out/jq"
}

cmd="$1"
out="$2"

"$cmd" "$out"
