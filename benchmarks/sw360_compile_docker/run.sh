#!/usr/bin/env bash

cd $(dirname $0)
. env.sh
cd $OUT

cat sw360dev.Dockerfile | docker build -t sw360/$CONTAINER --rm=true --force-rm=true -

docker run -i -v $(pwd):/sw360portal -w /sw360portal --net=host --name $CONTAINER sw360/$CONTAINER su-exec $(id -u):$(id -g) mvn package -DskipTests
