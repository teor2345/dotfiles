# usage:
#   nix-shell --pure rust-overlay.nix [ --command <interactive> | --run <non-interactive> ]

let
  moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
  nixpkgs = import <nixpkgs> { overlays = [ moz_overlay ]; };
in
  with nixpkgs;
  stdenv.mkDerivation {
    name = "zebra_shell";
    buildInputs = [
      cacert
      nixpkgs.latest.rustChannels.stable.rust
      #(rustChannelOf { channel = "1.48"; }).rust
      clang
      llvmPackages.libclang
    ];

    LIBCLANG_PATH = llvmPackages.libclang.lib + "/lib";

    shellHook = ''
      # ignore the cargo config in $HOME
      export CARGO_HOME=$(mktemp -d)
      # put the targets in a temp dir
      export CARGO_TARGET_DIR=$(mktemp -d)
   '';
  }
