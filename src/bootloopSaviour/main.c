#include <dirent.h>
#include <tsukika.h>
#include <tsukikautils.h>
char *LOGFILE = "/sdcard/Tsukika/logs/tsukika_bootloopSaviour.log";
const char *placeboArg[] = {NULL};
bool useStdoutForAllLogs = false;

void disableMagiskModules() {
    DIR *dirptr = opendir("/data/adb/modules/");
    if(!dirptr) {
        consoleLog(LOG_LEVEL_ERROR, "disableMagiskModules(): Failed to open directory!");
        exit(1);
    }
    struct dirent *entry;
    while((entry = readdir(dirptr)) != NULL) {
        if(entry->d_type == DT_DIR) {
            if(strcmp(entry->d_name, "..") == 0 || strcmp(entry->d_name, ".") == 0) continue;
            size_t sizeOfTheString = strlen("/data/adb/modules/") + strlen(entry->d_name) + strlen("/disable") + 2;
            char *alllocatedChar = malloc(sizeOfTheString);
            if(!alllocatedChar) {
                consoleLog(LOG_LEVEL_ERROR, "disableMagiskModules(): Failed to allocate memory for locating module path!");
                continue;
            }
            if(snprintf(alllocatedChar, sizeOfTheString, "/data/adb/modules/%s/disable", entry->d_name) >= sizeOfTheString) {
                consoleLog(LOG_LEVEL_WARN, "disableMagiskModules(): Truncated path, skipping /data/adb/modules/%s/...", entry->d_name);
                free(alllocatedChar);
                continue;
            }
            FILE *file = fopen(alllocatedChar, "w");
            if(!file) {
                consoleLog(LOG_LEVEL_ERROR, "disableMagiskModules(): Failed to disable %s", entry->d_name);
            }
            else {
                fclose(file);
            }            
            free(alllocatedChar);
        }
    }
    closedir(dirptr);
    const char *arguments[] = {"rm", "-rf", "/cache/.system_booting", "/data/unencrypted/.system_booting", "/metadata/.system_booting", "/persist/.system_booting", "/mnt/vendor/persist/.system_booting", NULL};
    executeCommands("rm", arguments, false);
    executeCommands("reboot", placeboArg, false);
}

int main(int argc, char *argv[]) {
    int zygote_pid = getSystemProperty__("hi", "init.svc_debug_pid.zygote");
    consoleLog(LOG_LEVEL_INFO, "main(): Sleeping for 5s to get the new or old zygote pid....");
    sleep(5);
    int zygote_pid2 = getSystemProperty__("hi", "init.svc_debug_pid.zygote");
    consoleLog(LOG_LEVEL_INFO, "main(): Zygote PID: %d", zygote_pid);
    sleep(5);
    int zygote_pid3 = getSystemProperty__("hi", "init.svc_debug_pid.zygote");
    if(zygote_pid <= 1) disableMagiskModules();
    if(zygote_pid != zygote_pid2 || zygote_pid2 != zygote_pid3) {
        sleep(15);
        int zygote_pid4 = getSystemProperty__("hi", "init.svc_debug_pid.zygote");
        if(zygote_pid3 != zygote_pid4) disableMagiskModules();
    }
    consoleLog(LOG_LEVEL_INFO, "main(): BootloopSaviour has finished its job, exiting now.");
    return 0;
}