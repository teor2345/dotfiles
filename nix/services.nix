{ config, lib, pkgs, ... }:

{
  # TODO: get the emacs server working for dev
  #services.emacs.enable = true;
  #services.emacs.defaultEditor = true;
  #services.emacs.package = emacs-nox-with-use-package;

  # Enable OpenSSH and mosh
  services.openssh.enable = true;
  programs.mosh.enable = true;
  programs.mosh.withUtempter = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;

    # maybe later?
    #enableNvidia = false;

    liveRestore = true;
    storageDriver = "zfs";
    autoPrune.enable = true;
  };

  services.cron = {
    enable = true;
    systemCronJobs = [
      # monitor boot RAID disk array status
      "8   * * * * root /root/bin/disk-monitor-mdadm"
      # update Duck DNS dynamic IP for remote access
      "*/5 * * * * root /root/bin/duck-dns.sh >/dev/null 2>&1"
    ];
  };

  # Automatically enable Duck DNS dynamic IP for remote access
  #services.ddclient = {
  #  enable = true;
  #  protocol = "duckdns";
  #  #server = "www.duckdns.org";
  #
  #  # use the IP address the update request is from
  #  use = "ip=''";
  #  # use the IP address returned over insecure HTTP from checkip.dyndns.com
  #  # fails with a bad gateway error, but works from Firefox on macOS
  #  #use = "web, web=checkip.dyndns.com/, web-skip='Current IP Address: '";
  #
  #  username = "teor2345@github";
  #  password = "716501fd-d686-4c69-a725-80a15c353a24";
  #  domains = [
  #    "isle-erratic"
  #  ];
  #};

  # enable firmware updates
  # 2021-01-11: requires cairo-xlib, even when X Windows is turned off
  #services.fwupd.enable = true;

  # Disable the X11 windowing system
  environment.noXlibs = true;
  services.xserver.enable = false;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable coredump post-processing
  systemd.coredump.enable = true;
  systemd.coredump.extraConfig = ''
Storage=external
# The filesystem is already compressed
Compress=no
ProcessSizeMax=24G
ExternalSizeMax=24G
JournalSizeMax=1M
MaxUse=64G
KeepFree=48G
  '';

  # Enable logrotate
  services.logrotate.enable = true;
  services.logrotate.settings = {
    zcashd-mainnet = {
      files = "/home/dev/.zcash/*.log";
      frequency = "daily";
      rotate = 10;
      dateext = "";
      # As of 4.0.0, zcashd no longer re-opens debug.log on SIGHUP
      copytruncate = "";
    };

    zcashd-testnet = {
      files = "/home/dev/.zcash-testnet/testnet3/*.log";
      frequency = "daily";
      rotate = "10";
      dateext = "";
      copytruncate = "";
    };

    zebra = {
      files = "/home/dev/.cache/zebra-log/*.log";
      frequency = "monthly";
      rotate = "6";
      dateext = "";
      copytruncate = "";
    };
  };

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Zcash mining
  services.redis.servers.s-nomp = {
    enable = true;

    bind = "127.0.0.1";
    port = 6379;

    appendOnly = true;

    #openFirewall = true;
    #extraParams = ["--help"];
    #settings = { loadmodule = [ ... ]; };
  };
}
