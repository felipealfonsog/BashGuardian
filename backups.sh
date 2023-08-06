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
BACKUP_IN_MAC=true

# Configuration variables
BACKUP_SCRIPT_DIR="$HOME/Downloads/bash-backups-scripts/backups.sh"  # path to the actual script location
SOURCE_DIR="$HOME/Downloads"       # path to the directory to be backed up
BACKUP_DIR="$HOME/Documents/backups-mac"  # path to the directory where backups will be saved
DIR_BACKUPS_EXTERNAL="/Volumes/2TBMACSDBK/"  # Path to copy the .gpg file to the SD card

backup_file="$BACKUP_DIR/backup_$(date +%Y%m%d_%H%M%S).tar.gz"

#********************************
#HERE ENTER THE PASSWORD TO ENCRYPT THE FILES
#********************************
ENCRYPT_PASSWORD="-----"
#********************************


DAYS_TO_KEEP_BACKUPS=3

# Cron interval variables
CRON_MINUTE=*     # Set the minute in integers (0-59)
CRON_HOUR=0       # Set the hour in integers (0-23)
CRON_DAY=*        # Set the day of the month in integers (1-31)
CRON_MONTH=*      # Set the month in integers (1-12). Month 7 corresponds to July.
CRON_YEAR=*      # Set the year or * for any year


#Function to create backyo directory 
function create_backup_directory() {
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
        echo "Backup directory created at: $BACKUP_DIR"
    fi
}

function perform_backup() {
    create_backup_directory

    echo "Performing backup to: $backup_file"
    tar -czf "$backup_file" -C "$SOURCE_DIR" .
    echo "Encrypting the backup..."
    gpg --batch --yes --passphrase "$ENCRYPT_PASSWORD" -c "$backup_file"
    if [ -f "$backup_file.gpg" ]; then
        echo "Backup and encryption completed."
        rm -rf "$backup_file"  # Permanently remove the unencrypted file after encryption
        (crontab -l 2>/dev/null; echo "$CRON_MINUTE $CRON_HOUR $CRON_DAY $CRON_MONTH $CRON_YEAR $BACKUP_SCRIPT_DIR") | crontab -
    else
        echo "ERROR! Encrypted file not found. Encryption may have failed."
        exit 1  # Exit the script with an error status
    fi
}

function clean_old_backups() {
    find "$BACKUP_DIR" -name "backup_*.tar.gz.gpg" -mtime +$DAYS_TO_KEEP_BACKUPS -exec rm -rf {} \;
    echo "Old local backups cleaned."

    find "$DIR_BACKUPS_EXTERNAL" -name "backup_*.tar.gz.gpg" -mtime +$DAYS_TO_KEEP_BACKUPS -exec rm -rf {} \;
    echo "Old external backups cleaned."
}

function copy_backup_external() {

    # Copy the .gpg file to the desired location (variable DIR_BACKUPS_EXTERNAL) and display progress
    cp -p "$backup_file.gpg" "$DIR_BACKUPS_EXTERNAL"

    # Check if the copy operation was successful
    if [ $? -eq 0 ]; then
        echo ".gpg file copied to: $DIR_BACKUPS_EXTERNAL"
    else
        echo "Error: Copying .gpg file to external directory failed."
    fi
}


function print_usage() {
    echo "Usage: $0 [options]"
    echo "Available options:"
    echo "    -h, --help                   Display this help message"
    echo "    --no-cron                    Do not add the script to cron"
    echo "    --cron-minute MINUTE         Set the minute for cron (default: $CRON_MINUTE_MAC)"
    echo "    --cron-hour HOUR             Set the hour for cron (default: $CRON_HOUR_MAC)"
    echo "    --cron-day DAY               Set the day of the month for cron (default: $CRON_DAY_MAC)"
    echo "    --cron-month MONTH           Set the month for cron (default: $CRON_MONTH_MAC)"
    echo "    --cron-year YEAR             Set the year for cron (default: $CRON_YEAR_MAC)"
}

if [ "$1" = "--no-cron" ]; then
    perform_backup
else
    while [ "$1" != "" ]; do
        case $1 in
            -h | --help )
                print_usage
                exit
                ;;
            --no-cron )
                perform_backup
                exit
                ;;
            --cron-minute )
                shift
                CRON_MINUTE=$1
                ;;
            --cron-hour )
                shift
                CRON_HOUR=$1
                ;;
            --cron-day )
                shift
                CRON_DAY=$1
                ;;
            --cron-month )
                shift
                CRON_MONTH=$1
                ;;
            --cron-year )
                shift
                CRON_YEAR=$1
                ;;
            * )
                echo "Unknown option: $1"
                print_usage
                exit 1
                ;;
        esac
        shift
    done

    # Add the script to cron
    perform_backup
    (crontab -l 2>/dev/null; echo "$CRON_MINUTE $CRON_HOUR $CRON_DAY $CRON_MONTH $CRON_YEAR $BACKUP_SCRIPT_DIR") | crontab -
    copy_backup_external
fi

clean_old_backups

# set +x  # Disable command tracing
