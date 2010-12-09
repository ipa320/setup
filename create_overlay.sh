#!/usr/bin/env bash

# Basic script to set up the git config variables needed by GitHub.
# After the user enters his user/password, everything should be pre-populated.
# The user can, of course, choose to override the values the script digs up for user.name and user.email

# checking input parameters
# $1 -i for ipa setup (optional)
if [ "$#" -ge 2 ]; then
	echo "ERROR: Wrong number of parameters"
	echo "Usage: create_overlay.sh STACK"
	exit 1
elif [ "$1" = "cob_extern" ]; then
	STACK=$1
elif [ "$1" = "cob_common" ]; then
	STACK=$1
elif [ "$1" = "cob_driver" ]; then
	STACK=$1
elif [ "$1" = "cob_simulation" ]; then
	STACK=$1
elif [ "$1" = "cob_apps" ]; then
	STACK=$1
else
	echo "ERROR: stack <<"$1">> not supported, choose one of"
	echo "    * cob_extern"
	echo "    * cob_common"
	echo "    * cob_driver"
	echo "    * cob_simulation"
	echo "    * cob_apps"
	echo "aborting..."
	exit 1
fi

echo "-------------------------------------------"
echo "Creating overlay for stack <<"$STACK">>"
echo "-------------------------------------------"
echo ""

# Check git user name
user=`git config --global github.user`
token=`git config --global github.token`
if [ -z "$user" ]; then
	read -p "GitHub username not found, please enter (leave blank for read-only access): " -e user
fi

readonly=false
if [ -z "$user" ]; then
	readonly=true
else
	# Setup gh token
	if [ -z "$token" ]; then
		echo "GitHub token not found in global git config"
		read -s -p "Please enter GitHub password for $user (this will not be saved): " -e password
		echo "" # Because we didn't echo the user's return key above

		echo "Fetching API token"
		acct=`curl https://github.com/account --user $user:$password 2> /dev/null`
		token=`echo "$acct" | grep "API token" | sed 's/<p>.*<code>//' |sed 's/<\/code>.*//'`

		if [ $token ]; then
			echo "Saving GitHub token to global git config"
			`git config --global github.user $user`
			`git config --global github.token $token`
		else
			echo "Error retrieving token:"
			echo "Did you enter the correct password?"
			echo "Is curl installed? Please install curl with 'sudo apt-get install curl'."
			exit 1
		fi
	fi

	# Setup username
	gitname=`git config --global user.name`
	if [ -z "$gitname" ]; then
		gitname=$user
	fi
	read -p "Enter git committer name (return to use '$gitname'): " -e newgitname

	if [ -z "$newgitname" ]; then
		newgitname=$gitname
	fi
	`git config --global user.name "$newgitname"`


	# Setup email
	ghemail=`echo "$acct" | grep 'class="address"' | head -n1 | sed "s/.*>\([^@]*@[^<]*\)<.*/\1/"`
	gitemail=`git config --global user.email`
	if [ -z "$gitemail" ]; then
		gitemail=$ghemail
	fi
	read -p "Enter git committer email (return to use '$gitemail'): " -e newgitemail

	if [ -z "$newgitemail" ]; then
		newgitemail=$gitemail
	fi
	`git config --global user.email "$newgitemail"`

	# SSH keys!
	if [ ! -f ~/.ssh/id_rsa ]; then
		read -p "No id_rsa key found, generate one? (y/N) "
		echo ""
		if [[ $REPLY = [yY] ]]; then
			ssh-keygen -t rsa -f ~/.ssh/id_rsa
		fi
	fi

	if [ -f ~/.ssh/id_rsa ]; then
		read -p "Upload id_rsa key to your GitHub account? (y/N) "
		if [[ $REPLY = [yY] ]]; then
			sshkey=`cat ~/.ssh/id_rsa.pub`
			sshkey=`echo $sshkey`
			user=`echo $user`
			token=`echo $token`
			acct=`curl -F "login=$user" -F "token=$token" https://github.com/account/public_keys -F "public_key[title]=$USER@$HOSTNAME" -F "public_key[key]=$sshkey" 2> /dev/null`
		fi
		echo ""
	fi

	# Fork stack on github
	acct=`curl -F "login=$user" -F "token=$token" https://github.com/ipa320/$STACK/fork 2> /dev/null`
fi

# Clone stack
mkdir -p ~/git
mkdir -p ~/git/care-o-bot
if [ -d ~/git/care-o-bot/$STACK ]; then
	read -p "Stack overlay already exists. Do you want to pull changes to your master branch? (y/N) "
	if [[ $REPLY = [yY] ]]; then
		echo ""
		cd ~/git/care-o-bot/$STACK && git checkout master
		cd ~/git/care-o-bot/$STACK && git pull origin master
	fi
else
	if $readonly; then
		cd ~/git/care-o-bot && git clone git://github.com/ipa320/$STACK.git
	else
		cd ~/git/care-o-bot && git clone git@github.com:$user/$STACK.git
	fi
fi


# Setup bashrc for ROS with cturtle and care-o-bot stacks. First delete all entries and then add them in the correct order.
sed -i '/ros/ d' ~/.bashrc
sed -i '/care-o-bot/ d' ~/.bashrc

if [ -d /opt/ros/cturtle ]; then
	`echo "source /opt/ros/cturtle/setup.sh" >> ~/.bashrc 2> /dev/null`
	ROS_PACKAGE_PATH="/opt/ros/cturtle/stacks"
else
	print "ERROR: No ROS cturtle release found"
fi

if [ -d ~/ros ]; then
	`rm ~/ros/setup.sh 2> /dev/null`
	touch ~/ros/setup.sh
	`echo 'export ROS_PACKAGE_PATH=$HOME/ros:$ROS_PACKAGE_PATH' >> ~/ros/setup.sh 2> /dev/null`
	`echo "source $HOME/ros/setup.sh" >> ~/.bashrc 2> /dev/null`
fi

if [ -d ~/git/care-o-bot ]; then
	if [ -f ~/git/care-o-bot/setup.sh ]; then
		rm ~/git/care-o-bot/setup.sh
	else
		touch ~/git/care-o-bot/setup.sh
	fi
	`echo '#!/bin/bash' >> ~/git/care-o-bot/setup.sh 2> /dev/null`
	`echo 'export ROS_PACKAGE_PATH=$HOME/git/care-o-bot:$ROS_PACKAGE_PATH' >> ~/git/care-o-bot/setup.sh 2> /dev/null`
	`echo 'COUNT=$(cat /proc/cpuinfo | grep "processor" | wc -l)' >> ~/git/care-o-bot/setup.sh 2> /dev/null`
	`echo 'COUNT=$(echo "$COUNT*2" | bc)' >> ~/git/care-o-bot/setup.sh 2> /dev/null`
	`echo 'export ROS_PARALLEL_JOBS=-j$COUNT' >> ~/git/care-o-bot/setup.sh 2> /dev/null`
	`echo "source $HOME/git/care-o-bot/setup.sh" >> ~/.bashrc 2> /dev/null`
fi

echo ""
echo "Please logout and login again to activate your settings. (or type 'source ~/.bashrc')"
