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
  hostPATH =
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

  version = "5.0.0-${lib.substring 0 8 tag}";

in

mavenix.buildMaven {
  name = "${pname}-${version}";
  inherit pname version;
  inherit src;
  infoFile = ./mavenix.lock;
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
        --prefix PATH : ${hostPATH} \
        --prefix OCAMLPATH : "''${OCAMLPATH:?}"
    done
  '';

  passthru = {
    patches = {
      mlgmp = [
        (let inherit (lib.importJSON ./mlgmp.patch.json) file rev sha256; in
          fetchurl {
            url = "https://raw.githubusercontent.com/kframework/k/${rev}/${file}";
            inherit sha256;
          }
        )
      ];
      ocaml = [
        (let inherit (lib.importJSON ./ocaml.patch.json) file rev sha256; in
          fetchurl {
            url = "https://raw.githubusercontent.com/kframework/k/${rev}/${file}";
            inherit sha256;
          }
        )
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
