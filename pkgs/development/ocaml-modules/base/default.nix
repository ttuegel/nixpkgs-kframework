{
  lib, buildOcaml, fetchurl,
  dune, sexplib,
}:

buildOcaml rec {
  name = "base";
  version = "0.11.1";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/janestreet/${name}/archive/v${version}.tar.gz";
    sha256 = "1v40iy751y5jphyim2j197mr5yw3j6m08dm3gphm3igm2pgsqmc5";
  };

  nativeBuildInputs = [ dune ];
  propagatedBuildInputs = [ sexplib ];

  buildPhase = ''
    runHook preBuild

    dune build -p base

    runHook postBuild
  '';

  inherit (dune) installPhase;

  meta = with lib; {
    homepage = https://github.com/janestreet/base;
    description = "Elliptic curve library secp256k1 wrapper for Ocaml";
    license = licenses.mit;
  };
}
