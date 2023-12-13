{ config, lib, pkgs, ... }:

{
  # Doesn't work - uses 127.0.0.53 ???
  #services.resolved.enable = true;
  # disable exetel default
  #services.resolved.domains = [
  #    "local"
  #];
  # Just use the hard-coded set
  #services.resolved.fallbackDns = [
  #  # Cloudflare
  #  "1.1.1.1"
  #  "1.0.0.1"
  #  "2606:4700:4700::1111"
  #  "2606:4700:4700::1001"
  #];

  networking = {

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    firewall = {
      allowedTCPPorts = [
        # grafana
        3030
        # Zcash mining
        8080
        # Zebra metrics: mainnet, testnet
        9999
        19999
        # Zebra Zcash: mainnet, testnet
	      28233
	      38233
        # zcashd Zcash: mainnet, testnet
	      48233
	      58233

        # temporary Zebra metrics
        # (none)
      ];
    };

    hostName = "dev";
    hostId = "75c14cdd";

    defaultGateway = "192.168.215.1";

    # DNS
    nameservers = [
      "9.9.9.9"
      "192.168.215.1"
      "149.112.112.112"
      # servers after the third nameserver might be ignored
      "2620:fe::fe"
      "2620:fe::9"

      # Quad9 - no malware blocksing, but no DNSSEC either
      #"9.9.9.10"
      #"149.112.112.10"
      #"2620:fe::10"
      #"2620:fe::fe:10"

      # Exetel - do not use
		  #"220.233.0.4"
		  #"58.96.3.34"
		  #"220.233.0.3"
    ];

    resolvconf = {
      enable = true;

      # work around issues where only one address type is returned
      dnsSingleRequest = true;

      #extraConfig = "
      #   # disable exetel default
      #   domain_blacklist=exetel.com.au\n
      #   # use the local resolver as well as other nameservers\n
      #   # only useful with a working local resolver\n
      #   resolv_conf_local_only=YES\n
      #   ";
      #useLocalResolver = true;
    };
    # disable exetel default
    search = [
      "local"
    ];

    # leave interfaces up, even if the daemon shuts down
    dhcpcd.persistent = true;
    # The global useDHCP flag is deprecated, therefore explicitly set to false
    useDHCP = false;

    # Ethernet
    interfaces.eno1 = {
      # Fallback if the fixed address is not available,
      useDHCP = true;

      # Fixed address
      ipv4.addresses = [ {
        address = "192.168.215.111";
        prefixLength = 24;
      } ];
    };

    # Wi-Fi - seems unreliable
    #interfaces.wlp3s0 = {
    #  # Fallback if the fixed address is not available,
    #  # also get any extra settings that aren't configured here
    #  useDHCP = true;
    #
    #  # Fixed address
    #  ipv4.addresses = [ {
    #    address = "192.168.215.222";
    #    prefixLength = 24;
    #  } ];
    #};

    #wireless = {
    #  enable = true;
    #
    #  # the docs say it defaults to using all interfaces,
    #  # but that seems unreliable in practice
    #  interfaces = [
    #    "wlp3s0"
    #  ];
    #
    #  userControlled.enable = true;
    #  userControlled.group = "wheel";
    #
    #  # For networks, see wifi_private_keys.nix
    #};

    # Configure network proxy
    #proxy.default = "http://user:password@proxy:port/";
    #proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };
}
