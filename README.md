# nixpkgs-kframework

Nixpkgs overlay for [K Framework](https://github.com/kframework) packages.

This overlay provides Nix expressions for these packages:

- [K](http://www.kframework.org) 5
- OCaml 4.06.1+k


## Usage

### Standalone

To build standalone packages, select an attribute from `release.nix`:

```.sh
nix build -f release.nix kframework.k
```

To build all the packages this overlay provides (e.g. for testing):

```.sh
nix build -f release.nix
```

### As an overlay

The [Nixpkgs manual](https://nixos.org/nixpkgs/manual/#chap-overlays) describes
how to use overlays with your system or project configuration.

### Binary cache

A binary cache for the `x86_64-linux` platform is updated automatically.
Please see [ttuegel.cachix.org](https://ttuegel.cachix.org/) for instructions to use the cache.


## Notes

### Updating K

```.sh
# In ./pkgs/k,
./update.sh

# In ./,
./check.sh

# If the build fails,
nix build -f release.nix mvnix
./result/bin/mvnix-update -E '(import ./release.nix).kframework.k'
```
