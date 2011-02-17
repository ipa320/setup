#!/usr/bin/env bash

# Script to copy binaries to the cob_commercial stack.

# checking input parameters
if [ "$#" -ge 2 ]; then
	echo "ERROR: Wrong number of parameters"
	echo "Usage: copy_pkg_to_commercial.sh PACKAGE"
	exit 1
elif [ "$1" = "cob_platform_ctrl" ]; then
	PACKAGE=$1
elif [ "$1" = "cob_sensor_fusion" ]; then
	PACKAGE=$1
elif [ "$1" = "cob_object_detection" ]; then
	PACKAGE=$1
else
	echo "ERROR: package <<"$1">> not supported, choose one of"
	echo "    * cob_platform_ctrl"
	echo "    * cob_sensor_fusion"
	echo "    * cob_object_detection"
	echo "aborting..."
	exit 1
fi

echo "------------------------------------------------------"
echo "Copying package <<"$PACKAGE">> to cob_commercial"
echo "------------------------------------------------------"
echo ""

# setup ROS_PACKAGE_PATH
source /opt/ros/diamondback/setup.bash
export ROS_PACKAGE_PATH=~/git/cob3_intern:$ROS_PACKAGE_PATH

# copy binaries
cp $(rospack find $PACKAGE)/ros/bin/* ~/git/care-o-bot/cob_commercial/$PACKAGE/ros/bin -rf

# strip binaries
strip ~/git/care-o-bot/cob_commercial/$PACKAGE/ros/bin/*

echo "done."
