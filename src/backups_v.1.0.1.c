#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

// Variables de configuración
#define SCRIPT_PATH "/ruta/del/directorio/del/script"  // Cambia esta ruta a la ubicación real del script
#define BACKUP_DIR "/ruta/del/directorio/de/backups"
#define SD_CARD_DIR "/ruta/de/la/sd/card"
#define ENCRYPT_PASSWORD "tu_contraseña_de_encriptacion"
#define DAYS_TO_KEEP_BACKUPS 3
#define CONTINUOUS_BACKUPS 1
#define BACKUP_IN_LINUX 1
#define BACKUP_IN_MAC 1

// Variable de año en el cronjob
#define CRON_YEAR (date.year + 1900)  // Obtiene el año actual

// Rutas completas de los scripts de backup y directorio a respaldar
#define BACKUP_SCRIPT_PATH SCRIPT_PATH "/ruta/del/script_de_backup.sh"
#define DIRECTORY_TO_BACKUP SCRIPT_PATH "/ruta/del/a_hacer_backup"

// Nombre del archivo de backup
char backup_filename[256];

// Variables de intervalo de tiempo para cron en Linux
#define CRON_MINUTE_LINUX 30     // Configura el minuto en números enteros (0-59)
#define CRON_HOUR_LINUX 2       // Configura la hora en números enteros (0-23)
#define CRON_DAY_LINUX 1        // Configura el día del mes en números enteros (1-31)
#define CRON_MONTH_LINUX 1      // Configura el mes en números enteros (1-12). Mes 1 corresponde a enero.

// Variables de intervalo de tiempo para cron en macOS
#define CRON_MINUTE_MAC 30       // Configura el minuto en números enteros (0-59)
#define CRON_HOUR_MAC 2         // Configura la hora en números enteros (0-23)
#define CRON_DAY_MAC 1          // Configura el día del mes en números enteros (1-31)
#define CRON_MONTH_MAC 1        // Configura el mes en números enteros (1-12). Mes 1 corresponde a enero.

// Estructura para fecha y hora
struct Date {
    int year;
    int month;
    int day;
    int hour;
    int minute;
    int second;
};

// Función para obtener la fecha y hora actual
void get_current_datetime(struct Date* date) {
    time_t now;
    struct tm* timeinfo;

    time(&now);
    timeinfo = localtime(&now);

    date->year = timeinfo->tm_year + 1900;
    date->month = timeinfo->tm_mon + 1;
    date->day = timeinfo->tm_mday;
    date->hour = timeinfo->tm_hour;
    date->minute = timeinfo->tm_min;
    date->second = timeinfo->tm_sec;
}

// Función para realizar el backup y encriptarlo
void perform_backup() {
    struct Date date;
    get_current_datetime(&date);

    sprintf(backup_filename, "backup_%04d%02d%02d_%02d%02d%02d.tar.gz", date.year, date.month, date.day, date.hour, date.minute, date.second);

    char command[512];
    sprintf(command, "tar -czf \"%s/%s\" \"%s\" && gpg --batch --yes --passphrase \"%s\" -c \"%s/%s\" && rm \"%s/%s\"",
            BACKUP_DIR, backup_filename, DIRECTORY_TO_BACKUP, ENCRYPT_PASSWORD, BACKUP_DIR, backup_filename, BACKUP_DIR, backup_filename);

    int result = system(command);
    if (result != 0) {
        printf("Error al realizar el backup y encriptarlo.\n");
        exit(1);
    }
}

// Función para limpiar backups antiguos
void clean_old_backups() {
    struct Date date;
    get_current_datetime(&date);

    char find_command[256];
    sprintf(find_command, "find \"%s\" -name \"backup_*.tar.gz.gpg\" -mtime +%d -exec rm {} \\;", BACKUP_DIR, DAYS_TO_KEEP_BACKUPS);

    system(find_command);
}

// Función para configurar el cronjob en Linux
void configure_cron_linux(int minute, int hour, int day, int month) {
    char cron_command[512];
    sprintf(cron_command, "(crontab -l 2>/dev/null; echo \"%d %d %d %d * %s\") | crontab -",
            minute, hour, day, month, BACKUP_SCRIPT_PATH);

    system(cron_command);
}

// Función para configurar el cronjob en macOS
void configure_cron_mac(int minute, int hour, int day, int month) {
    char cron_command[512];
    sprintf(cron_command, "(crontab -l 2>/dev/null; echo \"%d %d %d %d * %s\") | crontab -",
            minute, hour, day, month, BACKUP_SCRIPT_PATH);

    system(cron_command);
}

int main() {
    // Realizar el backup y encriptarlo
    perform_backup();

    // Configurar cronjob en Linux o macOS
    #ifdef __linux__
        if (BACKUP_IN_LINUX) {
            configure_cron_linux(CRON_MINUTE_LINUX, CRON_HOUR_LINUX, CRON_DAY_LINUX, CRON_MONTH_LINUX);
        }
    #elif defined __APPLE__
        if (BACKUP_IN_MAC) {
            configure_cron_mac(CRON_MINUTE_MAC, CRON_HOUR_MAC, CRON_DAY_MAC, CRON_MONTH_MAC);
        }
    #endif

    // Limpiar backups antiguos
    clean_old_backups();

    // Ejecutar el script binario exportado del código fuente
    system("/ruta/al/ejecutable/del/script/binario");

    return 0;
}
