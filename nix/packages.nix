{ config, lib, pkgs, nix, ... }:

let
  emacsNoXWithPackages = with pkgs;
    (emacsPackagesFor emacs-nox).emacsWithPackages;
  emacs-nox-with-paradox =
    emacsNoXWithPackages (epkgs: with epkgs; [
      paradox
    ]);
  #r2205Tarball =
  #  fetchTarball
  #    https://github.com/NixOS/nixpkgs/archive/nixos-22.05.tar.gz;
  #
  # Workaround for can't create tmpdir error
  #unstableTarball =
  #  fetchTarball
  #    https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
in
{
  nixpkgs.config = {
    packageOverrides = pkgs: {
      #r2205 = import r2205Tarball {
      #  config = config.nixpkgs.config;
      #};
      #unstable = import unstableTarball {
      #  config = config.nixpkgs.config;
      #};
      unstable = import ./nixpkgs-nixos-unstable-2023-12-05 {
        config = config.nixpkgs.config;
      };
      # local nixpkgs checkout
      git-pkgs = import ./nixpkgs {
        config = config.nixpkgs.config;
      };
      boost-static = pkgs.boost.override {
        enableStatic = true;
        enableShared = true;
        enableIcu = true;
      };
    };
  };

  system.autoUpgrade.enable = true;
  # run between 0440 and 0540
  system.autoUpgrade.randomizedDelaySec = "60min";

  # depends on the number of logical CPU cores
  # 30 builds pins all CPUs at 100%, so let's try 27
  nix.maxJobs = 27;
  # 2 more than the 36 logical cores
  nix.nrBuildUsers = 38;
  nix.autoOptimiseStore = true;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 180d";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;

  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Disk management
    gptfdisk
    parted
    cloud-utils
    hdparm
    nvme-cli
    pciutils
    hddtemp
    smartmontools
    #sensors-detect
    hwinfo
    usbutils
    zfs-prune-snapshots

    # Networking
    dhcp
    wpa_supplicant
    ddclient
    mkpasswd
    git-pkgs.trippy

    # Terminals
    bash
    mosh
    tmux
    tmux-xpanes
    reptyr

    # Compression
    gzip
    bzip2
    xz
    lz4
    brotli
    zstd

    # Images
    resvg
    libcaca

    # Process Management
    glances
    htop
    lsof
    fd
    file
    fzf
    hyperfine
    i7z
    progress
    psmisc
    pstree
    python39Packages.py-cpuinfo
    sd
    timelimit
    tldr
    tree
    uutils-coreutils

    # File Management
    wget
    curl
    bind
    rsync
    netcat
    mbuffer
    magic-wormhole
    pv
    hexdump
    xxd

    # Editing
    emacs-nox-with-paradox

    act
    fastmod
    git
    gitoxide
    # needs to be built by itself, tests are timing-sensitive
    git-revise
    git-filter-repo
    jq
    unstable.jsonwatch
    jd-diff-patch
    dyff
    wdiff
    lesspipe
    ripgrep
    ack
    licensee

    # Package Management
    #
    # Not packaged?
    #nix-de-generate
    nix-index
    nix-prefetch-scripts
    nix-tree
    patchelf
    topgrade

    # Compiling
    gcc
    gdb
    cgdb
    lldb
    rr
    cargo-rr
    clang
    llvm
    llvm_12
    llvmPackages.libclang
    lld
    binutils
    libtool
    strace

    # aditya/lightwalletd needs go 1.16 or later
    unstable.go

    autoconf
    automake
    gnumake
    pkg-config

    # Software Development & Libraries
    #
    # Mining software
    cmakeCurses
    scons
    libsodium
    libsodium.dev
    # TODO: remove these and replace with boost-static?
    boost
    boost.dev
    nodePackages.npm
    nodePackages.node-gyp
    nodejs-14_x
    nodenv
    python2
    redis
    fasm

    # mining
    # with static as well as shared
    boost-static
    boost-static.dev
    git-pkgs.icu

    #redis-commander
    #steam-run

    # Documentation Building
    #
    # Zcash zips Makefile
    # also required for treemacs
    python3
    # note hard-coded version in pip but not python
    #python38Packages.pip
    pandoc
    rst2html5
    groff

    # Build Caches
    sccache
    # source archive changed hash around 2022-03-02
    ccache
    #ccacheWrapper
    #ccacheStdenv

    # Rust & Rust Tools
    #
    # Rust builds need a special nix shell config
    glibc
    rustup
    # updated too frequently
    #rust-analyzer
    rustup-toolchain-install-master
    rustc-demangle

    cargo
    cargo-all-features
    cargo-asm
    cargo-audit
    cargo-bloat
    cargo-binutils
    # 22.05 has 0.6.0 as of 2022-09-22,
    # but latest is 0.6.3
    unstable.cargo-bisect-rustc
    cargo-cache
    cargo-criterion
    cargo-deadlinks
    # 22.05 has 0.12.1
    #unstable.cargo-deny
    cargo-deps
    # installs cargo-{add,rm,upgrade}
    cargo-edit
    cargo-cache
    cargo-expand
    cargo-flamegraph
    cargo-fuzz
    cargo-generate
    cargo-graph
    unstable.cargo-hack
    cargo-inspect
    # updates too frequently
    # unstable.cargo-insta
    cargo-msrv
    cargo-outdated
    # updates frequently
    unstable.cargo-release
    cargo-sweep
    # updates frequently
    unstable.cargo-udeps
    # Older versions don't have --downdate
    cargo-update
    cargo-watch

    # tor & arti
    tor
    snowflake
    openssl
    sqlite

    # Zebra
    #
    # provides protoc for Rust crates:
    # - prost ProtoBufs
    # - tonic gRPC
    protobuf
    # ldb and sst_dump tools
    unstable.rocksdb
    unstable.rocksdb.tools

    # Profiling & Benchmarks
    gnuplot
    flamegraph
    linuxPackages.perf
    perf-tools
    pprof

    # zcashd
    #
    # use git-pkgs if needed to get the latest version
    git-pkgs.zcash
    # required for zcashd?
    git-pkgs.util-linux
  ];
}
