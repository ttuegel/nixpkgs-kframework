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
          (import ./pkgs/development/ocaml-modules
            {
              inherit (self) k secp256k1;
            }
          );
    in
      self.recurseIntoAttrs pkgs;

  secp256k1 = self.callPackage ./pkgs/development/libraries/secp256k1 {};
}
