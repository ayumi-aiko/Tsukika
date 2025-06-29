//
// Copyright (C) 2025 愛子あゆみ <ayumi.aiko@outlook.com>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#include <tsukika.h>
#include <tsukikautils.h>

int isPackageInstalled(const char *packageName) {
    // Prevents command injection attempts
    if(strchr(packageName, ';') || strstr(packageName, "&&")) {
        consoleLog(LOG_LEVEL_ERROR, "isPackageInstalled(): Malicious intent in the given argument detected!");
        exit(1);
    }
    return executeCommands("pm", (const char *[]){ "list", "packages", "|", "grep", "-q", packageName, NULL}, false);
}

int getSystemProperty__(const char *filepath, const char *propertyVariableName) {
    FILE *file = fopen(filepath, "r");
    size_t propertyLen = strlen(propertyVariableName);
    char line[256];
    if(file) {
        while(fgets(line, sizeof(line), file)) {
            if(strncmp(line, propertyVariableName, propertyLen) == 0 && line[propertyLen] == '=') {
                char *value = line + propertyLen + 1;
                value[strcspn(value, "\r\n")] = '\0';
                fclose(file);
                return atoi(value);
            }
        }
        fclose(file);
        return -1;
    }
    else {
        char command[256];
        snprintf(command, sizeof(command), "getprop %s", propertyVariableName);
        FILE *cmd = popen(command, "r");
        if(cmd) {
            if(fgets(line, sizeof(line), cmd)) {
                line[strcspn(line, "\r\n")] = '\0';
                pclose(cmd);
                return line[0] ? atoi(line) : -1;
            }
            pclose(cmd);
        }
        return -1;
    }
}

int maybeSetProp(const char *property, const char *expectedPropertyValue, const char *typeShyt) {
    if(strcmp(getSystemProperty("ok", property), expectedPropertyValue) == 0) {
        const char *arguments[] = {typeShyt, NULL};
        return executeCommands("resetprop", arguments, false);
    }
    return 1;
}

int DoWhenPropisinTheSameForm(const char *property, const char *expectedPropertyValue) {
    return strcmp(getSystemProperty("ok", property), expectedPropertyValue);
}

int setprop(const char *property, const char *propertyValue) {
    const char *args[] = {property, propertyValue, NULL};
    if(executeCommands("resetprop", args, false) == 0) return 0;
    consoleLog(LOG_LEVEL_WARN, "setprop(): Failed to set requested property!");
    consoleLog(LOG_LEVEL_ERROR, "setprop(): %s to %s", property, propertyValue);
    exit(1);
}

bool isTheDeviceBootCompleted() {
    if(getSystemProperty__("null", "sys.boot_completed") == 1) return true;
    return false;
}

bool isBootAnimationExited() {
    if(getSystemProperty__("null", "service.bootanim.exit") == 1) return true;
    return false;
}

bool bootanimStillRunning() {
    if(getSystemProperty__("null", "service.bootanim.progress") == 1) return true;
    return false;
}

bool isTheDeviceisTurnedOn() {
    FILE *fp = popen("dumpsys power | grep 'Display Power'", "r"); 
    if(!fp) {
        consoleLog(LOG_LEVEL_ERROR, "isTheDeviceisTurnedOn(): Failed to open stdout to gather information about the device display power status.");
        return false;
    }
    char buffer[4];
    fgets(buffer, sizeof(buffer), fp);
    pclose(fp);
    return (strstr(buffer, "OFF") == NULL);
}

char *getSystemProperty(const char *filepath, const char *propertyVariableName) {
    FILE *file = fopen(filepath, "r");
    size_t propertyLen = strlen(propertyVariableName) + 2;
    char *buildProperty = malloc(propertyLen);
    if(buildProperty == NULL) {
        consoleLog(LOG_LEVEL_ERROR, "getSystemProperty(): Failed to allocate memory to get requested system property value.");
        exit(1);
    }
    if(!file) {
        snprintf(buildProperty, propertyLen, "getprop %s", propertyVariableName);
        FILE *cmd = popen(buildProperty, "r");
        if(cmd) {
            if(fgets(buildProperty, sizeof(buildProperty), cmd)) buildProperty[strcspn(buildProperty, "\r\n")] = 0;
            pclose(cmd);
            return buildProperty;
        }
        free(buildProperty);
        return "KILL.796f7572.73656c660a";
    }
    char line[256];
    while(fgets(line, sizeof(line), file)) {
        if(strncmp(line, propertyVariableName, propertyLen) == 0 && line[propertyLen] == '=') {
            strncpy(buildProperty, line + propertyLen + 1, propertyLen - 1);
            buildProperty[propertyLen - 1] = '\0';
            buildProperty[strcspn(buildProperty, "\r\n")] = 0;
            fclose(file);
            return buildProperty;
        }
    }
    fclose(file);
    return "KILL.796f7572.73656c660a";
}

void sendToastMessages(const char *service, const char *message) {
    if(!service || !message) return;
    if(isPackageInstalled("bellavita.toast") == 0) {
        const char *args[] = {"am", "start", "-a", "android.intent.action.MAIN", "-e", "toasttext", service, message, "-n", "bellavita.toast/.MainActivity", NULL};
        executeCommands("am", args, false);
    }
}

void sendNotification(const char *message) {
    if(!message) return;
    const char *args[] = {"cmd", "notification", "post", "-S", "bigtext", "-t", "Tsukika", "Tag", message, NULL};
    executeCommands("cmd", args, false);
}

void prepareStockRecoveryCommandList(char *action, char *actionArg, char *actionArgExt) {
    mkdir("/cache/recovery/", 0755);
    FILE *recoveryCommand = fopen("/cache/recovery/command", "w");
    if(recoveryCommand == NULL) {
        consoleLog(LOG_LEVEL_ERROR, "prepareStockRecoveryCommandList(): Failed to open recovery command file for writing to prepare command list.");
        return;
    }
    if(strcmp(action, "wipe") == 0 && strcmp(actionArg, "cache") == 0) {
        fputs("--wipe_cache\n", recoveryCommand);
    }
    else if(strcmp(action, "wipe") == 0 && strcmp(actionArg, "data") == 0) {
        fputs("--wipe_data\n", recoveryCommand);
    }
    else if(strcmp(action, "install") == 0) {
        fprintf(recoveryCommand, "--update_package=%s\n", actionArg);
    }
    else if(strcmp(action, "switchLocale") == 0) {
        fprintf(recoveryCommand, "--locale=%s_%s\n", cStringToLower(actionArg), cStringToUpper(actionArgExt));
    }
    fclose(recoveryCommand);
}

void prepareTWRPRecoveryCommandList(char *action, char *actionArg, char *actionArgExt) {
    mkdir("/cache/recovery/", 0755);
    FILE *recoveryCommand = fopen("/cache/recovery/openrecoveryscript", "a");
    if(recoveryCommand == NULL) {
        consoleLog(LOG_LEVEL_ERROR, "prepareTWRPRecoveryCommandList(): Failed to open recovery command file for writing to prepare command list.");
        return;
    } 
    if(strcmp(action, "wipe") == 0 && strcmp(actionArg, "cache") == 0) {
        fputs("wipe cache\n", recoveryCommand);
    }
    else if(strcmp(action, "wipe") == 0 && strcmp(actionArg, "data") == 0) {
        fputs("wipe data\n", recoveryCommand);
    }
    else if(strcmp(action, "format data") == 0) {
        fputs("format data\n", recoveryCommand);
    }
    else if(strcmp(action, "reboot") == 0 && (strcmp(actionArg, "recovery") == 0 || strcmp(actionArg, "poweroff") == 0 || strcmp(actionArg, "download") == 0 || strcmp(actionArg, "bootloader") == 0 || strcmp(actionArg, "edl") == 0)) {
        fprintf(recoveryCommand, "reboot %s\n", actionArg);
    }
    else if(strcmp(action, "install") == 0) {
        fprintf(recoveryCommand, "install %s\n", actionArg);
    }
    fclose(recoveryCommand);
}

void startDaemon(const char *daemonName) {
    if(!daemonName) return;
    if(setprop("ctl.start", daemonName) == 0) {
        consoleLog(LOG_LEVEL_INFO, "startDaemon(): Daemon %s started successfully.", daemonName);
    }
    else {
        consoleLog(LOG_LEVEL_WARN, "startDaemon(): Failed to start daemon %s.", daemonName);
    }
}

void stopDaemon(const char *daemonName) {
    if(!daemonName) return;
    if(setprop("ctl.stop", daemonName) == 0) {
        consoleLog(LOG_LEVEL_INFO, "stopDaemon(): Daemon %s stopped successfully.", daemonName);
    }
    else {
        consoleLog(LOG_LEVEL_WARN, "stopDaemon(): Failed to stop daemon %s.", daemonName);
    }
}

char *grep_prop(const char *variableName, const char *propFile) {
    FILE *filePointer = fopen(propFile, "r");
    if(!filePointer) {
        consoleLog(LOG_LEVEL_ERROR, "grep_prop(): Failed to open properties file: %s", propFile);
        return "NULL";
    }
    char theLine[8000];
    size_t lengthOfTheString = strlen(variableName);
    while(fgets(theLine, sizeof(theLine), filePointer)) {
        if(strncmp(theLine, variableName, lengthOfTheString) == 0) {
            strtok(theLine, "=");
            char *value = strtok(NULL, "\n");
            fclose(filePointer);
            return value;
        }
    }
    return "NULL";
}