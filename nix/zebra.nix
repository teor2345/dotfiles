{ pkgs ? import <nixpkgs> {} }:

with pkgs;
mkShell {
  buildInputs = [
    llvmPackages.libclang
  ];

  LIBCLANG_PATH = llvmPackages.libclang.lib + "/lib";

  shellHook = ''
    source ~/.profile

    export LIBCLANG_PATH
    echo LIBCLANG_PATH=$LIBCLANG_PATH
  '';
}
