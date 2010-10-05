#!/usr/bin/env bash

# Script to create a user account on the robot

# checking input parameters
# $1 USERNAME

if [ $# != 1 ]; then
	echo "ERROR: Wrong number of parameters"
	echo "Usage: create_user.sh USERNAME"
	exit 1
else
	echo "Creating user with"
	echo "User name = " $1
fi


