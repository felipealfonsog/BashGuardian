#!/bin/bash

# set -x  # Traza de comandos

# Variables para habilitar/deshabilitar el respaldo en Linux y macOS
BACKUP_IN_LINUX=true
BACKUP_IN_MAC=true

# Variables de configuración
BACKUP_SCRIPT_DIR="$HOME/Downloads/bash-backups-scripts/backups.sh"  # Cambia esta ruta a la ubicación real del script
SOURCE_DIR="$HOME/Downloads"       # Cambia esta ruta al directorio que deseas respaldar
BACKUP_DIR="/Volumes/2TBMACSDBK"  # Cambia esta ruta al directorio donde deseas guardar los respaldos

ENCRYPT_PASSWORD="-------"
#to decrypt the file and it's gonna untar it : gpg --decrypt --batch --passphrase your_passphrase encrypted_file.tar.gz.gpg | tar xzvf -



DAYS_TO_KEEP_BACKUPS=3

CRON_MINUTE_LINUX=*     # Configura el minuto en números enteros (0-59)
CRON_HOUR_LINUX=0       # Configura la hora en números enteros (0-23)
CRON_DAY_LINUX=1        # Configura el día del mes en números enteros (1-31)
CRON_MONTH_LINUX=7      # Configura el mes en números enteros (1-12). Mes 7 corresponde a julio.
CRON_YEAR_LINUX=*      # Configura el año o * para cualquier año

# Variables de intervalo de tiempo para cron en macOS
CRON_MINUTE_MAC=*       # Configura el minuto en números enteros (0-59)
CRON_HOUR_MAC=0         # Configura la hora en números enteros (0-23)
CRON_DAY_MAC=1          # Configura el día del mes en números enteros (1-31)
CRON_MONTH_MAC=7        # Configura el mes en números enteros (1-12). Mes 7 corresponde a julio.
CRON_YEAR_MAC=*        # Configura el año o * para cualquier año

function create_backup_directory() {
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
        echo "Directorio de respaldo creado en: $BACKUP_DIR"
    fi
}

function perform_backup() {
    create_backup_directory
    local backup_file="$BACKUP_DIR/backup_mac_$(date +%Y%m%d_%H%M%S).tar.gz"
    echo "Realizando respaldo en: $backup_file"
    tar -czf "$backup_file" -C "$SOURCE_DIR" .
    echo "Encriptando el respaldo..."
    gpg --batch --yes --passphrase "$ENCRYPT_PASSWORD" -c "$backup_file"
    if [ -f "$backup_file.gpg" ]; then
        echo "Respaldo y encriptación completados."
        rm -P "$backup_file"  # Eliminar el archivo sin encriptar permanentemente después de la encriptación
    else
        echo "¡ERROR! No se pudo encontrar el archivo encriptado. La encriptación pudo haber fallado."
    fi
}

function clean_old_backups() {
    find "$BACKUP_DIR" -name "backup_mac_*.tar.gz.gpg" -mtime +$DAYS_TO_KEEP_BACKUPS -exec rm -P {} \;
    echo "Backups antiguos limpiados."
}


if [ "$(uname)" = "Linux" ] && [ "$BACKUP_IN_LINUX" = true ]; then
    perform_backup
    (crontab -l 2>/dev/null; echo "$CRON_MINUTE_LINUX $CRON_HOUR_LINUX $CRON_DAY_LINUX $CRON_MONTH_LINUX $CRON_YEAR_LINUX $BACKUP_SCRIPT_DIR") | crontab -
elif [ "$(uname)" = "Darwin" ] && [ "$BACKUP_IN_MAC" = true ]; then
    perform_backup
    (crontab -l 2>/dev/null; echo "$CRON_MINUTE_MAC $CRON_HOUR_MAC $CRON_DAY_MAC $CRON_MONTH_MAC $CRON_YEAR_MAC $BACKUP_SCRIPT_DIR") | crontab -
else
    echo "Sistema operativo no soportado o backup deshabilitado para este sistema."
    exit 1
fi

clean_old_backups
