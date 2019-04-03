#!/usr/bin/env fish

# Check every commit since origin/master
git rebase origin/master --exec 'nix build -f release.nix k'
