#!/bin/bash

# Script for backing up home data of cob-stud-pc's.

# TODO: add date tag to backup directory
# TODO: include in chron job every weeckend

# create backup directory with date
dirname="/backup/backup_monthly_"`eval date +%Y%m`
mkdir -p $dirname

# copy data into backup directory
cp -r /home $dirname

# tar backup directory
tar -pczf $dirname.tar.gz $dirname

chmod -R +w $dirname
# delete files, only keep tar.gz
rm -rf $dirname
