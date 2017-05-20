CONTAINER=benchmarksw360compile
SW360="$WORK/sw360"

prepare() {
    if [ ! -d $SW360 ]; then
        git clone https://github.com/sw360/sw360portal $SW360
    fi
    cd $SW360
    git checkout sw360-2.0.0
    git reset --hard
    mvn clean
    set +e
    docker rm $CONTAINER
    docker rmi sw360/$CONTAINER
}

run(){
    cd $SW360

    cat sw360dev.Dockerfile | docker build -t sw360/$CONTAINER --rm=true --force-rm=true -

    docker run -i -v $(pwd):/sw360portal -w /sw360portal --net=host --name $CONTAINER sw360/$CONTAINER su-exec $(id -u):$(id -g) mvn package -DskipTests
}
