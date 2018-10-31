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
  inherit (pkgs) k;
  ocamlPackages_4_06_k = pkgs.recurseIntoAttrs {
    inherit (pkgs.ocamlPackages_4_06_k) ocaml mlgmp;
  };
}
