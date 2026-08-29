# Emacs wrapped with whatever packages you list below on its PATH
# (LSP servers, ripgrep, formatters, ...). Edit the list directly.
#
# `bakeConfig` (default true): copy early-init.el/init.el/lisp into the
# Nix store and force Emacs to use it via `--init-directory`, producing
# a fully self-contained, portable emacs.
# This is what `nix run` / `nix build` / the devShell use.
#
# Home Manager passes bakeConfig = false and instead symlinks
# ~/.config/emacs straight from your live repo checkout, so edits apply
# instantly (no rebuild) — see home-manager.nix.
{
  pkgs,
  bakeConfig ? true,
}: let
  extraPackages = with pkgs; [
    ripgrep
    fd
    git

    # Uncomment / extend as the config grows, e.g.:
    # nixd
    # lua-language-server
  ];

  # early-init.el + init.el + lisp/ only — this is what gets pointed
  # at by --init-directory so `load`/`require` can find lisp/config,
  # lisp/plugins, etc.
  configDir = pkgs.lib.fileset.toSource {
    root = ./.;
    fileset = pkgs.lib.fileset.unions [./early-init.el ./init.el ./lisp];
  };

  # Use native Wayland on compositors such as Niri instead of XWayland.
  base = pkgs.emacs-pgtk;
in
  pkgs.symlinkJoin {
    name = "emacs";
    paths = [base];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/emacs \
        --prefix PATH : ${pkgs.lib.makeBinPath extraPackages} \
        ${
        if bakeConfig
        then ''--add-flags "--init-directory=${configDir}"''
        else ""
      }
    '';
    # Exposed so home-manager.nix can also install these into the user
    # profile (usable from any terminal), not just on emacs' wrapped PATH.
    passthru = {inherit extraPackages;};
    meta.mainProgram = "emacs";
  }
