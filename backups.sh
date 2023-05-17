#!/bin/bash
#
#----------
#BACKUP SYSTEM IN BASH
#DEVELOPED BY Felipe Alfonso Gonzalez
#f.alfonso@res-ear,ch
#----------
#
#

#path from backup
#/home/felipe/backups
#
#path to backup
#/run/media/felipe/341A-4340
#



timestamp="$(date +'%b-%d-%y')"
# eventually 'sudo'
# tar -cf /Volumes/2TBMACSDBK/backup-${timestamp}.tar.gz /Volumes/Macintosh/ HD/Users/felipe/Downloads
#
tar -cvpzf /run/media/felipe/341A-4340/backups-sdfcscx/backup-${timestamp}.tar.gz --absolute-names /home/felipe/backups



# Compress the folder with foldername + date and take backup
#filename="backup_`date +%d`_`date +%m`_`date +%Y`.tar";

# Create compressed file using tar and move to backup folder
#tar cvf /backupfolder/$filename home/nishkarshraj/Desktop/HelloWorld


# new lines




