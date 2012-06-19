#!/bin/bash

# Script for opening terminals on all cob-stud-pc's.

# checking input parameters
if [ "$#" -gt 1 ]; then
	echo "ERROR: Wrong number of parameters"
	echo "Usage: $0 [user]"
	exit 1
elif [ "$#" -eq 1 ]; then
	user=$1
else
	user="stud-admin"
fi

echo "Start opening terminals..."

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

pos=0
for client in $client_list; do
	echo "-------------------------------------------"
	echo "Opening terminal on $client"
	echo "-------------------------------------------"
	echo ""
	gnome-terminal --geometry=98x10+0+$pos -e "ssh $user@$client"&
	sleep 0.2
	pos=$(($pos+50))
	echo ""
done

echo "...opening terminals ended."
