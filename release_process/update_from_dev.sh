#!/bin/bash


if [ "$1" == "" ]; then
	echo "no repository specified" 
	exit
fi

repo=$1

echo "update repo: $repo"

cd $repo
git checkout indigo_dev && git pull origin indigo_dev && git checkout indigo_release_candidate && git merge indigo_dev && git push origin indigo_release_candidate
