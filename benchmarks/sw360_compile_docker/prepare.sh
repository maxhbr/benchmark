#!/usr/bin/env bash

cd $(dirname $0)
. env.sh

if [ ! -d $OUT ]; then
    git clone https://github.com/sw360/sw360portal $OUT
fi
cd $OUT
git checkout sw360-2.0.0
git reset --hard
mvn clean
set +e
docker rm $CONTAINER
docker rmi sw360/$CONTAINER
