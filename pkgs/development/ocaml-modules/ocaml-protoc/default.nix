{
  lib, buildOcaml, fetchurl,
  ppx_deriving_protobuf,
}:

buildOcaml rec {
  name = "ocaml-protoc";
  version = "1.2.0";

  propagatedBuildInputs = [ ppx_deriving_protobuf ];

  minimumSupportedOcamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/mransan/${name}/archive/${version}.tar.gz";
    sha256 = "0wnznk89ax1ja1f7f7gjbxhvwlxg0l3jn9iawll55rid94nj0il6";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  postPatch = ''
    sed -i Makefile -e '/^install:/ s,lib.install.byte lib.install.native,lib.install,'
  '';

  preInstall = ''
    mkdir -p "$out/bin"
  '';

  meta = with lib; {
    homepage = https://github.com/mransan/ocaml-protoc;
    description = "A Protobuf compiler for OCaml";
    license = licenses.mit;
  };
}
