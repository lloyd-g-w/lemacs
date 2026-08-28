# lemacs

Personal Emacs configuration, packaged as a Nix flake (layout inspired by
[lim2](https://github.com/lloyd-g-w/lim2)).

No config yet — this repo currently only wires up the Nix packaging and a
file layout to fill in.

## Usage

```
nix run github:lloyd-g-w/lemacs
nix build .#emacs
nix develop
```

## extraPackages

Edit the list in `emacs.nix`:

```nix
extraPackages = with pkgs; [
  ripgrep
  fd
];
```

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
    options.el
    keymaps.el
    autocmds.el
  plugins.el          # aggregates lisp/plugins/*.el
  plugins/            # empty for now — add topic files here
```
