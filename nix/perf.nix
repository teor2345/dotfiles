{ config, lib, pkgs, hardware, ... }:

{
  # For tmpfs filesystems, see hardware-configuration.nix

  # ZFS services
  services.zfs = {
    autoScrub.enable = true;
    # TRIM causes data errors and disk disconnects on some drives.
    # Disabled on 9 Oct 2020.
    # Also set autotrim=off on all 3 pools.
    trim.enable = false;
  };
  # TRIM causes data errors and disk disconnects on some drives.
  services.fstrim.enable = false;

  # CPU performance
  powerManagement.cpuFreqGovernor = "ondemand";

  hardware.nvidia.powerManagement.enable = true;
  # Override nixos-hardware - requires Xlibs
  services.xserver.videoDrivers = [];
  # Only works with dual graphics cards
  hardware.nvidia.prime.offload.enable = false;
  hardware.nvidia.prime.nvidiaBusId = "65:00.0";
  #hardware.nvidia.prime.intelBusId = "";
  #hardware.nvidia.prime.sync.enable = true;
  #hardware.nvidia.modesetting.enable = true;

  # Use the same packages for 32-bit and 64-bit OpenGL executables
  hardware.opengl.extraPackages32 = hardware.opengl.extraPackages;

  # temp files
  #
  # NOTE:
  # deletion is only applied to the exact file or directory,
  # if all of the subtree hasn't been accessed or modified recently
  systemd.tmpfiles.rules = [
    # zebrad block cache
    "d  /home/dev/.cache/zebra-tmp     0755 dev users bBmM:6d"
    "e- /home/dev/.cache/zebra-tmp/*   0755 dev users bBmM:6d"

    # Zebra and Rust build caches
    "d  /home/dev/zebra/target         0755 dev users bBmM:6d"

    "d  /home/dev/.cache/sccache       0755 dev users bBmM:6d"

    # C build cache
    # TODO: check exact directory structure
    "d  /home/dev/.ccache              0755 dev users bBmM:6d"

    # Rust test temporary dirs
    # avoid "'env-vars' exists and is not a directory" error
    "x  /run/user/1000/bus             0644 dev users -"
    "x  /run/user/1000/env-vars        0644 dev users -"
    "x  /run/user/1000/systemd         0755 dev users -"
    "d  /run/user/1000                 0700 dev users bBmM:1d"
    "e- /run/user/1000/*               0700 dev users bBmM:1d"
  ];

  boot = {
    tmpOnTmpfs = true;
    # mostly redundant, but useful on first tmpfs boot, and to cleanup if the
    # tmpfs doesn't actually mount
    cleanTmpDir = true;

    # there's a lot of RAM, so make the defaults smaller
    # (except for devShm, which is used like process RAM)
    runSize = "33%";
    devSize = "1%";
    # TODO: add a tmpSize option?
    # TODO: add tmp,run,dev nr_inodes options?

    # TODO:
    #   - make nixos-generate-config preserve tmpfs options size,nr_inodes,mode,uid,gid
    #   - make nixos-generate-config preserve zfs options uid,gid
    #     - but mount.zfs doesn't seem to accept these options,
    #       so use chown instead
    #   - make nixos-generate-config preserve swap options discard,...
    #   - make nixos-generate-config sort the generated file

    # Until then:
    # swapon --discard -p 0 ${DISK_FAST}-part5
    # swapon --discard -p 0 ${DISK_2}-part5
  };

  zramSwap = {
    enable = true;
    # defaults
    #memoryPercent = 50;
    #algorithm = "zstd";
  };

  # override some filesystem options
  #  - change tmpfs sizes
  #  - make data-pool and tmpfs optional
  #
  # these extra configs replace the auto-generated
  # configs in hardware-configuration.nix

  # zfs
  # the uid and gid options don't work

  fileSystems."/tmp" =
    {
      device = "tmpfs";
      fsType = "tmpfs";
      options =
        [
          "size=10%"
          "nr_inodes=16k"
          "nofail"
        ];
    };

  fileSystems."/home/dev/.ccache" =
    {
      device = "tmpfs";
      fsType = "tmpfs";
      options =
        [
          "uid=dev"
          "gid=users"
          "size=8G"
          "nr_inodes=256k"
          "mode=755"
          "nofail"
        ];
    };

  fileSystems."/home/dev/zebra/target" =
    {
      device = "tmpfs";
      fsType = "tmpfs";
      options =
        [
          "uid=dev"
          "gid=users"
          "size=160G"
          "nr_inodes=256k"
          "mode=755"
          "nofail"
        ];
    };

  fileSystems."/var/tmp" =
    {
      device = "tmpfs";
      fsType = "tmpfs";
      options =
        [
          # defaults
          "nofail"
        ];
    };

  fileSystems."/home/dev/.cache" =
    {
      device = "data-pool/user/cache-data/dev/cache";
      fsType = "zfs";
      options =
        [
          # defaults
          "nofail"
        ];
    };

  fileSystems."/home/dev/.zcash/blocks" =
    {
      device = "data-pool/user/zcashd/dev/mainnet/blocks";
      fsType = "zfs";
      options =
        [
          # defaults
          "nofail"
        ];
    };

  fileSystems."/home/dev/.cache/sccache" =
    {
      device = "tmpfs";
      fsType = "tmpfs";
      options =
        [
          "uid=dev"
          "gid=users"
          "size=8G"
          "nr_inodes=256k"
          "mode=755"
          "nofail"
        ];
    };

  fileSystems."/home/dev/.zcash/chainstate" =
    {
      device = "data-pool/user/zcashd/dev/mainnet/chainstate";
      fsType = "zfs";
      options =
        [
          # defaults
          "nofail"
        ];
    };

  fileSystems."/home/dev/.zcash-testnet/testnet3/blocks" =
    {
      device = "data-pool/user/zcashd/dev/testnet/blocks";
      fsType = "zfs";
      options =
        [
          # defaults
          "nofail"
        ];
    };

  fileSystems."/home/dev/.zcash-testnet/testnet3/chainstate" =
    {
      device = "data-pool/user/zcashd/dev/testnet/chainstate";
      fsType = "zfs";
      options =
        [
          # defaults
          "nofail"
        ];
    };

  fileSystems."/home/dev/.cache/zebra-custom/state" =
    {
      device = "data-pool/user/zebra/dev/state";
      fsType = "zfs";
      options =
        [
          # defaults
          "nofail"
        ];
    };

  # these duplicate configs end up first in /etc/fstab
  # they seem to override the auto-generated hardware-configuration.nix
  swapDevices =
    [
      {
        label = "swap0";
        priority = 0;
        options =
          [
            "nofail"
            "discard"
          ];
      }
      {
        label = "swap1";
        priority = 0;
        options =
          [
            "nofail"
            "discard"
          ];
      }
    ];
}
