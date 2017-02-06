#!/bin/bash

sudo apt list --installed > /tmp/package_list
perl -pi -e 's{ / .*? ]}{}x' /tmp/package_list
sed -i 's/Listing...//' /tmp/package_list 
sed -i ':a;N;$!ba;s/\n/ /g' /tmp/package_list
tr '\n' ' ' < /tmp/package_list | sed -i '$s/ $/\n/' /tmp/package_list
packages=$(cat /tmp/package_list)

pcs="
cob-stud-1
cob-stud-2
cob-stud-3
cob-stud-4
cob-stud-5
cob-stud-6
cob-stud-7"

for i in $pcs; do 
  echo "-------------------------------------------"
  echo "Installing packages on $i"
  echo "-------------------------------------------"
  echo ""
  ssh $i "sudo apt-get update"
  ssh $i "sudo apt-get install $packages -y"
  ret=${PIPESTATUS[0]}
  if [ $ret != 0 ] ; then
    echo -t "apt-get return an error (error code: $ret), aborting..."
    exit 1
  fi
  echo ""
done

