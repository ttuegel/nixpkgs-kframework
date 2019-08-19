# nixpkgs-kframework

Nixpkgs overlay for [K Framework](https://github.com/kframework) packages.

This overlay provides Nix expressions for these packages:

- [K](http://www.kframework.org) 5
- OCaml 4.06.1+k
- Z3 4.6.0
- Z3 4.8.4


## Usage

### Standalone

To build standalone packages, select an attribute from `release.nix`:

```.sh
nix build -f release.nix k
```

To build all the packages this overlay provides (e.g. for testing):

```.sh
nix build -f release.nix
```

### As an overlay

The [Nixpkgs manual](https://nixos.org/nixpkgs/manual/#chap-overlays) describes
how to use overlays with your system or project configuration.

## Notes

### Updating K

```.sh
# In ./pkgs/k,
./update.sh

# In ./,
./check.sh

# If the build fails,
nix build -f release.nix mvnix
./result/bin/mvnix-update -E '(import ./release.nix).k'
```
