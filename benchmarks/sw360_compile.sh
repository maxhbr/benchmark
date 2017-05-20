prepare() {
    if [ ! -d "$WORK/sw360" ]; then
        git clone https://github.com/sw360/sw360portal "$WORK/sw360"
    fi
    cd "$WORK/sw360"
    git checkout sw360-2.0.0
    git reset --hard
    mvn clean
}

run(){
    cd "$WORK/sw360"
    mvn package -DskipTests
}
