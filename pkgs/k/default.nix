{
  lib, fetchzip,

  # Parent should use callPackage to import mavenix
  mavenix,

  makeWrapper,

  flex, git, gmp, mpfr, pkgconfig, python3, opam, ocaml, ocamlPackages, z3
}:

let
  # PATH used at runtime
  binPath =
    lib.makeBinPath [
      flex z3 gmp mpfr pkgconfig python3 opam ocaml ocamlPackages.findlib
    ];

  /*
    Update with:
    ```.sh
      nix-prefetch-git https://github.com/kframework/k >./src.json
    ```
   */
  src = lib.importJSON ./src.json;
  # Abbreviated Git revision
  shortRev = lib.substring 0 7 src.rev;

  drvs =
    mavenix {
      name = "k-1.0-${shortRev}";
      src = fetchzip {
        url = src.url + "/archive/${src.rev}.tar.gz";
        inherit (src) sha256;
      };

      infoFile = ./mavenix-info.json;

      remotes = {
        central = "https://repo.maven.apache.org/maven2";
        "runtime.verification" =
          "https://s3.amazonaws.com/repo.runtime.verification/repository/internal";
        "runtime.verification.snapshots" =
          "https://s3.amazonaws.com/repo.runtime.verification/repository/snapshots";
      };

      # Run mvnix-update after updating:
      deps = [
        {
          path = "org/scala-lang/scala-compiler/2.12.4/scala-compiler-2.12.4.jar";
          sha1 = "s0xw0c4d71qh8jgy1jipy385jzihx766";
        }
        {
          path = "org/scala-lang/scala-compiler/2.12.4/scala-compiler-2.12.4.pom";
          sha1 = "nx34986x5284ggylf3bg8yd36hilsn5i";
        }
      ];

      buildInputs = [ git makeWrapper ];

      doCheck = false;

      postPatch = ''
        patchShebangs k-distribution/src/main/scripts/bin
        patchShebangs k-distribution/src/main/scripts/lib
      '';

      postInstall = ''
        cp -r k-distribution/target/release/k/{bin,include,lib} $out/

        for prog in $out/bin/*; do
          wrapProgram $prog \
            --prefix PATH : ${binPath}
        done
      '';

      # settings = ./settings.xml;
      # drvs = [ ];
      # maven = maven.override { jdk = oraclejdk10; };
    };
in

drvs.build
