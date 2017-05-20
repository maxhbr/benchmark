#!/usr/bin/env bash
cd $(dirname $0)
DIR=$(pwd)

set -ex
. env.sh

WORK="$DIR/_work"
OUT="$DIR/_out/$USER-$MACHINE"
mkdir -p $OUT
BENCHMARK="$DIR/benchmarks/$1.sh"
if [ ! -f "$BENCHMARK" ]; then
    exit 1
fi
. "$BENCHMARK"

BOUT="$OUT/$1.log"
BROUT="$OUT/$1.result"

exec 1> >(tee -a $BOUT)
exec 2> >(tee -a $BROUT)
################################################################################
## warmup
# prepare
# run

################################################################################
## test

exec 1> >(tee -a $BOUT)
exec 2> >(tee -a $BROUT)
prepare
time run
