#!/bin/bash


if [ "$1" == "" ]; then
	echo "no repository specified" 
	exit
fi

repo=$1

echo "doing release for repo: $repo"

git clone git@github.com:ipa320/$repo -b indigo_dev
cd $repo
git fetch -p --all
git checkout -b indigo_release_candidate origin/indigo_release_candidate
git merge indigo_dev
git push origin indigo_release_candidate

