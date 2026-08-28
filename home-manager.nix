{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.lemacs;
in {
  options.programs.lemacs = {
    enable = lib.mkEnableOption "lemacs! emacs config";

    repo = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "/home/lloyd/projects/lemacs";
      description = ''
        Absolute path to a local checkout of the lemacs repo. When set,
        ~/.config/emacs is symlinked to this directory (not copied into
        the Nix store), so editing early-init.el/init.el/lisp/**/*.el
        takes effect the next time you open Emacs — or immediately with
        eval-buffer / restart — no rebuild needed.

        When null (the default), the config baked into this flake is
        used instead (fetched from GitHub, same as any other flake
        input) — works out of the box, but no live reload.
      '';
    };
  };

  config = lib.mkIf cfg.enable (let
    emacs = import ./emacs.nix {inherit pkgs; bakeConfig = cfg.repo == null;};
  in {
    # Install emacs' CLI tools (LSPs, formatters, ripgrep, ...) into the
    # profile too, so they're runnable from any terminal, not only from
    # inside Emacs.
    home.packages = [emacs] ++ emacs.extraPackages;

    xdg.configFile."emacs".source = lib.mkIf (cfg.repo != null)
      (config.lib.file.mkOutOfStoreSymlink cfg.repo);
  });
}
