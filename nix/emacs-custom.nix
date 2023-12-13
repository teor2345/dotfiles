{ config, pkgs, lib, options, ... }:

let
  emacsOverlay = (import ./emacs-overlay);
  nixpkgs = (import <nixpkgs> { overlays = [ emacsOverlay ]; });
in
{
  # create a custom emacs-nox with packages
  nixpkgs.config = {
    packageOverrides = pkgs: with pkgs; {
      emacs-nox-basic-config = nixpkgs.emacsWithPackagesFromUsePackage {
        # Your Emacs config file. Org mode babel files are also
        # supported.
        # NB: Config files cannot contain unicode characters, since
        #     they're being parsed in nix, which lacks unicode
        #     support.
        # config = ./emacs.org;

        # Warning:
        # NixOS doesn't pick up changes in this config file automatically
        # Change the package list below to add new packages
        config = /root/.emacs;

        # Package is optional, defaults to pkgs.emacs
        package = nixpkgs.emacsUnstable-nox;

        # By default emacsWithPackagesFromUsePackage will only pull in
        # packages with `:ensure`, `:ensure t` or `:ensure <package name>`.
        # Setting `alwaysEnsure` to `true` emulates `use-package-always-ensure`
        # and pulls in all use-package references not explicitly disabled via
        # `:ensure nil` or `:disabled`.
        # Note that this is NOT recommended unless you've actually set
        # `use-package-always-ensure` to `t` in your config.
        alwaysEnsure = true;

        # Optionally provide extra packages not in the configuration file.
        extraEmacsPackages = epkgs: with epkgs; [
          use-package
          system-packages
          use-package-ensure-system-package
          auto-package-update
          restart-emacs

          which-key

          unicode-whitespace
          ws-butler

          # dev packages
          rust-mode

          lsp-mode
          lsp-ui
          lsp-treemacs
          lv

          flycheck
          flycheck-rust
          flycheck-inline

          company
          company-lsp
          yasnippet-classic-snippets
        ];

        # Optionally override derivations.
        #override = epkgs: epkgs // {
        #  weechat = epkgs.melpaPackages.weechat.overrideAttrs(old: {
        #    patches = [ ./weechat-el.patch ];
        #  });
        #};

        # For Org mode babel files, by default only code blocks with
        # `:tangle yes` are considered. Setting `alwaysTangle` to `true`
        # will include all code blocks missing the `:tangle` argument,
        # defaulting it to `yes`.
        # Note that this is NOT recommended unless you have something like
        # `#+PROPERTY: header-args:emacs-lisp :tangle yes` in your config,
        # which defaults `:tangle` to `yes`.
        #alwaysTangle = true;
      };
    };
  };
}
