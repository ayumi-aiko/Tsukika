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

#include <tsukikautils.h>

int executeCommands(const char *command, const char *args[], bool requiresOutput) {
    for(int i = 0; args[i] != NULL; i++) {
        if(strstr(args[i], ";") || strstr(args[i], "&&") || strstr(args[i], "$(")) {
            consoleLog(LOG_LEVEL_ERROR, "executeCommands(): Malicious command detected: %s", args[i]);
            exit(1);
        }
    }
    if(command && (strstr(command, ";") || strstr(command, "&&") || strstr(command, "|") || strstr(command, "`") || strstr(command, "$(") || strstr(command, "dd"))) {
        consoleLog(LOG_LEVEL_ERROR, "executeCommands(): Malicious command detected: %s", command);
        exit(1);
    }
    pid_t ProcessID = fork();
    consoleLog(LOG_LEVEL_DEBUG, "executeCommands(): Trying to create a child process for a shell command: %s", command);
    consoleLog(LOG_LEVEL_DEBUG, "executeCommands(): Child process ID: %d", &ProcessID);
    switch(ProcessID) {
        case -1:
            consoleLog(LOG_LEVEL_ERROR, "executeCommands(): Failed to fork process.");
        break;
        case 0:
            if(!requiresOutput) {
                int devNull = open("/dev/null", O_WRONLY);
                if(devNull == -1) exit(EXIT_FAILURE);
                dup2(devNull, STDOUT_FILENO);
                dup2(devNull, STDERR_FILENO);
                close(devNull);
            }
            execvp(command, (char *const *)args);
            consoleLog(LOG_LEVEL_ERROR, "executeCommands(): Failed to execute command: %s", command);
        break;
        default:
            int exitStatus;
            wait(&exitStatus);
            return (WIFEXITED(exitStatus)) ? WEXITSTATUS(exitStatus) : 1;
    }
    // to shut up the compiler
    return 1;
}

int executeScripts(const char *__script__file, const char *args[], bool requiresOutput) {
    for(int i = 0; args[i] != NULL; i++) {
        if(strstr(args[i], ";") || strstr(args[i], "&&") || strstr(args[i], "|") || strstr(args[i], "$(")) {
            consoleLog(LOG_LEVEL_ERROR, "executeScripts(): Malicious command detected: %s", args[i]);
            exit(EXIT_FAILURE);
        }
    }
    pid_t ProcessID = fork();
    consoleLog(LOG_LEVEL_DEBUG, "executeCommands(): Trying to create a child process for a shell script execution, path to the script: %s", __script__file);
    consoleLog(LOG_LEVEL_DEBUG, "executeCommands(): Child process ID: %d", &ProcessID);
    switch(ProcessID) {
        case -1:
            consoleLog(LOG_LEVEL_ERROR, "executeScripts(): Failed to fork process.");
        break;
        case 0:
            if(!requiresOutput) {
                int devNull = open("/dev/null", O_WRONLY);
                if(devNull == -1) exit(EXIT_FAILURE);
                dup2(devNull, STDOUT_FILENO);
                dup2(devNull, STDERR_FILENO);
                close(devNull);
            }
            execv(__script__file, (char *const *)args);
            consoleLog(LOG_LEVEL_ERROR, "executeScripts(): Failed to execute %s", __script__file);
        break;
        default:
            int exitStatus;
            wait(&exitStatus);
            return (WIFEXITED(exitStatus)) ? WEXITSTATUS(exitStatus) : 1;
    }
    // to shut up the compiler
    return 1;
}

// prevents bastards from running any malicious commands
// this searches some sensitive strings to ensure that the script is safe
// please verify your scripts before running it PLEASE 🙏
int searchBlockListedStrings(const char *__filename, const char *__search_str) {
    size_t sizeOfTheseCraps = strlen(__filename) + strlen(__search_str) + 3;
    char *command = malloc(sizeOfTheseCraps);
    if(!command) {
        consoleLog(LOG_LEVEL_ERROR, "searchBlockListedStrings(): Failed to allocate memory for searching blocklisted strings.");
        exit(1);
    }
    snprintf(command, sizeOfTheseCraps, "grep -q '%s' '%s'", __search_str, __filename);
    FILE *file = popen(command, "r");
    free(command);
    if(!file) {
        consoleLog(LOG_LEVEL_ERROR, "searchBlockListedStrings(): Failed to open file for reading: %s", __filename);
        return 1;
    }
    char haystack[1028];
    while(fgets(haystack, sizeof(haystack), file) != NULL) {
        haystack[strcspn(haystack, "\n")] = '\0';
        if(strstr(haystack, __search_str) != NULL) {
            fclose(file);
            consoleLog(LOG_LEVEL_ERROR, "searchBlockListedStrings(): Malicious code execution detected in the script file: %s", __filename);
            return 1;
        }
    }
    fclose(file);
    return 0;
}

// yet another thing to protect good peoples from getting fucked
// this ensures that the chosen is a bash script and if it's not one
// it'll return 1 to make the program to stop from executing that bastard
int verifyScriptStatusUsingShell(const char *__filename) {
    // use the size_t to avoid uncertain integer values:
    size_t commandLength = strlen(__filename) + strlen("file \"\" | grep -q 'ASCII text executable'") + 1;
    char *command = malloc(commandLength);
    if(!command) {
        consoleLog(LOG_LEVEL_ERROR, "verifyScriptStatusUsingShell(): Failed to allocate enough memory for script verification.");
        return 1;
    }
    int written = snprintf(command, commandLength, "file \"%s\" | grep -q 'ASCII text executable'", __filename);
    if(written < 0 || (size_t)written >= commandLength) {
        consoleLog(LOG_LEVEL_ERROR, "verifyScriptStatusUsingShell(): Command truncation detected.");
        free(command);
        return 1;
    }
    // Prepare: prepare args for /bin/sh -c "command"
    const char *args[] = { "sh", "-c", command, NULL };
    // Update: executeCommands expects path + args[]
    free(command);
    return executeCommands("/bin/sh", args, false);
}

// Checks if a given string contains blacklisted substrings
int checkBlocklistedStringsNChar(const char *__haystack) {
    static const char *blocklistedStrings[] = {
        "/xbl_config",
        "/fsc",
        "/fsg",
        "/modem",
        "/modemst1",
        "/modemst2",
        "/abl",
        "/keymaster",
        "/sda",
        "/sdb",
        "/sdc",
        "/sdd",
        "/sde",
        "/sdf",
        "/splash",
        "/dtbo",
        "/bluetooth",
        "/cust",
        "/xbl",
        "/persist",
        "/dev/block/bootdevice/by-name/",
        "/dev/block/by-name/",
        "/dev/block/",
        "/system/bin/dd",
        "/vendor/bin/dd",
        "dd",
        "/dev/block/mmcblk",
        "/dev/mmcblk"
    };
    size_t blocklistedStringArraySize = sizeof(blocklistedStrings) / sizeof(blocklistedStrings[0]);
    for(int i = 0; i < blocklistedStringArraySize; i++) {
        switch(searchBlockListedStrings(__haystack, blocklistedStrings[i])) {
            case 1:
                consoleLog(LOG_LEVEL_ERROR, "checkBlocklistedStringsNChar(): Found Blocklisted string: %s at %d line", blocklistedStrings[i], i);
                consoleLog(LOG_LEVEL_ERROR, "checkBlocklistedStringsNChar(): The script is not safe to execute! Stopping execution process...");
                return 1;
            default:
                continue;
        }
    }
    return 0;
}

bool erase_file_content(const char *__file) {
    FILE *fileConstantAgain = fopen(__file, "w");
    if(!fileConstantAgain) return false;
    fclose(fileConstantAgain);
    return true;
}

char *combineShyt(const char *format, ...) {
    va_list args;
    va_start(args, format);
    int len = vsnprintf(NULL, 0, format, args);
    va_end(args);
    if(len < 0) return NULL;
    char *result = malloc(len + 1);
    if(!result) return NULL;
    va_start(args, format);
    vsnprintf(result, len + 1, format, args);
    va_end(args);
    return result;
}

char *cStringToLower(char *str) {
    int i = 0;
    while(str[i]) {
        str[i] = tolower((unsigned char)str[i]);
        i++;
    }
    return str;
}

char *cStringToUpper(char *str) {
    int i = 0;
    while(str[i]) {
        str[i] = toupper((unsigned char)str[i]);
        i++;
    }
    return str;
}

void abort_instance(const char *format, ...) {
    va_list args;
    va_start(args, format);
    consoleLog(LOG_LEVEL_ERROR, "abort_instance(): %s %s", format, args);
    va_end(args);
    exit(1);
}

void consoleLog(enum elogLevel loglevel, const char *message, ...) {
    va_list args;
    va_start(args, message);
    FILE *out = NULL;
    bool toFile = false;
    if(useStdoutForAllLogs) {
        out = stdout;
        if(loglevel == LOG_LEVEL_ERROR || loglevel == LOG_LEVEL_WARN || loglevel == LOG_LEVEL_DEBUG) out = stderr;
    }
    else {
        out = fopen("test.log", "a");
        if(!out) exit(EXIT_FAILURE);
        toFile = true;
    }
    switch(loglevel) {
        case LOG_LEVEL_INFO:
            if(!toFile) fprintf(out, "\033[2;30;47mINFO: ");
            else fprintf(out, "INFO: ");
            vfprintf(out, message, args);
            if(!toFile) fprintf(out, "\033[0m\n");
            else fprintf(out, "\n");
            break;
        case LOG_LEVEL_WARN:
            if(!toFile) fprintf(out, "\033[1;33mWARNING: ");
            else fprintf(out, "WARNING: ");
            vfprintf(out, message, args);
            if(!toFile) fprintf(out, "\033[0m\n");
            else fprintf(out, "\n");
            break;
        case LOG_LEVEL_DEBUG:
            if(!toFile) fprintf(out, "\033[0;36mDEBUG: ");
            else fprintf(out, "DEBUG: ");
            vfprintf(out, message, args);
            if(!toFile) fprintf(out, "\033[0m\n");
            else fprintf(out, "\n");
            break;
        case LOG_LEVEL_ERROR:
            if(!toFile) fprintf(out, "\033[0;31mERROR: ");
            else fprintf(out, "ERROR: ");
            vfprintf(out, message, args);
            if(!toFile) fprintf(out, "\033[0m\n");
            else fprintf(out, "\n");
            break;
    }
    if(!useStdoutForAllLogs && out) fclose(out);
    va_end(args);
}