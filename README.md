# nixpkgs-kframework

Nixpkgs overlay for K Framework packages


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
