#!/usr/bin/env bash

# Basic script to set up the git config variables needed by GitHub.
# After the user enters his user/password, everything should be pre-populated.
# The user can, of course, choose to override the values the script digs up for user.name and user.email

# checking input parameters
# $1 -i for ipa setup (optional)
if [ "$#" -ge 2 ]; then
	echo "ERROR: Wrong number of parameters"
	echo "Usage: setup.sh [-i]"
	exit 1
elif [ "$1" = "-i" ]; then
	echo "Setting up IPA configuration"
	IPA=true
else
	IPA=false
fi

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
	token=`echo "$acct" | grep "API token" | sed 's/<p>.*<code>//' |sed 's/<\/code>.*//'`

	if [ $token ]; then
		#echo $token
		echo "Saving GitHub token to global git config"
		`git config --global github.user $user`
		`git config --global github.token $token`
	else
		echo "Error retrieving token"
		echo "Is curl installed? Please install curl with 'sudo apt-get install curl'."
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
	read -p "No id_rsa key found, generate one? (y/N) "
	echo ""
	if [[ $REPLY = [yY] ]]; then
		echo ""
		echo "****************************************************************************"
		echo "*     GitHub highly recommends you use a strong passphrase on your key     *"
		echo "* Visit http://help.github.com/working-with-key-passphrases/ for more info *"
		echo "****************************************************************************"
		echo ""
		ssh-keygen -t rsa -f ~/.ssh/id_rsa
	fi
fi

if [ -f ~/.ssh/id_rsa ]; then
	read -p "Upload id_rsa key to your GitHub account? (y/N) "
	if [[ $REPLY = [yY] ]]; then
		sshkey=`cat ~/.ssh/id_rsa.pub`
		acct=`curl -F "login=$user" -F "token=$token" https://github.com/account/public_keys -F "public_key[title]=$USER@$HOSTNAME" -F "public_key[key]=$sshkey" 2> /dev/null`
	fi
	echo ""
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
		read -p "Install script to your .bashrc file? (y/N) "
		echo ""
		if [[ $REPLY = [yY] ]]; then
			cp ${0%/*}/ssh-agent-loader.sh ~/.ssh/agent-loader.sh
			echo "" >> ~/.bashrc
			echo "source ~/.ssh/agent-loader.sh" >> ~/.bashrc
			echo "Script installed, you will need to re-open git bash to load your key."
		fi
	fi
fi

# clone care-o-bot repository
if [ ! -d ~/git/care-o-bot ]; then
	read -p "Do you want to clone the care-o-bot repository? (y/N) "
	if [[ $REPLY = [yY] ]]; then
		echo ""
		echo "Cloning care-o-bot repository"
		mkdir -p ~/git
		cd ~/git && git clone git@github.com:$user/care-o-bot.git
	fi
fi

if [ $IPA = true ]; then
	# clone cob3_intern repository
	if [ ! -d ~/git/cob3_intern ]; then
		read -p "Do you want to clone the cob3_intern repository? (y/N) "
		if [[ $REPLY = [yY] ]]; then
			echo ""
			echo "Cloning cob3_intern repository"
			mkdir -p ~/git
			cd ~/git && git clone git@github.com:$user/cob3_intern.git
		fi
	fi

	# clone robocup repository
	if [ ! -d ~/git/robocup ]; then
		read -p "Do you want to clone the robocup repository? (y/N) "
		if [[ $REPLY = [yY] ]]; then
			echo ""
			echo "Cloning robocup repository"
			mkdir -p ~/git
			cd ~/git && git clone git@github.com:$user/robocup.git
		fi
	fi

	# clone robocup dependency repositories
	if [ -d ~/git/robocup ]; then
		if [ ! -d ~/ros/ros_experimental ]; then
			read -p "Do you want to checkout the ros_experimental repository? (y/N) "
			if [[ $REPLY = [yY] ]]; then
				echo ""
				mkdir -p ~/ros/ros_experimental
				svn co https://code.ros.org/svn/ros/stacks/ros_experimental/trunk ~/ros/ros_experimental
			fi
		fi
		if [ ! -d ~/ros/rosjava_deps ]; then
			read -p "Do you want to checkout the rosjava_deps repository? (y/N) "
			if [[ $REPLY = [yY] ]]; then
				echo ""
				mkdir -p ~/ros/rosjava_deps
				svn co https://tum-ros-pkg.svn.sourceforge.net/svnroot/tum-ros-pkg/utils/rosjava_deps ~/ros/rosjava_deps
			fi
		fi
	fi
fi

# setup bashrc for ROS with cturtle and care-o-bot. First delete all entries and then add them in the correct order.
sed -i '/ros/ d' ~/.bashrc
sed -i '/care-o-bot/ d' ~/.bashrc
sed -i '/cob3_intern/ d' ~/.bashrc
sed -i '/robocup/ d' ~/.bashrc

if [ -d /opt/ros/cturtle ]; then
	`echo "source /opt/ros/cturtle/setup.sh" >> ~/.bashrc 2> /dev/null`
	ROS_PACKAGE_PATH="/opt/ros/cturtle/stacks"
else
	print "ERROR: No ROS cturtle release found"
fi

if [ -d ~/ros ]; then
	`rm ~/ros/setup.sh 2> /dev/null`
	touch ~/ros/setup.sh
	`echo "export ROS_PACKAGE_PATH=$HOME/ros:$ROS_PACKAGE_PATH" >> ~/ros/setup.sh 2> /dev/null`
	`echo "source $HOME/ros/setup.sh" >> ~/.bashrc 2> /dev/null`
fi

if [ -d ~/git/care-o-bot ]; then
	`cd ~/git/care-o-bot && . makeconfig -a 2> /dev/null`
fi

if [ -d ~/git/cob3_intern ]; then
	`cd ~/git/cob3_intern && . makeconfig -a 2> /dev/null`
fi

if [ -d ~/git/robocup ]; then
	`cd ~/git/robocup && . makeconfig -a 2> /dev/null`
fi

echo ""
echo "Please logout and login again to activate your settings."
