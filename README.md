# nixpkgs-kframework

Nixpkgs overlay for K Framework packages


## Usage

### Standalone

To build standalone packages, or to test the overlay against the pinned version
of Nixpkgs, build from `release.nix`:

```.sh
nix-build release.nix -A k
```

### As an overlay

The [Nixpkgs manual](https://nixos.org/nixpkgs/manual/#chap-overlays) describes
how to use overlays with your system or project configuration.
