self: super:

{
  k = self.callPackage ./pkgs/k {
    mavenix = self.callPackage ./pkgs/k/mavenix.nix {};
  };

  ocamlPackages =
    let
      pkgs =
        self.ocaml-ng.mkOcamlPackages
          (self.callPackage
            (import ./pkgs/development/compilers/ocaml/4.06.nix
              {
                flavor = "+k";
                patches = self.k.ocamlPatches."4.06.1";
              }
            )
            {}
          )
          (self: super: {});
    in
      self.recurseIntoAttrs pkgs;
}
