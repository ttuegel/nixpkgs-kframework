{
  lib, stdenv, fetchgit,
  cmake, flex, pkgconfig,
  llvmPackages,
  boost, gmp, jemalloc, libffi, libyaml, mpfr,
}:

let
  inherit (llvmPackages) llvm clang;
  pname = "llvm-backend";
in

let
  srcJSON = lib.importJSON ../k/src-llvm-backend.json;
  src = fetchgit {
    inherit (srcJSON) url rev sha256 fetchSubmodules;
  };
  version = "0-${lib.substring 0 8 srcJSON.rev}";
in

stdenv.mkDerivation {
  inherit pname version;
  inherit src;

  nativeBuildInputs = [ cmake clang flex llvm pkgconfig ];
  buildInputs = [ boost gmp libffi libyaml jemalloc mpfr ];

  cmakeFlags = [
    ''-DCMAKE_C_COMPILER=${lib.getBin clang}/bin/cc''
    ''-DCMAKE_CXX_COMPILER=${lib.getBin clang}/bin/c++''
  ];
  NIX_CFLAGS_COMPILE = [ "-Wno-error" ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    # Find local test libraries. Nixpkgs' linker script filters paths outside
    # the Nix store, so the build-local libraries are not linked.
    (
        export LD_LIBRARY_PATH="''${LD_LIBRARY_PATH:+:}"'$ORIGIN/lib'
        make run-unittests
    )

    runHook postCheck
  '';
}
