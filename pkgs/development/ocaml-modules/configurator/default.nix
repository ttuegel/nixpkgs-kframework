{
  lib, buildOcaml, fetchurl,
  base, dune, stdio,
}:

buildOcaml rec {
  name = "configurator";
  version = "0.11.0";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/janestreet/${name}/archive/v${version}.tar.gz";
    sha256 = "0xkhprm35adaq10crpfs6d646qrv9qrr7iwilvk55g471y1lndjf";
  };

  nativeBuildInputs = [ dune ];
  propagatedBuildInputs = [ base stdio ];

  buildPhase = ''
    runHook preBuild

    dune build -p configurator

    runHook postBuild
  '';

  inherit (dune) installPhase;

  meta = with lib; {
    homepage = https://github.com/janestreet/stdio;
    description = "Standard IO Library for OCaml";
    license = licenses.mit;
  };
}
