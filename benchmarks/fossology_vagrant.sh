FOSS="$WORK/fossology"

prepare() {
    if [ ! -d $FOSS ]; then
        git clone https://github.com/fossology/fossology $FOSS
    fi
    cd $FOSS
    git checkout 3.1.0
    git reset --hard
    make clean
    vagrant destroy -f
}

run(){
    cd $FOSS
    vagrant up
}
