#! /usr/bin/env nix-shell
#! nix-shell -i fish -p fish git

pushd pkgs/kframework/k

while ./update.sh $argv
    echo 'update: success'
    nix-build ../../../release.nix -A kframework; or break
    echo 'build: success'
    git push
end

popd
