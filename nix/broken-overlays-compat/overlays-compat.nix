{ config, lib, pkgs, options, ... }:

let
  emacsOverlay = (import ./emacs-overlay);
in
{
  nixpkgs.overlays = [
    emacsOverlay
  ];

  # Without any `nix.nixPath` entry:
  nix.nixPath =
    # Prepend default nixPath values.
    options.nix.nixPath.default ++
    # Append our nixpkgs-overlays.
    [
      "nixpkgs-overlays=/etc/nixos/overlays-compat/"
    ];
}
