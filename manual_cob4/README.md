# Care-O-bot 4 Manual


Heading-a
==========

---text---

Heading-b
------------

--- text ---

Heading-c
----------

--- text---

Heading-d
=========

--- text----

Heading-e
---


## Contents

1. <a href="#1--Administrator Manual">Administrator Manual</a>
    a. <a href="#Setup robot pcs">Setup robot pcsl</a>
2. <a href="#2-User Manual">User Manual</a>

## 1. Administrator Manual

The following administrator manual requires some enhanced knowledge about:
* Linux/Ubuntu
* Network configuration
* Source code management with git
* ROS installation and usage

If you are missing some of this requirements or feel uncomfortable with what you are doing, please interrupt and ask somebody to help you before continuing.

### Setup robot pcs

On all Care-O-bot 4 there are at least six pcs... 

#### Install operating system

The first step is to install the operating system for each base, torso and sensorring pc. We are using Ubuntu as the main operating system for the robot. We recommend to install the Ubuntu 12.4 LTS (long term stable) 64-bit version because this version is well tested to work with the hardware. First please install Ubuntu (English version) creating a normal swap partition. Please choose robot as an admin account with a really safe password which should only be known to the local robot administrator. 

The hostnames of the pcs should be:

Base pc:
* cob4-X-b1

Torso pcs:
* cob4-X-t1
* cob4-X-t2
* cob4-X-t3

Sensorring pc:
* cob4-X-s1

Head pc:
* cob4-X-h1

#### Install basic tools

In the case of the NUC pcs it is necessary install the Ethernet driver [e1000e](http://sourceforge.net/projects/e1000/)

Next we have to install some basic tools for the further setup of the pcs. In order to install the packages a internet connection is needed.


```
sudo apt-get update
sudo apt-get install vim tree gitg meld curl openjdk-6-jdk zsh terminator language-pack-de language-pack-en ipython
```
#### Setup ssh server

Install openssh server on all robot pcs

```
sudo apt-get install openssh-server
```
Let the server send a alive interval to clients to not get a broken pipe. Execute the following line on all robot pcs:

```
echo "ClientAliveInterval 60" | sudo tee -a /etc/ssh/sshd_config
```

#### Setup robot account for administration tasks

To facilitate the further setup we created a setup repository with some helpful scripts. To checkout the setup repository use:

```
mkdir ~/git
cd ~/git
git clone git://github.com/ipa320/setup.git
```

Allow robot user to execute sudo command without password. Add robot ALL=(ALL) NOPASSWD: ALL to /etc/sudoers on all robot pcs

```
sudo visudo -f /etc/sudoers
```

#### Setup root local account

Enable root account on all robot pcs

```
ssh cob4-X-yZ
sudo passwd root
```






