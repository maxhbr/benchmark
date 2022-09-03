#!/usr/bin/env nix-shell
#! nix-shell -i bash -p acpi glmark2 fio linuxKernel.packages.linux_5_19.perf openjdk17 openscad ghc cabal-install
exec ./run.sh "$@"
