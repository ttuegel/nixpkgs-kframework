self: super:

{
  k = self.callPackage ./pkgs/k {
    mavenix = self.callPackage ./pkgs/k/mavenix.nix {};
    ocamlPackages = self.ocamlPackages_4_06_k;
  };

  ocamlPackages_4_06_k =
    let
      inherit (self) k;
      pkgs =
        self.ocaml-ng.mkOcamlPackages
          (self.callPackage
            (import ./pkgs/development/compilers/ocaml/4.06.nix
              {
                flavor = "+k";
                patches = k.patches.ocaml;
              }
            )
            {
              useX11 = false;
            }
          )
          (self: super:
            {
              mlgmp = (self.callPackage ./pkgs/development/ocaml-modules/mlgmp {}).overrideAttrs (attrs: {
                patches = k.patches.mlgmp;
              });
            }
          );
    in
      self.recurseIntoAttrs pkgs;

  secp256k1 = self.callPackage ./pkgs/development/libraries/secp256k1 {};
}
