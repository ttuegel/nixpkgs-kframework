self: super:

let
  sources = import ./nix/sources.nix;
in

{
  mavenix = import sources."mavenix" { pkgs = self; };

  mvnix = self.mavenix.cli;

  kframework = {
    k = import ./pkgs/kframework/k {
      inherit (self) lib fetchurl fetchgit writeText;
      inherit (self) makeWrapper;
      inherit (self) flex gcc git gmp jdk mpfr pkgconfig python3 z3;
      ocamlPackages = self.ocamlPackages_4_06_k;
      inherit (self) mavenix;
    };

    llvm-backend = self.callPackage ./pkgs/kframework/llvm-backend {
      llvmPackages = self.llvmPackages_9;
    };
  };

  ocamlPackages_4_06_k =
    let
      ocaml =
        self.callPackage
          (import ./pkgs/development/compilers/ocaml/4.06.nix
            {
              flavor = "+k";
              patches = self.kframework.k.patches.ocaml;
            }
          )
          {
            useX11 = false;
            xproto = self.xorg.xorgproto;
          };
      addOcamlCompiler = _: _: { inherit ocaml; };
      ocamlPackages_4_06_k =
        self.ocaml-ng.ocamlPackages_4_06.overrideScope' addOcamlCompiler;
      addOcamlModules =
        import ./pkgs/development/ocaml-modules {
          inherit (self.kframework) k;
          inherit (self) secp256k1;
        };
    in
      ocamlPackages_4_06_k.overrideScope' addOcamlModules;

  secp256k1 = self.callPackage ./pkgs/development/libraries/secp256k1 {};
}
