#!/bin/bash

# Script for backing up home data of cob-stud-pc's.

# TODO: add date tag to backup directory
# TODO: include in chron job every weekend

# create backup directory with date
dirname="/backup/backup_weekly_"`eval date +%Y%m%d-%H%M%S`
mkdir -p $dirname

# copy data into backup directory
cp -r /home $dirname

# tar backup directory
tar -pczf $dirname.tar.gz $dirname

chmod -R +w $dirname
# delete files, only keep tar.gz
rm -rf $dirname

find /backup/backup_weekly_*.tar* -mtime +30 -exec rm {} \; 
