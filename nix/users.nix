{ config, lib, pkgs, ... }:

{
  users = {
    # rebuilds will delete manually added users unless mutable=true
    mutableUsers = false;

    enforceIdUniqueness = true;

    users = {

      root = {
        isNormalUser = false;
        # Create or set permissions for home
        createHome = true;

        extraGroups = [
          "docker"
          "users"
        ];

        # login locally without a password
        hashedPassword = "";

        # Same keys for all users
        openssh.authorizedKeys.keyFiles = [
          ./ssh_public_keys/yubikey-0.txt
          ./ssh_public_keys/yubikey-1.txt
          ./ssh_public_keys/yubikey-2.txt
        ];
      };

      dev = {
        isNormalUser = true;
        createHome = true;

        extraGroups = [
          "docker"
        ];

        # login locally without a password
        hashedPassword = "";

        openssh.authorizedKeys.keyFiles = [
          ./ssh_public_keys/yubikey-0.txt
          ./ssh_public_keys/yubikey-1.txt
          ./ssh_public_keys/yubikey-2.txt
        ];
      };
    };
  };

  home-manager = {
    # make Home Manager a bit more efficient
    useUserPackages = true;
    useGlobalPkgs = true;

    # missing the rycee/nmd GitHub repository as of 2021-01-22
    #users.dev = {
    #  home.packages = [ pkgs.tmux ];
    #
    #  programs.tmux = {
    #    enable = true;
    #    clock24 = true;
    #    plugins = with pkgs.tmuxPlugins; [
    #      continuum
    #      logging
    #      sensible
    #    ];
    #
    #    extraConfig = ''
    #      set -g mouse on
    #    '';
    #  };
    #};
  };
}
