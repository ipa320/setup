#!/bin/bash

update(){
	STACK="$1"
	echo ""
	echo "-------------------------------------------"
	echo "==> operating on ~/git/care-o-bot/$STACK"	
	echo "-------------------------------------------"
	echo ""

	# check for local changes
	COMMAND="git status --porcelain -uno"
	cd ~/git/care-o-bot/$STACK ; status=`sh -c "$COMMAND"`
	if [ ! -z "$status" ]; then
		echo "ERROR: found local changes: please commit them first before merging with ipa320, aborting..."
		exit 1
	fi

	# push user's master
	COMMAND="git checkout master && git push origin master"
	cd ~/git/care-o-bot/$STACK ; status=`sh -c "$COMMAND"`

	# create review branch
	COMMAND="git branch review-320 -f && git checkout review-320"
	cd ~/git/care-o-bot/$STACK ; status=`sh -c "$COMMAND"`

	# create remote origin if not exists
	COMMAND="git remote"
	cd ~/git/care-o-bot/$STACK ; status=`sh -c "$COMMAND"`
	echo "$status" > ~/tmp/response.txt
	if [ $(grep -c "origin-320" ~/tmp/response.txt) == 0 ]; then
		COMMAND="git remote add origin-320 git@github.com:ipa320/$STACK.git"
		cd ~/git/care-o-bot/$STACK ; status=`sh -c "$COMMAND"`
	fi

	# pull from origin-320 and merge and push
	COMMAND="git pull origin-320 master && git checkout master && git merge review-320 && git push origin master"
	cd ~/git/care-o-bot/$STACK ; status=`sh -c "$COMMAND"`
}

#update "cob_extern"

#update "cob_common"

dirs=`ls ~/git/care-o-bot`
mkdir -p ~/tmp
echo "$dirs" >  ~/tmp/stacks.txt
while read directory
do
	if [ -d ~/git/care-o-bot/$directory ]; then
		update $directory
	fi
done < ~/tmp/stacks.txt

