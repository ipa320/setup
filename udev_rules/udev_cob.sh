#!/bin/bash
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
# copy this executable into /etc/init.d 
# chmod +x udev_cob.sh
# sudo cp udev_cob.sh /etc/init.d/
# sudo update-rc.d udev_desire.sh defaults
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

## Scan0 ##
Scan0Attr1='ATTRS{bInterfaceNumber}=="00"'
Scan0Attr2='ATTRS{idProduct}=="6010"'

## Scan1 ##
Scan1Attr1='ATTRS{bInterfaceNumber}=="01"'
Scan1Attr2='ATTRS{idProduct}=="6010"'

## Relayboard ##
RelaisAttr1='ATTRS{idProduct}=="6001"'
RelaisAttr2='ATTRS{bcdDevice}=="0400"'

## LED ##
LedAttr1='ATTRS{idProduct}=="6001"'
LedAttr2='ATTRS{serial}=="A800K9NH"'


#Phidget rules for tray sensor
PhidgetAttr1='ATTRS{idVendor}=="0925"'

#Tactile Sensors
TactAttr1='ATTRS{idVendor}=="067b"' #ATTRS{idVendor}=="10c4"
TactAttr2='ATTRS{idProduct}=="2303' #ATTRS{idProduct}=="ea60"
sudo chmod 666 /dev/ttyACM0

sudo chmod 666 /dev/ttyUSB0
sudo udevadm info -a -p $(udevadm info -q path -n /dev/ttyUSB0) > /tmp/usb0
if grep -qs $LedAttr1 /tmp/usb0 && grep -qs $LedAttr2 /tmp/usb0
then
    sudo ln -s ttyUSB0 /dev/ttyLed
fi
if grep -qs $RelaisAttr1 /tmp/usb0 && grep -qs $RelaisAttr2 /tmp/usb0
then
    sudo ln -s ttyUSB0 /dev/ttyRelais
fi
if grep -qs $Scan0Attr1 /tmp/usb0  && grep -qs $Scan0Attr2 /tmp/usb0 
then
    sudo ln -s ttyUSB0 /dev/ttyScan0
fi
if grep -qs $Scan1Attr1 /tmp/usb0  && grep -qs $Scan1Attr2 /tmp/usb0 
then
    sudo ln -s ttyUSB0 /dev/ttyScan1
fi
if grep -qs $TactAttr1 /tmp/usb0  && grep -qs $TactAttr2 /tmp/usb0 
then
    sudo ln -s ttyUSB0 /dev/ttyTact
fi

sudo chmod 666 /dev/ttyUSB1
sudo udevadm info -a -p $(udevadm info -q path -n /dev/ttyUSB1) > /tmp/usb1
if grep -qs $LedAttr1 /tmp/usb1 && grep -qs $LedAttr2 /tmp/usb1
then
    sudo ln -s ttyUSB0 /dev/ttyLed
fi
if grep -qs $RelaisAttr1 /tmp/usb1 && grep -qs $RelaisAttr2 /tmp/usb1
then
    sudo ln -s ttyUSB1 /dev/ttyRelais
fi
if grep -qs $Scan0Attr1 /tmp/usb1  && grep -qs $Scan0Attr2 /tmp/usb1 
then
    sudo ln -s ttyUSB1 /dev/ttyScan0
fi
if grep -qs $Scan1Attr1 /tmp/usb1  && grep -qs $Scan1Attr2 /tmp/usb1 
then
    sudo ln -s ttyUSB1 /dev/ttyScan1
fi
if grep -qs $TactAttr1 /tmp/usb1  && grep -qs $TactAttr2 /tmp/usb1
then
    sudo ln -s ttyUSB1 /dev/ttyTact
fi

sudo chmod 666 /dev/ttyUSB2
sudo udevadm info -a -p $(udevadm info -q path -n /dev/ttyUSB2) > /tmp/usb2
if grep -qs $LedAttr1 /tmp/usb2 && grep -qs $LedAttr2 /tmp/usb2
then
    sudo ln -s ttyUSB2 /dev/ttyLed
fi
if grep -qs $RelaisAttr1 /tmp/usb2 && grep -qs $RelaisAttr2 /tmp/usb2
then
    sudo ln -s ttyUSB2 /dev/ttyRelais 
fi
if grep -qs $Scan0Attr1 /tmp/usb2  && grep -qs $Scan0Attr2 /tmp/usb2 
then
    sudo ln -s ttyUSB2 /dev/ttyscan0
fi
if grep -qs $Scan1Attr1 /tmp/usb2  && grep -qs $Scan1Attr2 /tmp/usb2
then
    sudo ln -s ttyUSB2 /dev/ttyScan1
fi
if grep -qs $TactAttr1 /tmp/usb2  && grep -qs $TactAttr2 /tmp/usb2 
then
    sudo ln -s ttyUSB2 /dev/ttyTact
fi

sudo chmod 666 /dev/ttyUSB3
sudo udevadm info -a -p $(udevadm info -q path -n /dev/ttyUSB3) > /tmp/usb3
if grep -qs $LedAttr1 /tmp/usb3 && grep -qs $LedAttr2 /tmp/usb3
then
    sudo ln -s ttyUSB3 /dev/ttyLed
fi
if grep -qs $RelaisAttr1 /tmp/usb3 && grep -qs $RelaisAttr2 /tmp/usb3
then
    sudo ln -s ttyUSB3 /dev/ttyRelais 
fi
if grep -qs $Scan0Attr1 /tmp/usb3  && grep -qs $Scan0Attr2 /tmp/usb3 
then
    sudo ln -s ttyUSB3 /dev/ttyscan0
fi
if grep -qs $Scan1Attr1 /tmp/usb3  && grep -qs $Scan1Attr2 /tmp/usb3
then
    sudo ln -s ttyUSB3 /dev/ttyScan1
fi
if grep -qs $TactAttr1 /tmp/usb3  && grep -qs $TactAttr2 /tmp/usb3 
then
    sudo ln -s ttyUSB3 /dev/ttyTact
fi

sudo chmod 666 /dev/ttyUSB4
sudo udevadm info -a -p $(udevadm info -q path -n /dev/ttyUSB4) > /tmp/usb4
if grep -qs $LedAttr1 /tmp/usb4 && grep -qs $LedAttr2 /tmp/usb4
then
    sudo ln -s ttyUSB4 /dev/ttyLed
fi
if grep -qs $RelaisAttr1 /tmp/usb4 && grep -qs $RelaisAttr2 /tmp/usb4
then
    sudo ln -s ttyUSB4 /dev/ttyRelais 
fi
if grep -qs $Scan0Attr1 /tmp/usb4  && grep -qs $Scan0Attr2 /tmp/usb4 
then
    sudo ln -s ttyUSB4 /dev/ttyscan0
fi
if grep -qs $Scan1Attr1 /tmp/usb4  && grep -qs $Scan1Attr2 /tmp/usb4
then
    sudo ln -s ttyUSB4 /dev/ttyScan1
fi
if grep -qs $TactAttr1 /tmp/usb4  && grep -qs $TactAttr2 /tmp/usb4 
then
    sudo ln -s ttyUSB4 /dev/ttyTact
fi
