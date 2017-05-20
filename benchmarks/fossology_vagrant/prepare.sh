#!/usr/bin/env bash

cd $(dirname $0)
. env.sh

if [ ! -d $FOSS ]; then
    git clone https://github.com/fossology/fossology $FOSS
fi
cd $FOSS
git checkout 3.1.0
git reset --hard
make clean
vagrant destroy -f
