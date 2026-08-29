# lemacs

Personal Emacs configuration, packaged as a Nix flake (layout inspired by
[lim2](https://github.com/lloyd-g-w/lim2)).

Evil-mode + a SPC leader, parity-driven port of [lim2](https://github.com/lloyd-g-w/lim2)
(a sibling Neovim config): same LSP/completion/git/UI shape, idiomatic Emacs packages
underneath.

## Usage

```
nix run github:lloyd-g-w/lemacs
nix build .#emacs
nix develop
```

## extraPackages

Edit the list in `emacs.nix` — ripgrep/fd/git plus LSP servers, formatters, `gcc` (for
treesit-auto grammar compilation), and `nodejs` (for copilot.el's language server).

## Home Manager

```nix
imports = [ inputs.lemacs.homeManagerModules.default ];
programs.lemacs.enable = true;
```

### Params

- `enable` (bool, default `false`)
- `repo` (string | null, default `null`) — absolute path to a local checkout.
  When set, `~/.config/emacs` is symlinked to that checkout instead of copying
  it into the store, so edits apply without a rebuild.

## Layout

```
early-init.el       # runs before package.el / UI init
init.el              # entry point, requires config and plugins
lisp/
  config.el           # aggregates lisp/config/*.el
  config/
    packages.el         # package.el + use-package bootstrap
    options.el
    keymaps.el
    autocmds.el
  plugins.el          # aggregates lisp/plugins/*.el, load order matters
  plugins/
    evil-config.el      # evil-mode + lemacs-leader-map (SPC)
    theme.el             # atom-one-dark
    lemacs-completion.el # corfu/vertico/consult stack
    lemacs-search.el     # project/file/grep finders
    lemacs-lsp.el        # eglot + language servers
    lemacs-snippets.el   # yasnippet
    lemacs-ui.el         # doom-modeline, dashboard, hl-todo, diff-hl, ...
    lemacs-misc.el       # magit, avy, dired, gptel/copilot, ...
```

Files under `lisp/plugins/` other than `evil-config`/`theme` are prefixed `lemacs-` so
their `provide`d feature names can't collide with built-ins like `misc.el`.

## lim2 → lemacs plugin parity

| lim2 (Neovim)       | lemacs (Emacs)          |
| -------------------- | ----------------------- |
| eglot n/a (native LSP client either side) | eglot |
| blink.cmp            | corfu |
| telescope.nvim       | vertico + consult |
| conform.nvim         | apheleia |
| LuaSnip              | yasnippet |
| lazygit / snacks.lazygit | magit |
| flash.nvim           | avy |
| oil.nvim             | dired (+ wdired) |
| lualine.nvim         | doom-modeline |
| alpha-nvim           | dashboard |
| todo-comments.nvim   | hl-todo |
| mini.diff / gitsigns | diff-hl |
| nvim-treesitter      | treesit + treesit-auto |
| avante.nvim          | gptel |
| copilot.lua          | copilot.el |

## Leader keys

`SPC` is the leader (`lemacs-leader-map`, defined in `evil-config.el`) in evil normal/
visual state, with named prefixes `c` Code, `d` Diagnostics, `f` Find, `g` Git — mirroring
lim2's which-key groups. Notable binds: `SPC g g` magit-status, `SPC f e` dired-jump (oil
parity); see individual `lisp/plugins/*.el` files for the full set.
