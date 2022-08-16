#!/usr/bin/env bash
set -euo pipefail

export LANG=C
ROOT="$( cd $(dirname "$0") && pwd)"

getOutputFolder() {
    local OUT
    OUT="${ROOT}/out/$(hostname)"
    if acpi -a | grep -v "on-line" -q; then
        OUT="$OUT/onBattery"
    fi
    OUT="$OUT/$(date +%Y-%m-%d)"
    mkdir -p "$OUT"
    echo "$OUT"
}

writeStats() {
    local OUT="$1"
    cat /proc/cpuinfo > "$OUT/cpuinfo"
    free > "$OUT/free"
    uname -a > "$OUT/uname"
}

benchFio() {
    local OUT="$1/fio"
    if [[ ! -d "$OUT" ]]; then
        mkdir -p "$OUT"
        fio --name TEST --eta-newline=5s --filename=temp.file --rw=randread --size=2g --io_size=10g --blocksize=4k --ioengine=libaio --fsync=1 --iodepth=1 --direct=1 --numjobs=32 --runtime=60 --group_reporting |
            tee -a "$OUT/random-4K-reads"
        fio --name TEST --eta-newline=5s --filename=temp.file --rw=randrw --size=2g --io_size=10g --blocksize=4k --ioengine=libaio --fsync=1 --iodepth=1 --direct=1 --numjobs=1 --runtime=60 --group_reporting |
            tee -a "$OUT/Mixed-random-4K-read-and-write"
    fi
}

benchGlmark() {
    local OUT="$1/glmark"
    if [[ ! -f "$OUT" ]]; then
        glmark2 |
            tee "$OUT"
    fi
}

benchFromFile() {
    local OUT="$1"
    local script="$2"
    local bn="$(basename "$script")"
    local bOUT="$OUT/${bn%.*}"
    mkdir -p "$bOUT"
    {
        "$script" prepare "$bOUT"
        "$script" run "$bOUT"
        perf stat -r 10 -d \
            -o "$bOUT/result" \
            -- "$script" run "$bOUT"
        "$script" cleanup "$bOUT"
    } | tee "$bOUT/log"
    cat "$bOUT/result"
}

benchesFromFiles() {
    local OUT="$1"
    find "$ROOT/benchmarks" -type f -executable -print0 |
        while IFS= read -r -d '' script; do
            benchFromFile "$OUT" "$script"
        done
}

main() {
    local OUT
    OUT="$(getOutputFolder)"
    writeStats "$OUT"

    if [[ $# -eq 0 ]]; then
        benchesFromFiles "$OUT"
        benchFio "$OUT"
        benchGlmark "$OUT"
    else
        for script in "$@"; do
            benchFromFile "$OUT" "$(readlink -f "$script")"
        done
    fi
}

main "$@"
