#!/bin/bash


if [ "$1" == "" ]; then
	echo "no repository specified" 
	exit
fi

repo=$1

echo "doing release for repo: $repo"

git clone git@github.com:ipa320/$repo -b indigo_dev
cd $repo
git fetch origin
git checkout -b indigo_release_candidate
git push origin indigo_release_candidate

