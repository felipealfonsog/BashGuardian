#!/bin/bash

echo "

▒█▀▀█ █▀▀█ █▀▀ █░░█ ▒█▀▀█ █░░█ █▀▀█ █▀▀█ █▀▀▄ ░▀░ █▀▀█ █▀▀▄ 
▒█▀▀▄ █▄▄█ ▀▀█ █▀▀█ ▒█░▄▄ █░░█ █▄▄█ █▄▄▀ █░░█ ▀█▀ █▄▄█ █░░█ 
▒█▄▄█ ▀░░▀ ▀▀▀ ▀░░▀ ▒█▄▄█ ░▀▀▀ ▀░░▀ ▀░▀▀ ▀▀▀░ ▀▀▀ ▀░░▀ ▀░░▀

"
echo "*************************"
echo " Welcome to BashGuardian "
echo "*************************"
echo ""

echo "************************************************"
echo "To decrypt the file and extract its content: 
gpg --decrypt --batch --passphrase your_passphrase encrypted_file.tar.gz.gpg | tar xzvf -"
echo "************************************************"
echo "To extract in a specific folder and decrypt it:  
gpg --decrypt --batch --passphrase \"your_passphrase\" \"encrypted_file.tar.gz.gpg\" | tar xzvf - --directory \"$HOME/Documents\""
echo "************************************************"
echo " -h, --help (To get more options when you execute the bash file, e.g.: $./backups.sh --help)"
echo ""

# set -x  # Enable command tracing

# Variables to enable/disable backup on Linux and macOS
BACKUP_IN_LINUX=true
BACKUP_IN_MAC=false

# Configuration variables
BACKUP_SCRIPT_DIR="$HOME/Downloads/backups.sh"  # path to the actual script location
SOURCE_DIR="$HOME/Downloads"       # path to the directory to be backed up
# Linux
# /run/media/felipe/0C91-9A88/backups
#
BACKUP_DIR="/Volumes/2TBMACSDBK/backups"  # path to the directory where backups will be saved
DIR_BACKUPS_EXTERNAL="/Volumes/2TBMACSDBK/backups"  # Path to copy the .gpg file to the SD card

backup_file="$BACKUP_DIR/backup_mac_$(date +%Y%m%d_%H%M%S).tar.gz"

#********************************
#HERE ENTER THE PASSWORD TO ENCRYPT THE FILES
#********************************
ENCRYPT_PASSWORD="fafarafa"
#********************************


DAYS_TO_KEEP_BACKUPS=3

# Cron interval variables
#CRON_MINUTE=*     # Set the minute in integers (0-59)
#CRON_HOUR=0       # Set the hour in integers (0-23)
#CRON_DAY=*        # Set the day of the month in integers (1-31)
#CRON_MONTH=*      # Set the month in integers (1-12). Month 7 corresponds to July.
#CRON_YEAR=*      # Set the year or * for any year


#Function to create backyo directory 
function create_backup_directory() {
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
        echo "Backup directory created at: $BACKUP_DIR"
    fi
}

function perform_backup() {
    #create_backup_directory

    echo "Performing backup to: $backup_file"
    tar -czf "$backup_file" -C "$SOURCE_DIR" .
    echo "Backup completed." 
   
   
   # echo "Encrypting the backup..."
   # gpg --batch --yes --passphrase "$ENCRYPT_PASSWORD" -c "$backup_file"
   
  
  # if [ -f "$backup_file.gpg" ]; then
       # echo "Backup and encryption completed."
       # rm -rf "$backup_file"  # Permanently remove the unencrypted file after encryption
       # (crontab -l 2>/dev/null; echo "$CRON_MINUTE $CRON_HOUR $CRON_DAY $CRON_MONTH $CRON_YEAR $BACKUP_SCRIPT_DIR") | crontab -
   # else
     #   echo "ERROR! Encrypted file not found. Encryption may have failed."
      #  exit 1  # Exit the script with an error status
    #fi
}


perform_backup

#clean_old_backups

# set +x  # Disable command tracing
#
#

