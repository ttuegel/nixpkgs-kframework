self: super:

{
  k = self.callPackage ./pkgs/k {
    mavenix = self.callPackage ./pkgs/k/mavenix.nix {};
  };

  ocamlPackages =
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
            {}
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
}
