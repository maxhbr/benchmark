SW360="$WORK/sw360"

prepare() {
    if [ ! -d "$SW360" ]; then
        git clone https://github.com/sw360/sw360portal "$SW360"
    fi
    cd "$SW360"
    git checkout sw360-2.0.0
    git reset --hard
    mvn clean
}

run(){
    cd "$SW360"
    mvn package -DskipTests
}
