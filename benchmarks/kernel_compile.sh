# see also: https://openbenchmarking.org/innhold/c8ff4e5356ccc38f408cec5ec223192199b29db8

TGZ="$WORK/linux-4.9.tar.gz"
KERNEL="$WORK/linux-4.9"

cleanup() {
    rm -rf "$KERNEL"
}

prepare() {
    if [ ! -f "$TGZ" ]; then
        wget -O "$TGZ" http://www.kernel.org/pub/linux/kernel/v4.x/linux-4.9.tar.gz 
    fi
    cd "$WORK"
    cleanup
    tar -xf linux-4.9.tar.gz
    cd "$KERNEL"
    make defconfig
    make clean
}

run(){
    cd "$KERNEL"
    make -s -j \$NUM_CPU_JOBS 2>&1
}
