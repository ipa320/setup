# IPA320 Coding HowTo

This HowTo gives a short introduction into how Coding should be done in IPA320, especially with a focus on 
development within the [Robot Operating System ROS](http://wiki.ros.org/ROS/Introduction).
Thus, it is more a colletion of links to other websites and guidelines than a definite HowTo.




## ROS Basics
Most of the development within the Servicerobotics Groups in IPA320 happens using the Robot Operating System ROS.
Thus, understanding ROS is of utmost importance to understand how to install and use ROS.
There exists a lot of documentation on the [ROS wiki](http://wiki.ros.org) that gives a thorough
[introduction](http://wiki.ros.org/ROS/Introduction) and explains the concepts behin ROS.
For all people new to ROS, this is a good place to start.

### ROS distributions
Similar to Ubuntu, ROS is developed in so called distributions.
At the time of writing this, the most recent distribution is [ROS Jade](http://wiki.ros.org/jade).
However, most software at IPA320 is running using [ROS Indigo](http://wiki.ros.org/indigo), which is designed to be a 
ROS LTS (long term stable) version.
ROS Indigo targets Ubuntu 14.04 LTS, whereas ROS Jade mainly targets Ubuntu 15.04, but should support 14.04 as well.

**For now, please use ROS Indigo.**

### ROS Installation
If you are working in the IPA Apartment, you have a preinstalled PC, where ROS is configured.
Otherwise, you might have to install ROS yourself.
You can find the respective installation instructions on the ROS wiki for
[Indigo](http://wiki.ros.org/indigo/Installation) and [Jade](http://wiki.ros.org/jade/Installation) (or more general
under http://wiki.ros.org/ROSDISTRO/Installation).

### ROS Tutorials
After having read through the [ROS introduction](http://wiki.ros.org/ROS/Introduction) and having installed your system,
you should start working through the [basic ROS Tutorials](http://wiki.ros.org/ROS/Tutorials).
There, the concepts described before are shown in more detail.

Besides the basic Tutorials, there exist several Tutorials for specialized topics.
- [Care-o-Bot](http://wiki.ros.org/Robots/Care-O-bot/Tutorials)
- [Navigation](http://wiki.ros.org/navigation/Tutorials)
- [MoveIt](http://moveit.ros.org/documentation/tutorials/)
- [the ROS buildsystem `catkin`](http://wiki.ros.org/catkin/Tutorials)

### ROS Workspace Setup
In general, a ROS workspace (for more information [click here](http://wiki.ros.org/catkin/workspaces)) looks as follows:
```
workspace_folder/         -- WORKSPACE
  src/                    -- SOURCE SPACE
    CMakeLists.txt        -- The 'toplevel' CMake file
    package_1/
      CMakeLists.txt
      package.xml
      ...
    package_n/
      CMakeLists.txt
      package.xml
      ...
    repository_1/
      package_in_repo_1/
        CMakeLists.txt
        package.xml
        ...
      package_in_repo_n/
        CMakeLists.txt
        package.xml
        ...
    repository_n\
      ...
  build/                  -- BUILD SPACE
    ...
  devel/                  -- DEVELOPMENT SPACE (set by CATKIN_DEVEL_PREFIX)
    ...
  install/                -- INSTALL SPACE (set by CMAKE_INSTALL_PREFIX)
    ...
```

In short, the `source` space contains your [ROS packages](http://wiki.ros.org/Packages) which might be organised in a Git
Repository (see below for more information on Git).
The `build` space contains cache information when you build your workspace.
The `devel` workspace contains all compiled executables and libraries so that ROS can use them.
This is useful for development and testing.
The ROS packages can also be installed, this is what the `install` space is for.

Check out the [Tutorial on creating a workspace](http://wiki.ros.org/catkin/Tutorials/create_a_workspace) for how to set
it up.

### ROS nomenclature
In the following, some often occuring phrases are shortly described:
- **ROS package**: A ROS package contains the source code, configuration files and or launch files, encapsulated as
a logically distinct entity.
Thus, it can contain an algorithm for motion planning, a configuration of a robot, or tools for starting up a robot.
- **Node**: A node is an executable ROS programm.
- **Topic**: A topic is a many-to-many communication channel within ROS.
A ROS node can **subscribe** to a topic to get the messages sent on it or **publish** its own message to a topic.
ROS topics can be **remapped** using launch files, i.e. the name of them can be changed.
- **Service**: A ROS service is a one-to-one communication channel between two ROS nodes, providing a
Request-Response pattern.
- **Action**: A ROS action is similar to a service, except that you it includes a Feedback channel.
Thus, you have a Goal-Feedback-Result pattern.
- **`catkin`**: catkin is the build tool used within ROS.
It is described in more detail below.
`catkin` replaced `rosbuild` as build tool.
- **Stack**: A ROS stack is the old notion of logically connected packages, like for navigation.
Earlier, a stack has usually been the same as a repository.
Today, the notion of a stack has been replaced by the notion of `meta-packages`.
- **Launch File**: A Launch File is a file for starting one or more ROS nodes.
It has an XML-based syntax.
- **Configuration or YAML File**: YAML files are used for configuring ROS nodes using parameters that are read from the
ROS nodes
- **`roscore` or `rosmaster`**: The main ROS program, coordinating how nodes communicate.
You can start it using the `roscore` command.
It is also started automatically once you start a launchfile.

### ROS Coding Styles
Within ROS, there exist Coding Styles for [`C++`](http://wiki.ros.org/CppStyleGuide),
[`python`](http://wiki.ros.org/PyStyleGuide) and [`JavaScript`](http://wiki.ros.org/JavaScriptStyleGuide).
If you create a new package, please try to adhere to those guidelines as much as possible.
**Note** that those guidelines usually build on top of other style guides which should be used for reference as well.

However, if you edit an existing package, **stick to the coding style therein**!
This especially holds for indentation, as having this unified within one file greatly improves readability.

All available editors allow configuration of indentation setinngs, and most even support automatic detection on opening
a new file.

### Further Reading on ROS
For ROS, there is a lot of documentation available on the net (even though some is outdated).
First, always check the [ROS wiki](http://wiki.ros.org), if you have questions about ROS.
Check out the ROS wiki pages for the respective packages that you are using.
**Note** that all private ROS repositories cannot be found on the ROS wiki.

A second source of information is the [ROS answers](http://answers.ros.org) homepage.
A lot of questions have been answered there.
If you register, you can also ask (and obviously also answer) questions to the ROS community.
However, try to be as clear as possible in your question (best also give your system configuration and ROS distribution)
to get a good answer.




## Compiling ROS packages

### Setting up your `CMakeLists.txt`

### Setting up your `package.xml`

### Checking your package configuration




## Git Basics

### Git Tutorials

### Git Workflow

### Getting your Code into the `ipa320` repository

### Git Dos and Don'ts

### Further Reading on Git




## Further Reading within IPA320
There also exist some additional ReadMe's and manuals that give introductions and provide guidelines
how to work at IPA and with the Care-O-bot and rob@work.
Check out the [IPA Manual](https://github.com/ipa320/setup/raw/master/manual_ipa/IPA_manual.pdf) and the 
[Care-o-bot Manual](https://github.com/ipa320/setup/raw/master/manual_cob3Indigo/Care-O-bot_manual.pdf).
You can find those PDFs and the source files hosted on [GitHub](https://github.com/ipa320/setup).




## HowTo-HowTo
This document is written using [Github Flavored markdown](https://help.github.com/articles/github-flavored-markdown/).
If you want to check what the document looks like without uploading it to GitHub, you can use
[`grip`](https://github.com/joeyespo/grip).

Install it using
```bash
pip install grip
```
Then call
```bash
grip CodingHowTo.md
```
launch your browser and connect to `http://localhost:6149`.

**Note** that you still require an internet connection for this to work.