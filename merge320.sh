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
	COMMAND="git branch review-$GITHUBUSER -f && git checkout review-$GITHUBUSER"
	cd ~/git/care-o-bot/$STACK ; status=`sh -c "$COMMAND"`

	# create remote origin if not exists
	COMMAND="git remote"
	cd ~/git/care-o-bot/$STACK ; status=`sh -c "$COMMAND"`
	echo "$status" > ~/tmp/response.txt
	if [ $(grep -c "origin-$GITHUBUSER" ~/tmp/response.txt) == 0 ]; then
		COMMAND="git remote add origin-$GITHUBUSER git@github.com:$GITHUBUSER/$STACK.git"
		cd ~/git/care-o-bot/$STACK ; status=`sh -c "$COMMAND"`
	fi

	# pull from origin-$GITHUBUSER and merge and push
	COMMAND="git pull origin-$GITHUBUSER master && git checkout master && git merge review-$GITHUBUSER && git push origin master"
	cd ~/git/care-o-bot/$STACK ; status=`sh -c "$COMMAND"`
}


####### main ########
if [ "$#" -ge 2 ]; then
	echo "ERROR: Wrong number of parameters"
	echo "Usage: merge-user.sh GITHUBUSER"
	exit 1
elif [ "$#" == 0 ]; then
	GITHUBUSER="ipa320"
	echo "merging with default ipa320"
else
	GITHUBUSER=$1
	echo "merging with $GITHUBUSER"
fi

dirs=`ls ~/git/care-o-bot`
mkdir -p ~/tmp
echo "$dirs" >  ~/tmp/stacks.txt
while read directory
do
	if [ -d ~/git/care-o-bot/$directory ]; then
		update $directory
	fi
done < ~/tmp/stacks.txt

