{
  lib, buildOcaml, fetchurl,
  base, dune,
}:

buildOcaml rec {
  name = "stdio";
  version = "0.11.0";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/janestreet/${name}/archive/v${version}.tar.gz";
    sha256 = "1a10iaa4xg95dyg3dvacicvzalmhgalhn7hi17hrm32nk3g381lf";
  };

  nativeBuildInputs = [ dune ];
  propagatedBuildInputs = [ base ];

  buildPhase = ''
    runHook preBuild

    dune build -p stdio

    runHook postBuild
  '';

  inherit (dune) installPhase;

  meta = with lib; {
    homepage = https://github.com/janestreet/stdio;
    description = "Standard IO Library for OCaml";
    license = licenses.mit;
  };
}
