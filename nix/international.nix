{ config, lib, pkgs, ... }:

{
  # Internationalisation properties
  i18n.defaultLocale = "en_AU.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Set your time zone.
  time.timeZone = "Australia/Brisbane";
}
