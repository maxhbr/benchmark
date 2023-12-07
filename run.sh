#!/usr/bin/env bash
set -euo pipefail

export LANG=C
ROOT="$( cd $(dirname "$0") && pwd)"

guardForBins() {
    for cmd in "$@"; do
        if ! command -v "$cmd" &> /dev/null; then
            >&2 echo "$cmd is required"
            return 1
        fi
    done
}

getOutputFolder() {
    local OUT
    OUT="${ROOT}/out/$(hostname)"
    if [[ -f /sys/firmware/acpi/platform_profile ]]; then
        OUT="$OUT-$(cat /sys/firmware/acpi/platform_profile)"
    fi
    if guardForBins "acpi"; then
        if acpi -a | grep -v "on-line" -q; then
            OUT="$OUT/onBattery"
        fi
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
    git add "$OUT/cpuinfo" "$OUT/free" "$OUT/uname"
}

benchFio() {
    local OUT="$1/fio"
    if [[ ! -d "$OUT" ]] && guardForBins "fio"; then
        mkdir -p "$OUT"
        fio --name TEST --eta-newline=5s --filename=temp.file --rw=randread --size=2g --io_size=10g --blocksize=4k --ioengine=libaio --fsync=1 --iodepth=1 --direct=1 --numjobs=32 --runtime=60 --group_reporting |
            tee -a "$OUT/random-4K-reads"
        fio --name TEST --eta-newline=5s --filename=temp.file --rw=randrw --size=2g --io_size=10g --blocksize=4k --ioengine=libaio --fsync=1 --iodepth=1 --direct=1 --numjobs=1 --runtime=60 --group_reporting |
            tee -a "$OUT/Mixed-random-4K-read-and-write"
        git add "$OUT"
    fi
}

benchGlmark() {
    local OUT="$1/glmark"
    if [[ ! -f "$OUT" ]] && guardForBins "glmark2"; then
        glmark2 |
            tee "$OUT"
        git add "$OUT"
    fi
}

bench7zip() {
    local OUT="$1/7zb"
    if [[ ! -f "$OUT" ]] && guardForBins "7z"; then
        7z b | 
          tee "$OUT"
        git add "$OUT"
    fi
}

benchFromFile() {
    guardForBins "perf" || return 0
    local OUT="$1"
    local script="$2"
    local bn="$(basename "$script")"
    local bOUT="$OUT/${bn%.*}"

    guardForBins $("$script" requirements "$bOUT") || return 0
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
    gzip "$bOUT/log"
    git add "$bOUT/result" "$bOUT/log.gz"
}

benchesFromFiles() {
    local OUT="$1"
    find "$ROOT/benchmarks" -type f -executable -print0 |
        while IFS= read -r -d '' script; do
            benchFromFile "$OUT" "$script"
        done
}

benchesFromFunctions() {
    local OUT="$1"
    benchFio "$OUT"
    benchGlmark "$OUT"
    bench7zip "$OUT"
}

main() {
    local OUT
    OUT="$(getOutputFolder)"
    writeStats "$OUT"

    if [[ $# -eq 0 ]]; then
        benchesFromFiles "$OUT"
        benchesFromFunctions "$OUT"
    elif [[ "$1" == "--other" ]]; then
        benchesFromFunctions "$OUT"
    else
        for script in "$@"; do
            benchFromFile "$OUT" "$(readlink -f "$script")"
        done
    fi
}

main "$@"
