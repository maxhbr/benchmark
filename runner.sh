#!/usr/bin/env bash
cd $(dirname $0)
DIR=$(pwd)

set -ex
. env.sh
NUM_CPU_JOBS=$(grep -c ^processor /proc/cpuinfo)

WORK="$DIR/_work"
OUT="$DIR/out/$USER-$MACHINE/$(date +%Y-%m-%d)"
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
RESULT="$OUT/$1.result"

################################################################################
## warmup
prepare
$(getCMD)

################################################################################
## benchmark
prepare
exec &> >(tee -a $LOG)
echo "start at: $(date)"
perf stat -r 1 -d -o $RESULT $(getCMD)
echo "end at: $(date)"
cleanup
