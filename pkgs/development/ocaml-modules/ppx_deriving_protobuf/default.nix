{
  lib, buildOcaml, fetchurl,
  cppo, ppx_deriving, topkg,
}:

buildOcaml rec {
  name = "ppx_deriving_protobuf";
  version = "2.6";

  propagatedBuildInputs = [ cppo ppx_deriving ];

  minimumSupportedOcamlVersion = "4.02";

  inherit (topkg) installPhase;

  src = fetchurl {
    url = "https://github.com/ocaml-ppx/${name}/archive/v${version}.tar.gz";
    sha256 = "16vg1h5wsy09gh160k1371bz0kvzawdqv8df2affzckprpsalc20";
  };

  meta = with lib; {
    homepage = https://github.com/ocaml-ppx/ppx_deriving_protobuf;
    description = "A Protocol Buffers codec generator for OCaml";
    license = licenses.mit;
  };
}
