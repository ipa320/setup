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


### ROS terminology
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

### Preparing your changes for a Pull Request




## `Git` Basics
At IPA320, and as a matter of fact for most ROS package out there, we use a 
[VCS (Version Control System)](https://en.wikipedia.org/wiki/Revision_control) called
[**`Git`**](https://en.wikipedia.org/wiki/Git_%28software%29).
`Git` is a so called Distributed VCS, as it allows you to always check out the full history of the Source Code
Repository you are working on, and not only a specific snapshot.
This makes `Git` a very powerful tool and it is ideally suited to be used in a development environment with many people
working on the same repository.

Our repositories are hosted at [`GitHub`](https://github.com) in an organisation called
[IPA320](https://github.com/ipa320).
Many repositories, especially for the Care-O-bot, are open source, but some are also not publicly available.
There you can always get the latest state of development.


### `Git` terminology
In the following, some often occuring phrases are shortly described:
- **Repository**: The repository is where files' current and historical data are stored, often on a server.
- **Fork**: A fork is a copy of a repository (on GitHub).
This can be used to save changes without having to save them on the main repository (where you usually don't have write
access).
Thus, this is the way to get your changes into the main repository, as described below.
- **Clone**: Cloning means creating a local repository containing the revisions from another repository. 
- **Commit**: To commit is to write the changes made in the working copy back to the repository.
- **Merge**: A merge is an operation in which two sets of changes are applied to a file or set of files.
- **Branch**: A set of files under version control may be branched at a point in time so that, from that time forward,
two copies of those files may develop at different speeds or in different ways independently of each other.
Usually, you develop a new feature on a branch and then merge it into the main branch once it is done.
- **Pull**: Copy revisions from one repository into another.
Pull is initiated by the receiving repository, i.e . you get the changes from a remote repository into your local one.
- **Push**: Push is initiated by the source. I.e. you bring your changes to a remote repository.
- **Pull Request**: To bring your changes from your fork to the main repository, you issue a Pull Request on GitHub.
This notifies the maintainers of the repository that you have a feature developed that you want to integrate.


### `Git` Tutorials and Guides
There exist several tutorials about `Git` on the web with respective drawbacks and advantages.
Here is a list of some of them:
- [interactive guide](http://try.github.io/levels/1/challenges/1) for git.
Nice, but covers not everything.
Read everything on the page before typing in the commands.
- [really simple guide, \<Quote\>no deep shit\</Quote\>](http://rogerdudler.github.io/git-guide/).
Looks bad, but covers the essentials.
- [Technical guide, showing what git does internally](http://marklodato.github.io/visual-git-guide/index-en.html)
- [Good guide for understanding the theory behind git](http://think-like-a-git.net/).
However some more examples could be helpful.

### `Git` Workflow
The structure that we usually follow at IPA is shown in the following figure:

![Git Repository Structure](figures/GitHub_Repos.png)

Create a fork of the main ipa320 repository you want to work on.
Clone this repository to your local computer and do some work there.
Commit your changes and push them to your fork.
You can then issue a Pull Request to the main repository and update your changes.

You can obviously always pull from both, the main repository or your fork to get any changes from there into your current
local copy.

### Issuing a Pull Request
To issue a Pull Request, you need to have your changes on your Fork on GitHub, preferably on a feature branch.
Then, go to the repository where you want your changes to go.
Usually, this is 
```
https://github.com/ipa320/<REPO>
```
There, click on the Pull Request tab
![Git Repository Structure](figures/PR_tab.png)
and then on `New Pull Request` in the top right corner.
![Git Repository Structure](figures/PR_new.png)
Then you can choose from which repository (you might have to click `compare across forks`) and which branch you want to
have the Pull Request.
GitHub now provides you with an overview of the commits you have made and indicates, whether this PR can be merged.
![Git Repository Structure](figures/PR_compare.png)
Thus, you can review your changes again, give the PR a meaningful name and add an explanation about what has changed.
Then click on `Create Pull Request`.

Once you have sent a Pull Request, the package maintainers will review the PR and merge it, if it is okay.
If they find something they want to be changed, they will usually use the comment function on the PR.
Fix the requested changes and update the PR by simply pushing again to the branch from which you set up the PR in the
first place.

### `Git` Do's and Dont's
**Do**:
- commit often.
- provide meaningful commit messages ('test' or 'debugging' is not a good commit message).
- commit one set of (logically related) changes.
I.e. if you fix two bugs, make to commits.
- ask if you are not sure what 'git' will do or your repository is in a strange state.
- review what you will commit using `git status`
- update your repositories regularly.

**Don't**:
- commit a state that does not compile.
- add any files with filemode 755 (i.e. executable files) except for python executables (`.py` containing the `__main__`
function) and `dynamic_reconfigure` configurations (usually located in `<PACKAGE>/cfg/<NAME>.cfg>`).
Regular files have filemode 644.
- commit any temporary files.
- commit any autogenerated files (except for where they are created from a template, e.g. using 
[BRIDE](http://wiki.ros.org/bride)).
- commit any binaries.
- commit large whitespace changes intermixed with changes to the source code.
- create unnecessary merge commits by pulling in changes.


### Further Reading on `Git`
You can find additional information about git in the following resources.
- [The main git resource page](http://git-scm.com/).
Will help a lot, when you already know what you are looking for.
- [GitHub help page](https://help.github.com/).
Answers almost all questions related to GitHub.
- There is also a freely available [Book on Git](https://git-scm.com/book/en/v2).




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

Any (drawn) figures are created using the online tool at https://www.draw.io/.
The source of those files resides in the `figures/src` subdirectory.