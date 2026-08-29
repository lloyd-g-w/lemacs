{
  description = "lemacs!";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      # System-independent outputs.
      flake = {
        homeManagerModules.default = ./home-manager.nix;
      };

      # System-dependent outputs.
      perSystem = {pkgs, ...}: let
        emacs = import ./emacs.nix {inherit pkgs;};
      in {
        # `nix build` / consumed as a package.
        packages.default = emacs;
        packages.emacs = emacs;
        # Everything-included variant: full LSP/formatter toolchain on
        # PATH (>10GB of store paths — opt-in for a reason).
        packages.emacs-full = import ./emacs.nix {
          inherit pkgs;
          fullToolchain = true;
        };

        # `nix run` starts Emacs with the config applied.
        apps.default = {
          type = "app";
          program = "${emacs}/bin/emacs";
        };

        # `nix develop` drops you into a shell with the configured Emacs.
        devShells.default = pkgs.mkShell {
          packages = [emacs];
        };
      };
    };
}
