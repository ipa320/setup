#!/usr/bin/env bash

# Simple script to wipe the git config variables that GitHub depends on
# Useful if the user wants to start from scratch

`git config --global --unset user.name`
`git config --global --unset user.email`
`git config --global --unset github.user`
`git config --global --unset github.token`
