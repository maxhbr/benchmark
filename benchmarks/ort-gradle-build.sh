#!/usr/bin/env bash
set -euo pipefail

prepare() {
    local out="$1"
    git clone \
        --depth 1 \
        https://github.com/oss-review-toolkit/ort \
        --branch main \
        --single-branch \
        "$out/ort"
}

run() {
    local out="$1"
    cd "$out/ort"
    ./gradlew installDist
    ./gradlew clean
}

cleanup() {
    local out="$1"
    rm -rf "$out/ort"
}

cmd="$1"
out="$2"

"$cmd" "$out"
