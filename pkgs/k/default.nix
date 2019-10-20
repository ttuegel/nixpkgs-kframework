{
  lib, fetchgit, fetchurl, writeText,

  # Parent should use callPackage to import mavenix
  mavenix,

  makeWrapper,

  flex, gcc, git, gmp, jdk, mpfr, pkgconfig, python3, ocamlPackages, z3
}:

let
  inherit (ocamlPackages)
    ocaml findlib mlgmp uuidm zarith;
in

let
  # PATH used at runtime
  binPath =
    lib.makeBinPath [
      flex gcc gmp jdk mpfr pkgconfig python3 z3
      # OCaml packages
      ocaml findlib
    ];

  /*
    Update with:
    ```.sh
      nix-prefetch-git https://github.com/kframework/k >./src.json
    ```
   */
  srcJSON = lib.importJSON ./src.json;

  inherit (lib.importJSON ./name.json) pname tag;

  src = fetchgit {
    inherit (srcJSON) url rev sha256 fetchSubmodules;
  };

in

mavenix.buildMaven {
  name = "${pname}-${tag}";
  inherit src;
  infoFile =
    let roundtrip = file: builtins.toJSON (lib.importJSON file); in
    writeText "mavenix.lock" (roundtrip ./mavenix.lock);
  doCheck = false;

  # Add build dependencies
  #
  buildInputs = [
    git makeWrapper
  ];

  propagatedBuildInputs = [
    flex gcc gmp jdk mpfr pkgconfig python3 z3

    # OCaml packages
    ocaml
    findlib  # Setup hook sets OCAMLPATH
    mlgmp
    uuidm
    zarith
  ];

  # Set build environment variables
  #
  MAVEN_OPTS = [
    "-DskipTests=true"
    "-DskipKTest=true"
    "-Dllvm.backend.skip=true"
    "-Dhaskell.backend.skip=true"
  ];

  # Attributes are passed to the underlying `stdenv.mkDerivation`, so build
  #   hooks can be set here also.
  #
  postPatch = ''
    patchShebangs k-distribution/src/main/scripts/bin
    patchShebangs k-distribution/src/main/scripts/lib
  '';

  postInstall = ''
    cp -r k-distribution/target/release/k/{bin,include,lib} $out/

    rm "$out/bin/k-configure-opam"
    rm "$out/bin/k-configure-opam-dev"
    rm "$out/bin/kserver-opam"
    rm -fr "$out/lib/opam"

    for prog in $out/bin/*; do
      wrapProgram $prog \
        --prefix PATH : ${binPath} \
        --prefix OCAMLPATH : "''${OCAMLPATH:?}"
    done
  '';

  passthru = {
    patches =
      let opam = "k-distribution/src/main/scripts/lib/opam";
      in {
        mlgmp = [
          "${src}/${opam}/packages/mlgmp/mlgmp.20150824/files/patchfile"
        ];
        ocaml = [
          "${src}/${opam}/compilers/4.06.1/4.06.1+k/files/opam-compiler.patch"
        ];
      };
  };

  # Add extra maven dependencies which might not have been picked up
  #   automatically
  #
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

  # Add dependencies on other mavenix derivations
  #
  #drvs = [ (import ../other/mavenix/derivation {}) ];

  # Override which maven package to build with
  #
  #maven = maven.override { jdk = pkgs.oraclejdk10; };

  # Override remote repository URLs and settings.xml
  #
  #remotes = { central = "https://repo.maven.apache.org/maven2"; };
  #settings = ./settings.xml;
}
