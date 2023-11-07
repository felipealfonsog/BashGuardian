#!/bin/bash

# Configurable variables
ENCRYPT_BACKUP=false
ENCRYPT_PASSWORD=""
ADD_TO_CRON=false
CRON_MINUTE=*
CRON_HOUR=0
CRON_DAY=*
CRON_MONTH=*
CRON_YEAR=*

# Default backup directories
DIR_SRC_MACOS="$HOME/Downloads"
DIR_SRC_LINUX="$HOME/backups"
DIR_BACKUP_MACOS="/Volumes/2TBMACSDBK/backups"
DIR_BACKUP_LINUX="/run/media/felipe/0C91-9A88/backups"

# Function to display the welcome message
function show_welcome_message() {
    echo "
    ▒█▀▀█ █▀▀█ █▀▀ █░░█ ▒█▀▀█ █░░█ █▀▀█ █▀▀█ █▀▀▄ ░▀░ █▀▀█ █▀▀▄ 
    ▒█▀▀▄ █▄▄█ ▀▀█ █▀▀█ ▒█░▄▄ █░░█ █▄▄█ █▄▄▀ █░░█ ▀█▀ █▄▄█ █░░█ 
    ▒█▄▄█ ▀░░▀ ▀▀▀ ▀░░▀ ▒█▄▄█ ░▀▀▀ ▀░░▀ ▀░▀▀ ▀▀▀░ ▀▀▀ ▀░░▀ ▀░░▀

    *************************
        Welcome to BashGuardian 
    *************************
    Script by Computer Science Engineer: Felipe Alfonso González
    Contact: f.alfonso@res-ear.ch
    License: MIT (restrictive) and BSD v3

    From Chile with ❤️

    For encryption/decryption instructions:
    gpg --decrypt --batch --passphrase your_passphrase encrypted_file.tar.gz.gpg | tar xzvf -
    gpg --decrypt --batch --passphrase \"your_passphrase\" \"encrypted_file.tar.gz.gpg\" | tar xzvf - --directory \"$HOME/Documents\"
    "

    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  --encrypt              Encrypt the backup"
    echo "  --password PASSWORD   Set the encryption password"
    echo "  --cron                 Add script to cron"
    echo "  --cron-minute MIN     Set the minute for cron (default: $CRON_MINUTE)"
    echo "  --cron-hour HOUR       Set the hour for cron (default: $CRON_HOUR)"
    echo "  --cron-day DAY         Set the day of the month for cron (default: $CRON_DAY)"
    echo "  --cron-month MONTH     Set the month for cron (default: $CRON_MONTH)"
    echo "  --cron-year YEAR       Set the year for cron (default: $CRON_YEAR)"
    echo "  -h, --help             Display this help message"
}

# Function to perform backup on MacOS
function perform_backup_macos() {
    create_backup_directory_macos

    local backup_file="$DIR_BACKUP_MACOS/backups_macos_$(date +%Y%m%d_%H%M%S).tar.gz"

    echo "Performing backup to: $backup_file"
    tar -czf "$backup_file" -C "$DIR_SRC_MACOS" .
    echo "Backup completed."

    if [ "$ENCRYPT_BACKUP" = true ]; then
        encrypt_backup "$backup_file"
    fi

    if [ "$ADD_TO_CRON" = true ]; then
        (crontab -l 2>/dev/null; echo "$CRON_MINUTE $CRON_HOUR $CRON_DAY $CRON_MONTH $CRON_YEAR $0") | crontab -
        echo "Script added to cron."
    fi

    clean_old_backups_macos
}

# Function to perform backup on Linux
function perform_backup_linux() {
    create_backup_directory_linux

    local backup_file="$DIR_BACKUP_LINUX/backups_linux_$(date +%Y%m%d_%H%M%S).tar.gz"

    echo "Performing backup to: $backup_file"
    tar -czf "$backup_file" -C "$DIR_SRC_LINUX" .
    echo "Backup completed."

    if [ "$ENCRYPT_BACKUP" = true ]; then
        encrypt_backup "$backup_file"
    fi

    if [ "$ADD_TO_CRON" = true ]; then
        (crontab -l 2>/dev/null; echo "$CRON_MINUTE $CRON_HOUR $CRON_DAY $CRON_MONTH $CRON_YEAR $0") | crontab -
        echo "Script added to cron."
    fi

    clean_old_backups_linux
}

# Function to perform backup encryption
function encrypt_backup() {
    local backup_file="$1"

    echo "Encrypting the backup..."
    gpg --batch --yes --passphrase "$ENCRYPT_PASSWORD" -c "$backup_file"
    if [ -f "$backup_file.gpg" ]; then
        echo "Encryption completed."
        rm -rf "$backup_file"  # Permanently remove the unencrypted file after encryption
    else
        echo "ERROR! Encrypted file not found. Encryption may have failed."
        exit 1  # Exit the script with an error status
    fi
}

# Function to create backup directory on MacOS
function create_backup_directory_macos() {
    local backup_dir="$DIR_BACKUP_MACOS"

    if [ ! -d "$backup_dir" ]; then
        mkdir -p "$backup_dir"
        echo "Backup directory created at: $backup_dir"
    fi
}

# Function to create backup directory on Linux
function create_backup_directory_linux() {
    local backup_dir="$DIR_BACKUP_LINUX"

    if [ ! -d "$backup_dir" ]; then
        mkdir -p "$backup_dir"
        echo "Backup directory created at: $backup_dir"
    fi
}

# Function to clean old backups on MacOS
function clean_old_backups_macos() {
    local backup_dir="$DIR_BACKUP_MACOS"

    find "$backup_dir" -name "backups_*" -mtime +7 -exec rm -rf {} \;
    echo "Old backups cleaned."
}

# Function to clean old backups on Linux
function clean_old_backups_linux() {
    local backup_dir="$DIR_BACKUP_LINUX"

    find "$backup_dir" -name "backups_*" -mtime +7 -exec rm -rf {} \;
    echo "Old backups cleaned."
}

# Process command line arguments
while [ "$1" != "" ]; do
    case $1 in
        --encrypt )
            ENCRYPT_BACKUP=true
            ;;
        --password )
            shift
            ENCRYPT_PASSWORD="$1"
            ;;
        --cron )
            ADD_TO_CRON=true
            ;;
        --cron-minute )
            shift
            CRON_MINUTE="$1"
            ;;
        --cron-hour )
            shift
            CRON_HOUR="$1"
            ;;
        --cron-day )
            shift
            CRON_DAY="$1"
            ;;
        --cron-month )
            shift
            CRON_MONTH="$1"
            ;;
        --cron-year )
            shift
            CRON_YEAR="$1"
            ;;
        -h | --help )
            show_welcome_message
            exit
            ;;
        * )
            echo "Unknown option: $1"
            show_welcome_message
            exit 1
            ;;
    esac
    shift
done

# Display the welcome message
show_welcome_message

# Detect the operating system and perform the backup
case "$(uname)" in
    Darwin )
        perform_backup_macos
        ;;
    Linux )
        perform_backup_linux
        ;;
    * )
        echo "Unsupported operating system."
        exit 1
        ;;
esac
