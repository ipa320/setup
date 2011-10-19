#!/usr/bin/env bash

# Script for backing up home data of cob-stud-pc's.

# TODO: add date tag to backup directory
# TODO: include in chron job every weeckend
scp -r admin@cob-kitchen-server:/home/uhr ~/backup 
