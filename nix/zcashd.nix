{ pkgs ? import <nixpkgs> {} }:

with pkgs;
mkShell {
  buildInputs = [
    autoconf
    automake
    bash
    ccache
    clang
    git
    libtool
    openssl
    pkg-config
    zlib
    # This might be required, even though zcashd downloads its own Rust
    rustc
    cargo
  ];

  # Some build stages seem to ignore these flags
  enableParallelBuilding = true;
  enableParallelChecking = true;

  shellHook = ''
    # Some build stages seem to ignore the parallel build flags
    source ~/.profile

    # These seem to be required, even though zcashd downloads its own Rust
    export CARGO=$(which cargo);
    export RUSTC=$(which rustc);

    # also try --with-sanitizers=...
    export CONFIGURE_FLAGS="--enable-debug --enable-online-rust";

    echo Run zcutil/build.sh
    echo To clean, run zcutil/clean.sh or zcutil/distclean.sh
    echo Only works until v4.0.0, due to the rust crates refactor
  '';
}
