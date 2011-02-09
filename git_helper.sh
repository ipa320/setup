#!/bin/bash

# checking input parameters
if [ "$#" -ge 2 ]; then
	echo "ERROR: Wrong number of parameters"
	echo "Usage: create_overlay.sh STACK"
	exit 1
elif [ "$1" = "status" ]; then
	COMMAND="git status -uno"
elif [ "$1" = "master" ]; then
	COMMAND="git checkout master"
elif [ "$1" = "commit" ]; then
	read -p "Commit message:"
	COMMAND="git commit -a -m'$REPLY'"
elif [ "$1" = "pull" ]; then
	COMMAND="git pull"
elif [ "$1" = "push" ]; then
	COMMAND="git pull && git push"
elif [ "$1" = "push320" ]; then
	COMMAND="git checkout review-320 && git pull origin-320 master && git push origin-320 master && git checkout master"
elif [ "$1" = "merge320" ]; then
	COMMAND="git checkout master && git pull origin master && git checkout review-320 && git pull origin-320 master && git checkout master && git merge review-320 && git push origin master"
elif [ "$1" = "mergeto320" ]; then
	COMMAND="git checkout master && git pull origin master && git checkout review-320 && git pull origin-320 master && git merge master && git push origin-320 master && git checkout master"
else
	echo "ERROR: command <<"$1">> not supported, choose one of"
	echo "    * status"
	echo "    * master"
	echo "    * commit"
	echo "    * pull"
	echo "    * push"
	echo "    * push320"
	echo "    * merge320"
	echo "    * mergeto320"
	echo "aborting..."
	exit 1
fi

echo "-------------------------------------------"
echo "Executing <<$COMMAND>>"
echo "-------------------------------------------"
echo ""

echo ""
echo "==> operating on ~/git/care-o-bot/cob_extern"
cd ~/git/care-o-bot/cob_extern ; sh -c "$COMMAND"

echo ""
echo "==> operating on ~/git/care-o-bot/cob_common"
cd ~/git/care-o-bot/cob_common; sh -c "$COMMAND"

echo ""
echo "==> operating on ~/git/care-o-bot/cob_driver"
cd ~/git/care-o-bot/cob_driver; sh -c "$COMMAND"

echo ""
echo "==> operating on ~/git/care-o-bot/cob_simulation"
cd ~/git/care-o-bot/cob_simulation; sh -c "$COMMAND"

echo ""
echo "==> operating on ~/git/care-o-bot/cob_apps"
cd ~/git/care-o-bot/cob_apps; sh -c "$COMMAND"
