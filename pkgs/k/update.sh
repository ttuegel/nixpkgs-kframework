#! /usr/bin/env nix-shell
#! nix-shell -i fish -p fish git jq nix-prefetch-scripts

if test (git status --porcelain | wc -l) -ne 0
    echo >&2 "Aborting: Git repository is not clean!"
    exit 1
end

jq -r .pname <name.json | read -l pname
jq -r .rev <src.json | read -l rev
jq -r .url <src.json | read -l url

set src (mktemp -d)
git clone $url $src
set git_dir $src'/.git'

function git_tag
    git --git-dir=$git_dir tag --list --sort=creatordate $argv
end

git_tag --contains=$rev | tail --lines=+2 | while read -l tag
    echo -s '{"pname":"' $pname '","tag":"' $tag '"}' >name.json
    nix-prefetch-git --url $url --rev $tag >src.json
    git add src.json name.json
    git commit -m $pname'-'$tag
end

