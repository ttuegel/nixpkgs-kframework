{
  lib, buildOcaml, fetchurl,
  base, configurator, dune, secp256k1, stdio,
}:

buildOcaml rec {
  name = "secp256k1";
  version = "0.3.2";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/dakk/${name}-ml/archive/${version}.tar.gz";
    sha256 = "1p877pcr9cb8hm7bakxvwmpskwc080nxvbndf3k84wvh0mj1kd67";
  };

  nativeBuildInputs = [ dune ];
  propagatedBuildInputs = [ base configurator secp256k1 stdio ];

  buildPhase = ''
    runHook preBuild

    dune build -p secp256k1

    runHook postBuild
  '';

  inherit (dune) installPhase;

  meta = with lib; {
    homepage = https://github.com/dakk/secp256k1-ml;
    description = "Elliptic curve library secp256k1 wrapper for OCaml";
    license = licenses.mit;
  };
}
