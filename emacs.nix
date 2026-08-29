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

    # copilot.el runs its bundled language server with `node`.
    nodejs

    # treesit-auto compiles tree-sitter grammars at runtime; needs a C
    # compiler on PATH.
    gcc

    nixd
    lua-language-server
    texlab
    basedpyright
    typescript-language-server
    svelte-language-server
    csharp-ls
    cmake-language-server
    tailwindcss-language-server
    tinymist
    rust-analyzer
    zls
    haskell-language-server
    ocaml
    ocamlPackages.ocaml-lsp
    jdt-language-server

    # clang-tools also bundles clangd, but (as in lim2) it's only used
    # here for clang-format — a separately-installed clangd resolves
    # stdlib headers more reliably as an LSP source.
    clang-tools

    tex-fmt
    rustfmt
    markdownlint-cli
    alejandra
    yq-go
    black
    jq
    stylua
    astyle
    prettier
    ocamlPackages.ocamlformat
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
