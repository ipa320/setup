#!/usr/bin/env bash

# Basic script to set up the git config variables needed by GitHub.
# After the user enters his user/password, everything should be pre-populated.
# The user can, of course, choose to override the values the script digs up for user.name and user.email


user=`git config --global github.user`
token=`git config --global github.token`


if [ -z "$user" ]; then
	read -p "GitHub username not found, please enter: " -e user
fi


# Setup gh token
if [ -z "$token" ]; then
	echo "GitHub token not found in global git config"
	read -s -p "Please enter GitHub password for $user (this will not be saved): " -e password
	echo "" # Because we didn't echo the user's return key above

	echo "Fetching API token"
	acct=`curl https://github.com/account --user $user:$password 2> /dev/null`
	token=`echo "$acct" | grep -C 1 "API token" | tail -1 | sed "s/.*<dd>\(.*\)<.dd>/\1/"`

	if [ $token ]; then
		echo "Saving GitHub token to global git config"
		`git config --global github.user $user`
		`git config --global github.token $token`
	else
		echo "Error retrieving token"
		exit 1
	fi
fi

if [ -z "$acct" ]; then
	echo "Fetching GitHub account details"
	acct=`curl -F "login=$user" -F "token=$token" https://github.com/account 2> /dev/null`
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
	read -n1 -p "No id_rsa key found, generate one? (y/n) "
	echo ""
	if [[ $REPLY = [yY] ]]; then
		echo ""
		echo "****************************************************************************"
		echo "*     GitHub highly recommends you use a strong passphrase on your key     *"
		echo "* Visit http://help.github.com/working-with-key-passphrases/ for more info *"
		echo "****************************************************************************"
		echo ""
		ssh-keygen -t rsa -C "$newgitemail" -f ~/.ssh/id_rsa
	fi
fi

if [ -f ~/.ssh/id_rsa ]; then
	read -n1 -p "Upload id_rsa key to your GitHub account? (y/n) "
	if [[ $REPLY = [yY] ]]; then
		sshkey=`cat ~/.ssh/id_rsa.pub`
		acct=`curl -F "login=$user" -F "token=$token" https://github.com/account/ -F "public_key[key]=$sshkey" 2> /dev/null`
	fi
fi


# ssh-agent helper for msysgit
if [ $MSYSTEM ]; then
	script_installed=`grep "source ~/.ssh/agent-loader" ~/.bashrc 2> /dev/null`
	if [ -z "$script_installed" ]; then
		echo ""
		echo "You appear to be running Msysgit, would you like to use the ssh-agent loader?"
		echo "This script will load ssh-agent to save your passphrase so that you don't need"
		echo "to re-enter the passphrase every time you use your ssh key."
		echo "For more info visit http://help.github.com/working-with-key-passphrases/"
		echo ""
		read -n1 -p "Install script to your .bashrc file? (y/n) "
		echo ""
		if [[ $REPLY = [yY] ]]; then
			cp ${0%/*}/ssh-agent-loader.sh ~/.ssh/agent-loader.sh
			echo "" >> ~/.bashrc
			echo "source ~/.ssh/agent-loader.sh" >> ~/.bashrc
			echo "Script installed, you will need to re-open git bash to load your key."
		fi
	fi
fi

#setup ROS with cturtle
bashrc=`cat ~/.bashrc`
cturtle=`echo "$bashrc" | grep -C 1 "cturtle" | tail -1`
if [ "$cturtle" == "" ]; then
	`echo "source /opt/ros/cturtle/setup.sh" >> ~/.bashrc 2> /dev/null`
	. ~/.bashrc
fi

# clone repository
#if [ ! -d ~/git/care-o-bot ]; then
#	echo "Cloning care-o-bot repository"
#	mkdir -p ~/git
#	cd ~/git && git clone git@github.com:$user/care-o-bot.git
#else
#	echo "Care-o-bot repository already exists"
#fi
