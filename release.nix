let
  sources = import ./nix/sources.nix;
  overlay = _: pkgs: { niv = import sources."niv" {}; };
  nixpkgs = import sources."nixpkgs" { overlays = [ overlay (import ./.) ]; config = {}; };
in

# The set of all packages provided by this overlay, for testing purposes; does
# not include transitive dependencies provided by Nixpkgs, which should be
# tested upstream.
{
  inherit (nixpkgs) niv mvnix secp256k1 z3;
  kframework = { inherit (nixpkgs.kframework) k; };
  ocamlPackages_4_06_k = nixpkgs.recurseIntoAttrs {
    inherit (nixpkgs.ocamlPackages_4_06_k)
      base bn128 configurator findlib mlgmp ocaml ocaml-protoc
      ppx_deriving_protobuf secp256k1 stdio uuidm zarith;
  };
}
