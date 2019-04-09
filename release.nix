let
  src = builtins.fromJSON (builtins.readFile ./nixpkgs.json);
  nixpkgs = builtins.fetchTarball {
    url = src.url + "/archive/${src.rev}.tar.gz";
    inherit (src) sha256;
  };
  pkgs = import nixpkgs {
    overlays = [ (import ./.) ];
  };
in

# The set of all packages provided by this overlay, for testing purposes; does
# not include transitive dependencies provided by Nixpkgs, which should be
# tested upstream.
{
  inherit (pkgs) k mvnix secp256k1;
  haskellPackages = pkgs.haskell.packages.stackage.lts_12_21;
  ocamlPackages_4_06_k = pkgs.recurseIntoAttrs {
    inherit (pkgs.ocamlPackages_4_06_k)
      base bn128 configurator mlgmp ocaml ocaml-protoc ppx_deriving_protobuf
      secp256k1 stdio;
  };
}
