{ lib, stdenv, fetchurl, ocaml, findlib, gmp, mpfr, ncurses }:

let
  pname = "mlgmp";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "20120224";

  src = fetchurl {
    url = "http://www-verimag.imag.fr/~monniaux/download/${pname}_${version}.tar.gz";
    sha256 = "3ce1a53fa452ff5a9ba618864d3bc46ef32190b57202d1e996ca7df837ad4f24";
  };

  makeFlags = [
    "DESTDIR=$(out)/lib/ocaml/${ocaml.version}/site-lib/gmp"
  ];

  postPatch = ''
    sed -i Makefile \
        -e "/^GMP_INCLUDES/ c GMP_INCLUDES = $NIX_CFLAGS_COMPILE"
  '';

  preConfigure = ''
    make clean
    export RLIBFLAGS="-cclib -L${gmp}/lib -cclib -L${mpfr}/lib -cclib -L${ncurses}/lib"
  '';

  buildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  propagatedBuildInputs = [ gmp mpfr ncurses ];

  postInstall  = ''
     cp ${./META} $out/lib/ocaml/${ocaml.version}/site-lib/gmp/META
  '';

  meta = with lib; {
    homepage = http://opam.ocamlpro.com/pkg/mlgmp.20120224.html;
    description = "OCaml bindings to GNU MP library";
    license = licenses.isc;
  };
}
