{
  lib, buildOcaml, fetchurl,
  zarith,
}:

buildOcaml rec {
  name = "bn128";
  version = "0.1.3";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/runtimeverification/${name}-ml/archive/${version}.tar.gz";
    sha256 = "1xj7m5pjql7zymz6sbzpark99z27yfkim4q3in4zxnckc01zyz1g";
  };

  propagatedBuildInputs = [ zarith ];

  meta = with lib; {
    homepage = https://github.com/runtimeverification/bn128-ml;
    description = "BN 128 elliptic curve implementation in OCaml";
    license = licenses.mit;
  };
}
