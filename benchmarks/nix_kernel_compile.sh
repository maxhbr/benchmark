NIXPKGS="$WORK/nixpkgs"

prepare() {
    if [ ! -d "$NIXPKGS" ]; then
        git clone https://github.com/nixos/nixpkgs "$NIXPKGS"
    fi
    cd "$NIXPKGS"
}

run(){
    cd "$NIXPKGS"
}
