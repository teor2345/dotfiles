{ config, pkgs, ... }:

{
  imports =
    [
      # the results of the hardware scan
      ./hardware-configuration.nix

      # general perf tweaks
      ./nixos-hardware/common/pc/ssd/default.nix
      ./nixos-hardware/common/cpu/intel/default.nix
      ./nixos-hardware/common/gpu/nvidia.nix

      ./boot.nix
      ./perf.nix
      ./backup.nix

      ./net.nix
      ./wifi_private_keys.nix

      ./packages.nix
      ./services.nix
      ./international.nix

      <home-manager/nixos>
      ./users.nix
      # which uses:
      #./ssh_public_keys/*
    ];

  # Requires Xlibs
  # Use NVIDIA drivers
  #nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03";
}
