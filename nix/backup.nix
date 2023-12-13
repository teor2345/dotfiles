{ config, lib, pkgs, ... }:

{
  boot.zfs.extraPools = [
    "backup-pool"
  ];

  services.sanoid = {
    enable = true;
    # every 15 minutes
    interval = "*:00/15";

    datasets."root-pool/system" = {
      recursive = "zfs";
      hourly = 36;
      daily = 14;
      monthly = 8;
      yearly = 1;
    };

    datasets."root-pool/user" = {
      recursive = "zfs";

      # Every 15 minutes for the last 6 hours
      frequent_period = 15;
	    frequently = 32;

      hourly = 36;
      daily = 14;
      monthly = 3;
      yearly = 0;
    };

    # keep data snapshots, but don't back them up using syncoid
    # (we don't have the space, because the data and backup drives are both 4 TB)
    datasets."data-pool" = {
      recursive = "zfs";

      # Every 15 minutes for the last 6 hours
      frequent_period = 15;
	    frequently = 32;

      hourly = 36;
      daily = 7;
      monthly = 0;
      yearly = 0;
    };
  };

  services.syncoid = {
    enable = true;
    # in between sanoid, which runs every 15 minutes
    # sometimes sanoid can take a minute or two
    interval = "*:07";
    commonArgs = [
      # Use the sanoid snapshots (and any other available snapshots)
      "--no-sync-snap"
      # We use compressed blocks instead
      #"--compress=zstd-fast"
    ];

    commands."root-pool/system" = {
      recursive = true;
      target = "backup-pool/system";
      # compressed replicate large-block embed
      sendOptions = "cRLe";
      recvOptions = "u";
    };

    commands."root-pool/user" = {
      recursive = true;
      target = "backup-pool/user";
      sendOptions = "cRLe";
      recvOptions = "u";
    };
  };
}
