SW360="$WORK/sw360"

cleanup() {
    cd "$SW360"
    git checkout sw360-2.0.0
    git reset --hard
    mvn -q clean
}

prepare() {
    if [ ! -d "$SW360" ]; then
        git clone https://github.com/sw360/sw360portal "$SW360"
    fi
    cleanup
}

getCMD() {
    echo "mvn package -DskipTests"
}
