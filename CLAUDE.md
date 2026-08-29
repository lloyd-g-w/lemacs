# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`lemacs` is a personal Emacs configuration, packaged as a Nix flake. Layout is directly
inspired by [`lim2`](https://github.com/lloyd-g-w/lim2) (a sibling Neovim config repo) —
same flake shape, same `bakeConfig` toggle, same Home Manager module pattern, just for
Emacs instead of Neovim. There is no application build/test/lint pipeline — the "build" is
producing a working `emacs` binary, and the way to verify a change is to run it.

The config targets functional/keybind parity with `lim2`: evil-mode with a SPC leader,
eglot for LSP, corfu/vertico/consult for completion, magit/avy/dired for the
git/motion/filesystem trio lim2 covers with lazygit/flash.nvim/oil.nvim, etc. New config
goes under `lisp/config/*.el` and `lisp/plugins/*.el`, required from `lisp/config.el` /
`lisp/plugins.el` respectively.

## Commands

```
nix run github:lloyd-g-w/lemacs   # run emacs with this config, fetched from GitHub
nix build .#emacs                 # build the emacs package locally (./result/bin/emacs)
nix develop                       # devShell with the configured emacs on PATH
```

There is no separate lint/test/format command — Nix eval errors and Elisp errors (shown in
`*Messages*` / at startup) are the primary feedback loop. To sanity-check a change without a
full Nix rebuild, run `emacs --init-directory .` from the repo root.

## Architecture

- `early-init.el` — runs before `package.el` and the UI are initialized. Empty stub for now.
- `init.el` — entry point. Adds `lisp/`, `lisp/config/`, and `lisp/plugins/` to `load-path`,
  then `(require 'config)` and `(require 'plugins)`.
- `lisp/config.el` — aggregates `lisp/config/*.el`: `packages` (package.el +
  use-package bootstrap, `use-package-always-ensure t`, MELPA), `options`, `keymaps`,
  `autocmds`.
- `lisp/plugins.el` — aggregates `lisp/plugins/*.el`, in load-bearing order:
  `evil-config` → `theme` → `lemacs-completion` → `lemacs-search` → `lemacs-lsp` →
  `lemacs-snippets` → `lemacs-ui` → `lemacs-misc`, mirroring `lim2`'s `lua/plugins/*.lua`
  split. `evil-config.el` must load first: it enables `evil-mode` and defines
  `lemacs-leader-map` (bound to `SPC` in normal/visual state, with `c`/`d`/`f`/`g`
  prefixes for Code/Diagnostics/Find/Git), which every later module binds into via
  `(define-key lemacs-leader-map (kbd "g g") #'magit-status)` and friends. Files other
  than `evil-config`/`theme` are prefixed `lemacs-` (e.g. `lemacs-misc.el`, not
  `misc.el`) so their `provide`d feature names can't shadow Emacs's own built-in
  features of the same name.
- `emacs.nix` — wraps `pkgs.emacs` with `extraPackages` (LSP servers, formatters, ripgrep,
  etc.) on PATH via `makeWrapper`. Has a `bakeConfig` toggle:
  - `bakeConfig = true` (default; used by `nix run`/`nix build`/devShell): copies
    `early-init.el` + `init.el` + `lisp/` into the Nix store and forces Emacs to use it via
    `--init-directory=<store path>`, producing a fully self-contained/portable emacs.
  - `bakeConfig = false` (used by the Home Manager module): skips baking; Home Manager
    instead symlinks `~/.config/emacs` straight to the live repo checkout so edits apply
    without a rebuild.
- `flake.nix` — flake-parts based. Exposes `packages.default`/`packages.emacs` (the wrapped
  emacs), `apps.default` (runs it), `devShells.default`, and the system-independent
  `homeManagerModules.default` (from `home-manager.nix`).
- `home-manager.nix` — defines `programs.lemacs` (`enable`, `repo`) for consumers using Home
  Manager. When `repo` is set to an absolute path, `~/.config/emacs` is symlinked to that
  checkout (live-reload editing); when `repo` is null, the flake-baked config is installed
  instead (works out of the box, no live reload).

## Conventions

- Keep `extraPackages` in `emacs.nix` as the single place where CLI tools (LSP servers,
  formatters, `ripgrep`, etc.) are declared for the wrapped `emacs`.
- Elisp files should use standard header/footer comments (`;;; foo.el --- Description -*-
  lexical-binding: t; -*-` / `;;; foo.el ends here`) and `(provide 'foo)` at the end, matching
  the stub files already in `lisp/`.
- Because Elisp `require` resolves by filename (not directory + `init.el` the way Lua
  `require` does), aggregator files live at `lisp/config.el` / `lisp/plugins.el` (not
  `lisp/config/init.el`), with topic files inside the matching subdirectory.
