#!/usr/bin/env bash

cd $(dirname $0)
. env.sh
cd $FOSS

vagrant up
