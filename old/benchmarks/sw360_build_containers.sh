SW360CHORES="$WORK/sw360chores"

cleanup() {
    echo "nothing"
}

prepare() {
    if [ ! -d "$SW360CHORES" ]; then
        git clone https://github.com/sw360/sw360chores "$SW360CHORES"
    fi
    cleanup
    cd "$SW360CHORES/deployment"
    ./docker-compose.sh --prepare
}

run(){
    cd "$SW360CHORES/deployment"
    ./docker-compose.sh build
}
