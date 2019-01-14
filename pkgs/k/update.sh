#! /usr/bin/env nix-shell
#! nix-shell -i fish -p fish git jq nix-prefetch-scripts

if test (git status --porcelain | wc -l) -ne 0
    echo >&2 "Aborting: Git repository is not clean!"
    exit 1
end

jq -r .rev <src.json | read -l rev
jq -r .url <src.json | read -l url

set git_dir $argv[1]'/.git'

function git_tag
    git --git-dir=$git_dir tag --list --sort=creatordate $argv
end

function git_version -d "Construct version based on Git commit"
    git \
        --git-dir=$git_dir log --max-count=1 \
        --pretty=format:'{"version":"%ad","abbrv":"%h"}' \
        --date=format:%Y%m%d.%H%M \
        $argv
end

git_tag --contains=$rev | tail --lines=+2 | while read -l tag
    git_version $tag >version.json
    nix-prefetch-git --url $url --rev $tag >src.json
    jq -r .version <version.json | read -l version
    jq -r .abbrv <version.json | read -l abbrv
    git add src.json version.json
    git commit -m 'k-nightly-'$version'-'$abbrv
end

