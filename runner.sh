#!/usr/bin/env bash
cd $(dirname $0)
DIR=$(pwd)

set -ex
. env.sh
NUM_CPU_JOBS=$(grep -c ^processor /proc/cpuinfo)

WORK="$DIR/_work"
OUT="$DIR/out/$USER-$MACHINE"
if acpi -a | grep -v "on-line" -q; then
    OUT="$OUT-onBattery"
fi
OUT="$OUT/$(date +%Y-%m-%d)"

mkdir -p $OUT
BENCHMARK="$DIR/benchmarks/$1.sh"
if [ ! -f "$BENCHMARK" ]; then
    exit 1
fi
. "$BENCHMARK"

cat /proc/cpuinfo > "$OUT/cpuinfo"
free > "$OUT/free"
uname -a > "$OUT/uname"
LOG="$OUT/_$1.log"
exec &> >(tee -a $LOG)
RESULT="$OUT/$1.result"

################################################################################
## prepare
prepare

################################################################################
## warmup
$(getCMD)

################################################################################
## benchmark
echo "start at: $(date)"
perf stat -r 10 -d -o $RESULT $(getCMD)
echo "end at: $(date)"

################################################################################
## cleanup
cleanup
