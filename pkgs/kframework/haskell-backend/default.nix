{ lib, fetchgit }:

let
  srcJSON = lib.importJSON ../k/src-haskell-backend.json;
  src = fetchgit {
    inherit (srcJSON) url rev sha256 fetchSubmodules;
  };
in

(import src { release = true; }).kore
