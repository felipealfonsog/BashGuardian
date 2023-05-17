#!/bin/bash
#
#----------
#BACKUP SYSTEM IN BASH
#DEVELOPED BY Felipe Alfonso Gonzalez
#f.alfonso@res-ear,ch
#----------
#
#
find "/run/media/felipe/341A-4340/backups-sdfcscx" -type f -mtime +5 -exec rm {} \;
