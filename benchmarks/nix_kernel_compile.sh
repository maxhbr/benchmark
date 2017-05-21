NIXPKGS="$WORK/nixpkgs"
NIXPREFIX="$WORK/nixprefix"

cleanup() {
    rm -rf "$NIXPKGS/result"
    rm -rf "$NIXPREFIX"
}

prepare() {
    if [ ! -d "$NIXPKGS" ]; then
        git clone https://github.com/nixos/nixpkgs "$NIXPKGS"
    fi
    cleanup
}

run(){
    cd "$NIXPKGS"
    NIX_PATH= \
            NIX_STORE_DIR=$NIXPREFIX/store \
            NIX_DATA_DIR=$NIXPREFIX/share \
            NIX_LOG_DIR=$NIXPREFIX/log/nix \
            NIX_STATE_DIR=$NIXPREFIX/var/nix \
            NIX_DB_DIR=$NIXPREFIX/var/nix/db \
            NIX_CONF_DIR=/dev/null \
            nix-build nixos
}
