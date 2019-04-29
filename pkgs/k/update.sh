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
    git --git-dir=$git_dir --work-tree=$src tag --list --sort=creatordate $argv
end

function git_log_1
    git --git-dir=$git_dir --work-tree=$src log --max-count=1 --format=%H $argv
end

function nix_sha256
    nix-hash --flat --base32 --type sha256 $argv
end

git_tag --contains=$rev | tail --lines=+2 | while read -l tag
    # Only create new versions for the 'nightly-*' tags.
    switch $tag
    case 'nightly-*'
        true
    case '*'
        continue
    end

    echo -s '{"pname":"' $pname '","tag":"' $tag '"}' >name.json
    nix-prefetch-git --url $url --rev $tag --fetch-submodules >src.json
    for patch_json in *.patch.json
        jq -r .file <$patch_json | read -l file
        echo -s >$patch_json \
            '{' \
            '"file":"' $file '",' \
            '"rev":"' (git_log_1 $tag -- $file) '",' \
            '"sha256":"' (nix_sha256 $src/$file) '"' \
            '}'
    end
    git add src.json name.json *.patch.json
    git commit -m $pname'-'$tag
end

