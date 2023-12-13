{ config, lib, pkgs, ... }:

{
  boot = {
    supportedFilesystems = [ "zfs" ];

    # Recommended by cargo-watch
    kernel = {
      sysctl = {
        "fs.inotify.max_user_watches" = 524288;
      };
    };

    loader = {
      # Use grub
      grub = {
        # Optional TODO:
        # - stop using the RAID boot drive
        # - replace with boot.loader.grub.mirroredBoots which copies to each drive
        # - rebuilds will require an explicit nixos update, rather than a RAID sync
        devices = [
          # disk 1
          "/dev/disk/by-id/nvme-CT4000P3PSSD8_2242E67C4B28"
          # disk 0
          "/dev/disk/by-id/nvme-CT4000P3PSSD8_2236E6628157"
          # slow
          "/dev/disk/by-id/ata-Samsung_SSD_860_QVO_4TB_S4CXNF0N206602W"
        ];

        # avoid "too many links" errors
        copyKernels = true;

        # avoid a large number of entries, but still keep multiple kernels
        configurationLimit = 50;
      };

      # make /boot independent of /nix/store
      generationsDir.copyKernels = true;

      # Use the systemd-boot EFI boot loader
      #systemd-boot.enable = true;
      #systemd-boot.configurationLimit = 100;
      #efi.canTouchEfiVariables = true;
    };

    kernelParams = [
      # disable the Linux I/O elevator - outdated kernel option?
      #"elevator=none"
      # default is 50% of RAM, which should be fine
      #"zfs.zfs_arc_max=68719476736"
    ];
  };
}
