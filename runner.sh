#!/usr/bin/env bash
cd $(dirname $0)
DIR=$(pwd)

set -ex
. env.sh

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
LOG="$OUT/$1.log"

exec &> >(tee -a $LOG)
################################################################################
## warmup
prepare
run

################################################################################
## test

exec 1> >(tee -a $LOG)
exec 2> >(tee -a $BROUT)
prepare
time run
