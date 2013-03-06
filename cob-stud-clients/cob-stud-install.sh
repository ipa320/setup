#!/usr/bin/env bash

# Script for installing apt packages on all cob-stud-pc's.

# checking input parameters
if [ "$#" -lt 1 ]; then
	echo "ERROR: Wrong number of parameters"
	echo "Usage: $0 packages"
	exit 1
fi

client_list="
cob-stud-1
cob-stud-2
cob-stud-3
cob-stud-4
cob-stud-5
cob-stud-6
cob-stud-7
cob-stud-8
cob-stud-9
cob-stud-101
cob-stud-102
cob-stud-103
cob-stud-104
cob-stud-601
cob-stud-602
cob-stud-603"


for client in $client_list; do
	echo "-------------------------------------------"
	echo "Installing <<"$*">> on $client"
	echo "-------------------------------------------"
	echo ""
	ssh $client "sudo apt-get install $* -y"
	ret=${PIPESTATUS[0]}
	if [ $ret != 0 ] ; then
		echo -t "apt-get return an error (error code: $ret), aborting..."
		exit 1
	fi
	echo ""
done
