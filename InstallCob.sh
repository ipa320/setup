#!/bin/bash
#### COMMON PARAMETERS
usage=$(cat <<"EOF"
USAGE:  ./InstallCob.sh [-r] [-ip] [-m]\n
Where:\n
  -r robot name (example cob3-1)\n
  -ip ip address\n
  -m installation mode (master or slave)\n
EOF
)
green='\e[0;32m'
red='\e[0;31m'
NC='\e[0m' # No Color


#### FUNCTION BASIC INSTALLATION
function BasicInstallation {

  echo -e "\n${green}INFO:Installing basic tools${NC}\n"
  sleep 5
  sudo apt-get update
  sudo apt-get install vim tree gitg meld curl openjdk-6-jdk zsh terminator language-pack-de language-pack-en ipython -y --force-yes

  echo -e "\n${green}INFO:Update grub to avoid hangs on reboot${NC}\n"
  sleep 5
  if grep -q GRUB_RECORDFAIL_TIMEOUT= /etc/default/grub ; then
    echo "found GRUB_RECORD_FAIL flag already, skipping update-grub call"
  else
    echo GRUB_RECORDFAIL_TIMEOUT=10 | sudo tee -a /etc/default/grub
    sudo update-grub
  fi

  echo -e "\n${green}INFO:Install openssh server${NC}\n"
  sleep 5
  sudo apt-get install openssh-server -y --force-yes
  echo -e "\n${green}INFO:Let the server send a alive interval to clients to not get a broken pipe${NC}\n"
  echo "ClientAliveInterval 60" | sudo tee -a /etc/ssh/sshd_config
  sudo sed -i 's/PermitRootLogin/PermitRootLogin yes/g' /etc/ssh/sshd_config

  echo -e "\n${green}INFO:Checkout the setup repository${NC}\n"
  sleep 5
  mkdir ~/git
  cd ~/git
  git clone git://github.com/ipa320/setup.git

  echo -e "\n${green}INFO:Allow robot user to execute sudo command without password${NC}\n"
  sleep 5
  echo "robot ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
  sudo adduser robot dialout
  sudo adduser robot audio
  sudo adduser robot pulse

  echo -e "\n${green}INFO:Setup local ROOT user${NC}\n"
  sleep 5
  sudo passwd root      
      
  echo -e "\n${green}INFO: Install ROS${NC}\n"
  sleep 5
  echo -e "\n${green}   INFO: Setup your source.list${NC}\n"
  sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu trusty main" > /etc/apt/sources.list.d/ros-latest.list'
  echo -e "\n${green}   INFO: Set up your keys${NC}\n"
  wget http://packages.ros.org/ros.key -O - | sudo apt-key add -
  echo -e "\n${green}   INFO: Install ROS${NC}\n"
  sudo apt-get update
  sudo apt-get install ros-indigo-rosbash python-ros-* ros-indigo-care-o-bot-robot -y --force-yes
  sudo rosdep init
  rosdep update

  echo -e "\n${green}INFO: Setup udev rules${NC}\n"
  sleep 5
  sudo cp ~/git/setup/udev_rules/udev_cob.sh /etc/init.d/
  sudo update-rc.d udev_cob.sh defaults

  echo -e "\n${green}INFO: Install Touchscreen driver${NC}\n"
  sleep 5
  wget http://www.cartft.com/support/drivers/TFT/tftdrivers/eGTouch_v2.5.2107.L-x.tar.gz
  tar -xf eGTouch_v2.5.2107.L-x.tar.gz
  cd eGTouch_v2.5.2107.L-x
  chmod +x setup.sh
  sudo ./setup.sh

  echo -e "\n${green}INFO: Setup bash environment${NC}\n"
  sleep 5
  if [[ "$HOSTNAME" == "$ROBOT-pc2" ]]
    then
      sudo cp ~/git/setup/cob-pcs/cob.bash.bashrc.pc2 /etc/cob.bash.bashrc
  fi
  if [[ "$HOSTNAME" == "$ROBOT-pc1" ]]
    then
      sudo cp ~/git/setup/cob-pcs/cob.bash.bashrc.pc1 /etc/cob.bash.bashrc
  fi
  if [[ "$HOSTNAME" == "$ROBOT-pc3" ]]
    then
      sudo cp ~/git/setup/cob-pcs/cob.bash.bashrc.pc3 /etc/cob.bash.bashrc
  fi



}

#### FUNCTION NFS SETUP
function NFSSetup
{
  if [ "$MODE" == "slave" ]; then
    read -p "Please type the ip address of the server pc: " server
    read -p "Are you sure that the server pc is with $server reachable (y/n)?" choice
      case "$choice" in 
        y|Y ) echo "Yes";;
        n|N ) echo "No" && exit;;
        * ) echo "invalid"&& exit;;
      esac
  elif [ "$MODE" == "master" ]; then
    echo -e "\n${green}INFO:Installing the server pc $hostname${NC}\n"
    server=$IP
  else
    echo -e "\n${red}ERROR:Invalid installation mode ${NC}\n" 
    echo -e $usage
    exit
  fi

  echo -e "\n${green}INFO: Setup NTP time synchronitation${NC}\n"
  sleep 5
  sudo apt-get install ntp -y --force-yes
  if [ "$MODE" == "master" ]
    then
      sudo echo "server 0.pool.ntp.org" | sudo tee -a /etc/ntp.conf
      sudo echo "restrict $IP mask 255.255.255.0 nomodify notrap" | sudo tee -a /etc/ntp.conf
  elif [ "$MODE" == "slave" ]
    then
      sudo echo "server $server" | sudo tee -a /etc/ntp.conf
  fi

  echo -e "\n${green}INFO:  Install NFS${NC}\n"
  sleep 5
  sudo apt-get install nfs-kernel-server autofs -y --force-yes
  sudo mkdir /u
  if [[ "$MODE" == "master" ]]
    then
      echo "/home /u none bind 0 0" | sudo tee -a /etc/fstab
      sudo mount /u
      sudo sed -i 's/NEED_STADT\=/NEED_STADT\=yes/g' /etc/default/nfs-common
      echo "/u *(rw,fsid=0,sync,no_subtree_check)" | sudo tee -a /etc/exports
      if [ -d "/u/robot/git" ]
        then
          sudo sed -i 's/home\/robot/u\/robot/g' /etc/passwd
          read -p "Reboot the computer for the changes to take effect (y/n)?" choice
            case "$choice" in 
                y|Y ) echo "Yes" && sudo reboot;;
                n|N ) echo "No" && exit;;
                * ) echo "invalid"&& exit;;
            esac
      fi
  elif [[ "$MODE" == "slave" ]]
    then 
      ping -c 1 -w 3 $server
      if [ $? -ne 0 ] ; then
        echo -e "\n${red}ERROR:Server $server unreachable ${NC}\n"
        exit
      fi
      sudo sed -i 's/NEED_STADT\=/NEED_STADT\=yes/g' /etc/default/nfs-common
      
      sudo touch /etc/auto.direct
      sudo echo "/-  /etc/auto.direct" | sudo tee -a /etc/auto.master
      sudo echo "/u  -fstype=nfs4    $server:/" | sudo tee -a /etc/auto.direct
      sudo update-rc.d autofs defaults
      sudo service autofs restart
      sudo modprobe nfs
        
      if [ -d "/u/robot/git" ]
        then
          sudo sed -i 's/home\/robot/u\/robot/g' /etc/passwd
          read -p "Reboot the computer for the changes to take effect (y/n)?" choice
            case "$choice" in 
                y|Y ) sudo reboot;;
                n|N ) exit;;
                * ) echo "invalid"&& exit;;
            esac
      fi
  fi

}

#### FUNCTION COB SETUP
function CobSetup
{
  if [ "$HOSTNAME" != "$ROBOT-pc2" ]; then 
	  echo "FATAL: CAN ONLY BE EXECUTED ON MASTER PC"
	  exit
  fi

  echo -e "\n${green}INFO:  Setup bash environment${NC}\n"
  sleep 5
  cp ~/git/setup/cob-pcs/user.bashrc ~/.bashrc
  source /opt/ros/indigo/setup.bash
  sudo sed -i "s/myrobot/$ROBOT/g" ~/.bashrc
  sudo sed -i "s/mydistro/$ROS_DISTRO/g" ~/.bashrc
  
  echo -e "\n${green}INFO:  Create overlays for stacks${NC}\n"
  sleep 5
  mkdir /u/robot/git/care-o-bot
  mkdir /u/robot/git/care-o-bot/src
  cd /u/robot/git/care-o-bot/src
  source /opt/ros/indigo/setup.bash
  catkin_init_workspace
  cd /u/robot/git/care-o-bot
  catkin_make
  cd /u/robot/git/care-o-bot/src
  git clone https://github.com/ipa320/cob_robots
  git clone https://github.com/ipa320/cob_calibration_data
  catkin_make install
  
  
  echo -e "\n${green}INFO:  Enable passwordless login${NC}\n"
  sleep 5
  ssh-keygen
  cat /u/robot/.ssh/id_rsa.pub | ssh robot@$ROBOT-pc2 "cat >> /u/robot/.ssh/authorized_keys"
  ssh robot@$ROBOT-pc1 'exit'
  ssh robot@$ROBOT-pc3 'exit'


  echo -e "\n${green}INFO:  Enable passwordless login${NC}\n"
  sleep 5
  su root
  ssh-keygen
  ssh-copy-id $ROBOT-pc2
  ssh root@$ROBOT-pc1 'exit'
  ssh root@$ROBOT-pc3 'exit'

  
}
########################################################################
############################# INITIAL MENU #############################
########################################################################


if [[ "$@" =~ "--help" || $# < 2 ]]; then echo -e $usage; exit 0; fi

while [[ $# >=1 ]]
do
key="$1"
shift
case $key in
    -r|--robot)
    ROBOT="$1"
    shift
    ;;
    -ip|--ipaddress)
    IP="$1"
    shift
    ;;
    -m|--mode)
    MODE="$1"
    shift
    ;;
    *)
    ;;
esac
done

if [ -z "$ROBOT" ]; then
    echo -e $usage
    exit
fi

if [ -z "$IP" ]; then
    echo -e $usage
    exit
fi

if [ -z "$MODE" ]; then
    echo -e $usage
    exit
fi

echo -e "\n${green}===========================================${NC}\n"
echo -e ROBOT  = "${green}${ROBOT}${NC}"
echo -e HOSTNAME     = "${green}${HOSTNAME}${NC}"
echo -e IP ADDRESS    = "${green}${IP}${NC}"
echo -e MODE    = "${green}${MODE}${NC}"
echo -e "\n${green}===========================================${NC}\n"
read -p "Continue (y/n)?" choice
case "$choice" in 
  y|Y ) ;;
  n|N ) exit;;
  * ) echo "invalid" && exit;;
esac

read -p "Please select the installation type 
1.Basic installation
2.Setup NTP and NFS system
3.Full installation (Basic installation + Setup NFS)
4.Cob setup (Execute only on master pc and after a full installation)
 " choice 
 
if [[ "$choice" == 1 ]]
  then
       BasicInstallation
       
fi

if [[ "$choice" == 2 ]]
  then
       NFSSetup
fi

if [[ "$choice" == 3 ]]
  then
       BasicInstallation
       NFSSetup
fi

if [[ "$choice" == 4 ]]
  then
       CobSetup
fi
