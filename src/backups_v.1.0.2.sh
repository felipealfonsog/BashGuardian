#!/bin/bash

# Variables de configuración
SCRIPT_PATH="/ruta/del/directorio/del/script"  # Cambia esta ruta a la ubicación real del script
BACKUP_DIR="/ruta/del/directorio/de/backups"
SD_CARD_DIR="/ruta/de/la/sd/card"
ENCRYPT_PASSWORD="tu_contraseña_de_encriptacion"
DAYS_TO_KEEP_BACKUPS=3
CONTINUOUS_BACKUPS=true

# Variable de año en el cronjob
CRON_YEAR=$(date +%Y)  # Obtiene el año actual

# Rutas completas de los scripts de backup y directorio a respaldar
BACKUP_SCRIPT_PATH="$SCRIPT_PATH/ruta/del/script_de_backup.sh"
DIRECTORY_TO_BACKUP="$SCRIPT_PATH/ruta/del/a_hacer_backup"

# Nombre del archivo de backup
BACKUP_FILENAME="backup_$(date +%Y%m%d_%H%M%S).tar.gz"

# Variables de intervalo de tiempo para cron en Linux
CRON_MINUTE_LINUX=0     # Configura el minuto en números enteros (0-59)
CRON_HOUR_LINUX=0       # Configura la hora en números enteros (0-23)
CRON_DAY_LINUX=1        # Configura el día del mes en números enteros (1-31)
CRON_MONTH_LINUX=7      # Configura el mes en números enteros (1-12). Mes 7 corresponde a julio.
CRON_YEAR_LINUX=$CRON_YEAR  # Obtiene el año actual

# Variables de intervalo de tiempo para cron en macOS
CRON_MINUTE_MAC=0       # Configura el minuto en números enteros (0-59)
CRON_HOUR_MAC=0         # Configura la hora en números enteros (0-23)
CRON_DAY_MAC=1          # Configura el día del mes en números enteros (1-31)
CRON_MONTH_MAC=7        # Configura el mes en números enteros (1-12). Mes 7 corresponde a julio.
CRON_YEAR_MAC=$CRON_YEAR  # Obtiene el año actual

# Función para realizar el backup y encriptarlo
function perform_backup() {
    local backup_file="$BACKUP_DIR/$BACKUP_FILENAME"
    tar -czf "$backup_file" "$DIRECTORY_TO_BACKUP"
    gpg --batch --yes --passphrase "$ENCRYPT_PASSWORD" -c "$backup_file"
    rm "$backup_file"  # Eliminar el archivo sin encriptar después de la encriptación
}

# Función para limpiar backups antiguos
function clean_old_backups() {
    find "$BACKUP_DIR" -name "backup_*.tar.gz.gpg" -mtime +$DAYS_TO_KEEP_BACKUPS -exec rm {} \;
}

# Función para configurar el cronjob en Linux
function configure_cron_linux() {
    local cron_interval="$CRON_MINUTE_LINUX $CRON_HOUR_LINUX $CRON_DAY_LINUX $CRON_MONTH_LINUX $CRON_YEAR_LINUX"
    (crontab -l 2>/dev/null; echo "$cron_interval $BACKUP_SCRIPT_PATH") | crontab -
}

# Función para configurar el cronjob en macOS
function configure_cron_mac() {
    local cron_interval="$CRON_MINUTE_MAC $CRON_HOUR_MAC $CRON_DAY_MAC $CRON_MONTH_MAC $CRON_YEAR_MAC"
    (crontab -l 2>/dev/null; echo "$cron_interval $BACKUP_SCRIPT_PATH") | crontab -
}

# Verificar el sistema operativo
if [ "$(uname)" = "Linux" ] && [ "$BACKUP_IN_LINUX" = true ]; then
    perform_backup
    configure_cron_linux
elif [ "$(uname)" = "Darwin" ] && [ "$BACKUP_IN_MAC" = true ]; then
    perform_backup
    configure_cron_mac
else
    echo "Sistema operativo no soportado o backup deshabilitado para este sistema."
    exit 1
fi

# Limpiar backups antiguos
clean_old_backups
