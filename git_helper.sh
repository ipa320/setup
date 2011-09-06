#!/bin/bash

show_usage(){
echo "Usage: git_helper.sh command [options]"
echo "    * status              shows new and modified files"
echo "    * master              switch to master branch"
echo "    * commit              commits all new and modified file !!check with 'status' before commiting!!"
echo "    * pull                pull latest changes from your account at github"
echo "    * push                push latest changes to your account at github"
echo "    * merge [githubuser]  merge with githubuser (default is ipa320)"
}

# checking input parameters
if [ "$#" -ge 3 ]; then
	echo "ERROR: Wrong number of parameters, aborting..."
	show_usage
	exit 1
elif [ "$1" = "help" ]; then
	show_usage
	exit 1
elif [ "$1" = "status" ]; then
	COMMAND="git status -uno"
elif [ "$1" = "master" ]; then
	COMMAND="git checkout master"
elif [ "$1" = "commit" ]; then
	read -p "Commit message:"
	COMMAND="git commit -a -m'$REPLY'"
elif [ "$1" = "pull" ]; then
	COMMAND="git pull origin master"
elif [ "$1" = "push" ]; then
	COMMAND="git pull origin master && git push origin master"
elif [ "$1" = "merge" ]; then
	if [ "$#" -ge 2 ]; then
		GITHUBUSER="$2"
		echo "merging with $GITHUBUSER"
	else
		echo "merging with default ipa320"
		GITHUBUSER="ipa320"
	fi
elif [ "$1" = "mergeto320" ]; then
	echo "merging to ipa320"
	GITHUBUSER="ipa320"
else
	echo "ERROR: command <<"$1">> not supported, aborting..."
	show_usage
	exit 1
fi

merge(){
	STACK="$1"
	
	# check for local changes
	COMMAND="git status --porcelain -uno"
	cd ~/git/care-o-bot/$STACK ; status=`sh -c "$COMMAND"`
	if [ ! -z "$status" ]; then
		echo "ERROR: found local changes in $STACK: please commit them first before merging with $GITHUBUSER, aborting..."
		exit 1
	fi

	# push user's master
	COMMAND="git checkout master && git pull origin master && git push origin master"
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

dirs=`ls ~/git/care-o-bot`
mkdir -p ~/tmp
echo "$dirs" > ~/tmp/stacks.txt
while read directory
do
	if [ -d ~/git/care-o-bot/$directory ]; then
		echo "-------------------------------------------"
		echo "==> operating on ~/git/care-o-bot/$directory"	
		echo "-------------------------------------------"
		
		if [ "$1" = "merge" ]; then
			merge $directory
		elif [ "$1" = "mergeto320" ]; then
			merge $directory
			COMMAND="git checkout review-ipa320 && git merge master && git push origin-ipa320 master && git checkout master"
			cd ~/git/care-o-bot/$directory ; sh -c "$COMMAND"
		else
			cd ~/git/care-o-bot/$directory ; sh -c "$COMMAND"
		fi
	fi
	echo ""
done < ~/tmp/stacks.txt
