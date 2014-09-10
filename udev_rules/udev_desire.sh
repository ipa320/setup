#################################################################
##\file
#
# \note
# Copyright (c) 2010 \n
# Fraunhofer Institute for Manufacturing Engineering
# and Automation (IPA) \n\n
#
#################################################################
#
# \note
# Project name: care-o-bot
# \note
# ROS stack name: setup
# \note
# ROS package name: setup
#
# \author
# Author: Nadia Hammoudeh Garcia, email:nadia.hammoudeh.garcia@ipa.fhg.de
# \author
# Supervised by: Nadia Hammoudeh Garcia, email:nadia.hammoudeh.garcia@ipa.fhg.de
#
# \date Date of creation: Dec 2012
#
# \brief
# Implements helper script for working with git and the care-o-bot stacks.
#
#################################################################
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# - Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer. \n
# - Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution. \n
# - Neither the name of the Fraunhofer Institute for Manufacturing
# Engineering and Automation (IPA) nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission. \n
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License LGPL as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Lesser General Public License LGPL for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License LGPL along with this program.
# If not, see <http://www.gnu.org/licenses/>.
#
#################################################################

##Scan0##
Scan0Attr1='ATTRS{idProduct}=="6001"'

##Scan1##
RelaisAttr1='ATTRS{bInterfaceNumber}=="00"'
Scan1Attr2='ATTRS{idProduct}=="6010"'

##Relayboard##
Scan1Attr1='ATTRS{bInterfaceNumber}=="01"'
RelaisAttr2='ATTRS{idProduct}=="6010"'



##ttyUSB0
sudo udevadm info -a -p $(udevadm info -q path -n /dev/ttyUSB0) > /tmp/usb0
if grep -qs $Scan0Attr1 /tmp/usb0 
then
    sudo ln -s ttyUSB0 /dev/ttyScan0
fi

if grep -qs $RelaisAttr1 /tmp/usb0  && grep -qs $RelaisAttr2 /tmp/usb0  
then
    sudo ln -s ttyUSB0 /dev/ttyRelays
fi
if grep -qs $Scan1Attr1 /tmp/usb0  && grep -qs $Scan1Attr2 /tmp/usb0
then
    sudo ln -s ttyUSB0 /dev/ttyScan1
fi



##ttyUSB1
sudo udevadm info -a -p $(udevadm info -q path -n /dev/ttyUSB1) > /tmp/usb1
if grep -qs $Scan0Attr1 /tmp/usb1
then
    sudo ln -s ttyUSB1 /dev/ttyScan0
fi
if grep -qs  $RelaisAttr1  /tmp/usb1  && grep -qs $RelaisAttr2 /tmp/usb1 
then
    sudo ln -s ttyUSB1 /dev/ttyRelais
fi
if grep -qs $Scan1Attr1 /tmp/usb1  && grep -qs $Scan1Attr2 /tmp/usb1 
then
    sudo ln -s ttyUSB1 /dev/ttyScan1
fi


##ttyUSB2
sudo udevadm info -a -p $(udevadm info -q path -n /dev/ttyUSB2) > /tmp/usb2
if grep -qs $Scan0Attr1 /tmp/usb2
then
    sudo ln -s ttyUSB2 /dev/ttyScan0
fi
if grep -qs  $RelaisAttr1  /tmp/usb2 && grep -qs $RelaisAttr2 /tmp/usb2 
then
    sudo ln -s ttyUSB2 /dev/ttyRelais
fi
if grep -qs $Scan1Attr1 /tmp/usb2  && grep -qs $Scan1Attr2 /tmp/usb2
then
    sudo ln -s ttyUSB2 /dev/ttyScan1
fi
