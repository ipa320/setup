# IPA320 Coding HowTo

This HowTo gives a short introduction into how Coding should be done in IPA320, especially with a focus on 
development within the [Robot Operating System ROS](http://wiki.ros.org/ROS/Introduction).
Thus, it is more a colletion of links to other websites and rough guidelines than a definite HowTo.


## ROS Basics

### ROS Installation

### ROS Workspace Setup

### ROS Tutorials

### ROS Coding Styles
Within ROS, there exist some Coding Styles for [`C++`](http://wiki.ros.org/CppStyleGuide),
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
to get a thorough answer.

## Compiling ROS packages

### Setting up your `CMakeLists.txt`

### Setting up your `package.xml`

### Checking your package configuration


## Git Basics

### Git Tutorials

### Git Workflow

### Getting your Code into the main repository

### Further Reading on Git


## HowTo-HowTo
This document is written using [Github Flavored markdown](https://help.github.com/articles/github-flavored-markdown/).
If you want to check what the document looks like without uploading it to GitHub, you can use grip.
To install it, call
```bash
pip install grip
```
Then call
```bash
grip CodingHowTo.md
```
launch your browser and connect to `localhost:6149`.

**Note** that you still require an internet connection to do this.