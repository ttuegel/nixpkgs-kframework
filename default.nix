self: super:

{
  haskell = super.haskell // {
    packages = super.haskell.packages // {
      stackage =
        super.callPackage ./pkgs/development/haskell-modules/stackage {};
    };
  };

  callMavenPackage = path: extraArgs:
    let
      mavenix =
        let
          inherit (self) lib;
          name = baseNameOf path;
          isNix = lib.hasSuffix ".nix" path;
          dir = if isNix then dirOf path else path;
        in
          self.callPackage (dir + "/mavenix.nix") {};
      args = extraArgs // { inherit mavenix; };
      drvs = self.callPackage path args;
    in
      drvs.build;

  k = self.callMavenPackage ./pkgs/k {
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
