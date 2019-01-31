args:

let
  inherit (import <nixpkgs> {}) pkgs;
in

pkgs.callPackage ./. {
  mavenix = pkgs.callPackage ./mavenix.nix {};
}
