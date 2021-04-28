{ pkgs ? import <nixpkgs> {} }:

with pkgs;
mkShell {
  buildInputs = [
    llvmPackages.libclang
    openssl
    pkg-config
  ];

  LIBCLANG_PATH = llvmPackages.libclang.lib + "/lib";
  OPENSSL_DIR = openssl.dev;
  OPENSSL_LIB_DIR = openssl.out + "/lib";
  LD_LIBRARY_PATH = openssl.out + "/lib";

  shellHook = ''
    source ~/.profile

    export LIBCLANG_PATH
    echo LIBCLANG_PATH="$LIBCLANG_PATH"
    export OPENSSL_DIR
    echo OPENSSL_DIR="$OPENSSL_DIR"
    export OPENSSL_LIB_DIR
    echo OPENSSL_LIB_DIR="$OPENSSL_LIB_DIR"
    export LD_LIBRARY_PATH
    echo LD_LIBRARY_PATH="$LD_LIBRARY_PATH"
  '';
}
