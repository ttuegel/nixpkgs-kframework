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

{
  inherit (pkgs)
    k ocamlPackages;
}
