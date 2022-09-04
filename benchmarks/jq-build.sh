#!/usr/bin/env nix-shell
#! nix-shell -i bash -p oniguruma autoconf

set -euo pipefail

prepare() {
    local out="$1"
    set -x
    if [[ ! -d "$out/workdir/jq" ]]; then
        git clone \
            --depth 1 \
            https://github.com/stedolan/jq \
            --branch "jq-1.6" \
            --single-branch \
            "$out/workdir/jq"
        cd "$out/workdir/jq"
        git submodule update --init
    fi
}

run() {
    local out="$1"
    cd "$out/workdir/jq"
    autoreconf -fi              # if building from git
    ./configure --with-oniguruma=builtin
    make -j8
    make check
}

cleanup() {
    local out="$1"
    rm -rf "$out/workdir"
}

cmd="$1"
out="$2"

"$cmd" "$out"
