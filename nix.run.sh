#!/usr/bin/env nix-shell
#! nix-shell -i bash -p acpi glmark2 fio linuxKernel.packages.linux_latest.perf openjdk17 openscad ghc cabal-install gcc
exec ./run.sh "$@"
