#!/usr/bin/env bash
#
# Copyright (C) 2025 愛子あゆみ <ayumi.aiko@outlook.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# fix makefile:
[ -z "${thisConsoleTempLogFile}" ] && thisConsoleTempLogFile="./local_build/logs/tsuki_build.log"
[ -z "${TMPFILE}" ] && TMPFILE="$(mktemp)"

function grep_prop() {
    [[ -z "$1" || -z "$2" || ! -f "$2" ]] && return 1
    grep -E "^$1=" "$2" 2>>"$thisConsoleTempLogFile" | cut -d '=' -f2- | tr -d '"'
}

function downloadRequestedFile() {
    local link="$1"
    local save_path="$2"
    [[ -z "$link" || -z "$save_path" ]] && return 1
    if [ "$1" == "--skip" ]; then
        link="$2"
        save_path="$3"
        aria2c -x 8 -s 8 -o "${save_path}" "${link}" &>>$thisConsoleTempLogFile && return 0
        return 1
    else
        for ((tries = 1; tries <= 4; tries++)); do
            console_print "📥 Trying to download requested file | Attempt: $tries"
            if aria2c -x 8 -s 8 -o "${save_path}" "${link}" &>>"$thisConsoleTempLogFile"; then
                console_print "✅ Successfully downloaded file after $tries attempt(s)"
                return 0
            fi
            console_print "❌ Failed to download the file | Attempt: $tries"
        done
        abort "⚠️ Failed to download the file after $((tries - 1)) attempts."
    fi
}

function setprop() {
    local propFile
    local propVariableName
    local propValue

    case "$(stringFormat --lower "$1")" in
        *product*)
            propFile="${TSUKIKA_PRODUCT_PROPERTY_FILE}"
        ;;
        *system_ext*)
            propFile="${TSUKIKA_SYSTEM_EXT_PROPERTY_FILE}"
        ;;
        *system*)
            propFile="${TSUKIKA_SYSTEM_PROPERTY_FILE}"
        ;;
        *vendor*)
            propFile="${TSUKIKA_VENDOR_PROPERTY_FILE}"
        ;;
        *custom*)
            propFile="$2"
            propVariableName="$3"
            propValue="$4"
            [[ ! -f "$propFile" ]] && propFile="$TSUKIKA_VENDOR_PROPERTY_FILE"
        ;;
        *deleteifexpectationsmet*)
            propFile="$2"
            propVariableName="$3"
            propValue="$4"
            [[ "$(grep_prop "$propVariableName" "$propFile")" == "$propValue" ]] && sed -i "/^${propVariableName}=.*/d" "$propFile"
        ;;
        *force-delete*)
            propFile="$2"
            propVariableName="$3"
            sed -i "/^${propVariableName}=.*/d" "$propFile"
        ;;
        *)
            echo "Invalid setprop target: $1"
            return 1
        ;;
    esac

    # Normal setprop case
    [[ -z "$propVariableName" ]] && propVariableName="$2"
    [[ -z "$propValue" ]] && propValue="$3"

    # Delete existing line, then append the new one
    sed -i "/^${propVariableName}=.*/d" "$propFile"
    echo "${propVariableName}=${propValue}" >> "$propFile"
}

function abort() {
    echo -e "\e[0;31m$1\e[0;37m" >&2
    debugPrint "$2(): $1"
    sleep 0.5
    # i dont want this to run when i run abort on makefile or even on some instances, 
    # why $3? because i dont provide $3 on everything except makefile.
    if [ -z "$3" ]; then
        tinkerWithCSCFeaturesFile --encode
        rm -rf $TMPDIR $TMPFILE ./local_build/etc/extract/*.img ./local_build/etc/extract/*.img.lz4 ./localFirmwareBuildPending
        sudo umount ./local_build/etc/imageSetup/* &>/dev/null
    fi
    exit 1
}

function warns() {
    echo -e "\e[0;31m$1\e[0;37m" >&2
    debugPrint "warns(): $1 | $2"
}

function console_print() {
    echo -e "\e[0;33m$1\e[0;37m"
}

function changeDefaultLanguageConfiguration() {
    if [ "${SWITCH_DEFAULT_LANGUAGE_ON_PRODUCT_BUILD}" == true ]; then
        debugPrint "changeDefaultLanguageConfiguration(): Changing default language...."

        # Convert to proper case
        local language=$(echo "$1" | tr '[:upper:]' '[:lower:]')
        local country=$(echo "$2" | tr '[:lower:]' '[:upper:]')
        
        # Validate length (ISO 639-1 for language, ISO 3166-1 alpha-2 for country)
        [[ ! "$language" =~ ^[a-z]{2,3}$ ]] && abort "Invalid language code: $language" "changeDefaultLanguageConfiguration"
        [[ ! "$country" =~ ^[A-Z]{2,3}$ ]] && abort "Invalid country code: $country" "changeDefaultLanguageConfiguration"
        
        for EXPECTED_CUSTOMER_XML_PATH in $PRODUCT_DIR/omc/*/conf/customer.xml $OPTICS_DIR/configs/carriers/*/*/conf/customer.xml; do
            [ -f "$EXPECTED_CUSTOMER_XML_PATH" ] || continue
            # Skip modification if the values are already correct
            if grep -q "<DefLanguage>${language}-${country}</DefLanguage>" "$EXPECTED_CUSTOMER_XML_PATH" && grep -q "<DefLanguageNoSIM>${language}-${country}</DefLanguageNoSIM>" "$EXPECTED_CUSTOMER_XML_PATH"; then
                debugPrint "changeDefaultLanguageConfiguration(): Skipping $EXPECTED_CUSTOMER_XML_PATH (already set)"
                continue
            fi
            for languages in DefLanguage DefLanguageNoSIM; do
                changeXMLValues "${languages}" "${language}-${country}" "$EXPECTED_CUSTOMER_XML_PATH"
            done
            debugPrint "changeDefaultLanguageConfiguration(): Updated default language in $EXPECTED_CUSTOMER_XML_PATH"
        done
    else
        debugPrint "changeDefaultLanguageConfiguration(): Skipping changing default language, reason: \"SWITCH_DEFAULT_LANGUAGE_ON_PRODUCT_BUILD\" set to ${SWITCH_DEFAULT_LANGUAGE_ON_PRODUCT_BUILD} instead of true"
        return 0;
    fi
}

function buildAndSignThePackage() {
    local extracted_dir_path="$1"
    local app_path="$2"
    local skipSign="$3"
    local arg="$4"
    local apkFileName
    local signed_apk
    local apk_file

    # Common checks
    [[ ! -d "$extracted_dir_path" || ! -f "$extracted_dir_path/apktool.yml" ]] && abort "Invalid Apkfile path: $extracted_dir_path" "buildAndSignThePackage"

    # Extract APK file name from apktool.yml dynamically
    apkFileName=$(grep "apkFileName" "$extracted_dir_path/apktool.yml" | cut -d ':' -f 2 | tr -d ' "')
    apk_file="${extracted_dir_path}/dist/${apkFileName}"

    # Change compile SDK version and etc before build
    if [ "${arg}" == "--skip-editing-version-info" ]; then
        changeXMLValues "compileSdkVersion" "${BUILD_TARGET_SDK_VERSION}" "${extracted_dir_path}/AndroidManifest.xml"
        changeXMLValues "platformBuildVersionCode" "${BUILD_TARGET_SDK_VERSION}" "${extracted_dir_path}/AndroidManifest.xml" 
        changeXMLValues "compileSdkVersionCodename" "${BUILD_TARGET_ANDROID_VERSION}" "${extracted_dir_path}/AndroidManifest.xml"
        changeXMLValues "platformBuildVersionName" "${BUILD_TARGET_ANDROID_VERSION}" "${extracted_dir_path}/AndroidManifest.xml"
        changeYAMLValues "minSdkVersion" "${BUILD_TARGET_ANDROID_VERSION}" "${extracted_dir_path}/apktool.yml"
        changeYAMLValues "targetSdkVersion" "${BUILD_TARGET_ANDROID_VERSION}" "${extracted_dir_path}/apktool.yml"
        changeYAMLValues "version" "${CODENAME_VERSION_REFERENCE_ID}" "${extracted_dir_path}/apktool.yml"
        changeYAMLValues "versionName" "${CODENAME}" "${extracted_dir_path}/apktool.yml"
        changeYAMLValues "versionCode" "${BUILD_TARGET_ANDROID_VERSION}" "${extracted_dir_path}/apktool.yml"
    fi

    # Build the package
    if java -jar ./src/dependencies/bin/apktool.jar build "$extracted_dir_path" &>>$thisConsoleTempLogFile; then
        debugPrint "Successfully built: $apkFileName"
    else
        abort "Apktool build failed for $extracted_dir_path" "buildAndSignThePackage"
    fi

    # Ensure built APK exists
    [ ! -f "$apk_file" ] && abort "No APK found in $extracted_dir_path/dist/" "buildAndSignThePackage"

    # Signing the APK
    if [[ -n "${skipSign}" && "${skipSign}" == "true" ]]; then
        if [[ -f "$MY_KEYSTORE_PATH" && -n $MY_KEYSTORE_ALIAS && -n $MY_KEYSTORE_PASSWORD && -n $MY_KEYSTORE_ALIAS_KEY_PASSWORD ]]; then
            signed_apk="$(java -jar ./src/dependencies/bin/signer.jar --apk "$apk_file" --ks "$MY_KEYSTORE_PATH" --ksAlias "$MY_KEYSTORE_ALIAS" --ksPass "$MY_KEYSTORE_PASSWORD" --ksKeyPass "$MY_KEYSTORE_ALIAS_KEY_PASSWORD" 2>>$thisConsoleTempLogFile | grep -oP 'src/.*?-aligned-debugSigned\.apk')"
        else
            signed_apk="$(java -jar ./src/dependencies/bin/signer.jar --apk "$apk_file" 2>>$thisConsoleTempLogFile | grep -oP 'src/.*?-aligned-debugSigned\.apk')"
        fi
    fi

    # Ensure signed APK exists
    [[ ! -f "$signed_apk" || -z "$signed_apk" ]] && abort "No signed APK found in $extracted_dir_path/dist/" "buildAndSignThePackage"

    # Move signed APK to target directory and do a cleanup
    mv "$signed_apk" "$app_path/"
    rm -rf "$extracted_dir_path/build" "$extracted_dir_path/dist/" "$extracted_dir_path/original/"
}

function catchDuplicatesInXML() {
    [ ! -f "$2" ] && return 1
    grep -c "$1" "$2"
}

function addFloatXMLValues() {
    local feature_code="$(stringFormat -u "$1")"
    local feature_code_value="$2"   

    # floating feature conf depending on SDK version:
    case "${BUILD_TARGET_SDK_VERSION}" in
        28|29|30)
            BUILD_TARGET_FLOATING_FEATURE_PATH="${VENDOR_DIR}/etc/floating_feature.xml"
        ;;
        31|32|33|34|35)
            BUILD_TARGET_FLOATING_FEATURE_PATH="${SYSTEM_DIR}/etc/floating_feature.xml"
        ;;
    esac

    #TODO:
    [ "$loggedFloatingFeaturePATH" == "no" ] && { debugPrint "addFloatXMLValues(): Floating feature path: ${BUILD_TARGET_FLOATING_FEATURE_PATH}"; loggedFloatingFeaturePATH="yes"; }

    # Check if the feature_code already exists in the XML file
    if [ "$(catchDuplicatesInXML "${feature_code}" "${BUILD_TARGET_FLOATING_FEATURE_PATH}")" == 0 ]; then
        # Insert the new feature code into the XML under <SecFloatingFeatureSet>
        xmlstarlet ed \
            -L \
            -s "/SecFloatingFeatureSet" \
            -t elem \
            -n "${feature_code}" \
            -v "${feature_code_value}" \
            "${BUILD_TARGET_FLOATING_FEATURE_PATH}"
    else
        # If the feature code already exists, call a function to modify the XML
        changeXMLValues "${feature_code}" "${feature_code_value}" "${BUILD_TARGET_FLOATING_FEATURE_PATH}"
    fi
}

function addCSCxmlValues() {
    local feature_code="$1"
    local feature_code_value="$2"
    for EXPECTED_CSC_FEATURE_XML_PATH in $PRODUCT_DIR/omc/*/conf/cscfeature.xml $OPTICS_DIR/configs/carriers/*/*/conf/system/cscfeature.xml; do
        if [ -f "$EXPECTED_CSC_FEATURE_XML_PATH" ]; then
            if [ "$(catchDuplicatesInXML "${feature_code}" "${EXPECTED_CSC_FEATURE_XML_PATH}")" == 0 ]; then
                xmlstarlet ed \
                    -L \
                    -s "/FeatureSet" \
                    -t elem \
                    -n "${feature_code}" \
                    -v "${feature_code_value}" \
                    "$EXPECTED_CSC_FEATURE_XML_PATH"
            else
                changeXMLValues "${feature_code}" "${feature_code_value}" "${EXPECTED_CSC_FEATURE_XML_PATH}"
            fi
        fi
    done
}

function tinkerWithCSCFeaturesFile() {
    local action="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
    local decoder_jar="./src/dependencies/bin/omc-decoder.jar"

    # Ensure decoder exists
    [ ! -f "$decoder_jar" ] && abort "Error: omc-decoder.jar not found!" "tinkerWithCSCFeaturesFile"

    # handle arg
    case "${action}" in
        --decode)
            for EXPECTED_CSC_FEATURE_XML_PATH in $PRODUCT_DIR/omc/*/conf/cscfeature.xml $OPTICS_DIR/configs/carriers/*/*/conf/system/cscfeature.xml; do
                [ -f "${EXPECTED_CSC_FEATURE_XML_PATH}" ] || continue
                file "${EXPECTED_CSC_FEATURE_XML_PATH}" | grep -q data || continue
                debugPrint "tinkerWithCSCFeaturesFile(): File chosen: $EXPECTED_CSC_FEATURE_XML_PATH"
                if java -jar "$decoder_jar" -i "${EXPECTED_CSC_FEATURE_XML_PATH}" -o "${EXPECTED_CSC_FEATURE_XML_PATH}__decoded.xml" &>>$thisConsoleTempLogFile; then
                    debugPrint "tinkerWithCSCFeaturesFile(): CSC feature file successfully decoded: ${EXPECTED_CSC_FEATURE_XML_PATH}"
                else
                    abort "Failed to decode CSC manifest. Check logs for details." "tinkerWithCSCFeaturesFile"
                fi
            done
            debugPrint "CSC feature file(s) successfully decoded."
        ;;
        --encode)
            for EXPECTED_CSC_FEATURE_XML_PATH in $PRODUCT_DIR/omc/*/conf/cscfeature.xml $OPTICS_DIR/configs/carriers/*/*/conf/system/cscfeature.xml; do
                [ -f "${EXPECTED_CSC_FEATURE_XML_PATH}" ] || continue
                [ -f "${EXPECTED_CSC_FEATURE_XML_PATH}__decoded.xml" ] || continue
                file "${EXPECTED_CSC_FEATURE_XML_PATH}" | grep -q data && continue
                if java -jar "$decoder_jar" -e -i "${EXPECTED_CSC_FEATURE_XML_PATH}__decoded.xml" -o "${EXPECTED_CSC_FEATURE_XML_PATH}" &>>$thisConsoleTempLogFile; then
                    debugPrint "CSC feature file successfully encoded: ${EXPECTED_CSC_FEATURE_XML_PATH}"
                    rm -f "${EXPECTED_CSC_FEATURE_XML_PATH}__decoded.xml"
                else
                    abort "Failed to encode: ${EXPECTED_CSC_FEATURE_XML_PATH}. Check logs for details." "tinkerWithCSCFeaturesFile"
                fi
            done
        ;;
        *)
            abort "Usage: tinkerWithCSCFeaturesFile --decode | --encode <file>" "tinkerWithCSCFeaturesFile"
        ;;
    esac
}

function changeXMLValues() {
    local feature_code="$1"
    local feature_code_value="$2"
    local file="$3"

    # do checks and put ts shyt in log
    debugPrint "changeXMLValues(): Arguments: $1 $2 $3"
    [[ -z "$file" || ! -f "$file" ]] && abort "Error: No XML file specified or file is not found." "changeXMLValues"

    # Check if the feature code is already set to the desired value
    if xmlstarlet sel -t -v "count(//${feature_code}[text() = '${feature_code_value}'])" "$file" | grep -q '1'; then
        debugPrint "changeXMLValues(): ${feature_code} is already set to ${feature_code_value}, skipping."
        return 0
    fi

    # If the feature code is an attribute (e.g., feature_code="value"), update it
    if xmlstarlet sel -t -v "count(//@${feature_code})" "$file" | grep -q '[1-9]'; then
        xmlstarlet ed -L -u "//*[@${feature_code}]" -v "${feature_code_value}" "$file"
        debugPrint "changeXMLValues(): Updated ${feature_code} to ${feature_code_value} in $file"
    
    # If the feature code is an element (e.g., <feature_code>value</feature_code>), update it
    elif xmlstarlet sel -t -v "count(//${feature_code})" "$file" | grep -q '[1-9]'; then
        xmlstarlet ed -L -u "//${feature_code}" -v "${feature_code_value}" "$file"
        debugPrint "changeXMLValues(): Updated <${feature_code}> value to ${feature_code_value} in $file"
    else
        debugPrint "changeXMLValues(): No matching ${feature_code} found. Skipping modification."
    fi
}

function changeYAMLValues() {
    local key="$1"
    local value="$2"
    local file="$3"

    # do checks and put ts shyt in log
    [[ -z "$file" || ! -f "$file" ]] && abort "Error: No file specified or the file is not found." "changeYAMLValues"
    debugPrint "changeYAMLValues(): Arguments: $1 $2 $3"

    # ok lets go
    grep -Eq "^[[:space:]]*${key}:" "$file" && sed -i -E "s|(^[[:space:]]*${key}:)[[:space:]]*.*|\1 ${value}|" "$file"
}

function ask() {
    local question="$1"
    local answer
    printf "[\e[0;35m$(date +%d-%m-%Y) \e[0;37m- \e[0;32m$(date +%H:%M%p)\e[0;37m] / [:\e[0;36mMESSAGE\e[0;37m:] / [:\e[0;32mJOB\e[0;37m:] -\e[0;33m $1\e[0;37m (y/n) : "
    read answer
    [[ "$(echo "$answer" | tr '[:upper:]' '[:lower:]')" == "y|yes" ]]
}

function removeAttributes() {
    local INPUT_FILE="$1"
    local NAME_TO_SKIP="$2"

    debugPrint "removeAttributes(): Input file: ${INPUT_FILE}, Attribute to Skip: ${NAME_TO_SKIP}"

    # Validate input
    [ ! -f "$INPUT_FILE" ] && { debugPrint "removeAttributes(): Error: Input file not found!"; return 1; }
    [ -z "$NAME_TO_SKIP" ] && { debugPrint "removeAttributes(): Error: Attribute to skip was not provided"; return 1; }

    # Backup original
    cp "$INPUT_FILE" "${INPUT_FILE}.bak"

    # Use xmlstarlet to remove <hal> blocks with <name> equal to NAME_TO_SKIP
    xmlstarlet ed -P -L \
        -d "/manifest/hal[name='$NAME_TO_SKIP']" \
        "$INPUT_FILE"

    if cmp -s "$INPUT_FILE" "${INPUT_FILE}.bak"; then
        debugPrint "removeAttributes(): No changes made. <hal> with name=$NAME_TO_SKIP was not found."
    else
        debugPrint "removeAttributes(): Updated XML saved to $INPUT_FILE, removed <hal> with name=$NAME_TO_SKIP."
    fi
    rm "${INPUT_FILE}.bak"
}

function addTheWallpaperMetadata() {
    local value="$1" type="$(echo "$2" | tr '[:upper:]' '[:lower:]')" index="$3"
    local filename="wallpaper_${value}.png"
    local path

    case "$type" in
        home)
            isDefault=true
            which=1
            the_homescreen_wallpaper_has_been_set=true
            ;;
        lock)
            isDefault=true
            which=2
            the_lockscreen_wallpaper_has_been_set=true
            ;;
        additional)
            isDefault=false
            which=1
            ;;
    esac

    cat >> resources_info.json << EOF
    {
        "isDefault": ${isDefault},
        "index": ${index},
        "which": ${which},
        "screen": 0,
        "type": 0,
        "filename": "${filename}",
        "frame_no": -1,
        "cmf_info": [""]
    }${special_symbol}
EOF

    debugPrint "User chose to make wallpaper_${value}.png as ${type} screen wallpaper."
    printf " - Enter the path to the default ${type^} wallpaper: "
    read path
    if [ -f "$path" ]; then
        debugPrint "[INDEX: $index | TYPE: $type] $path -> ./src/tsukika/packages/flosspaper_purezza/res/drawable-nodpi/${filename}"
        cp -af "$path" "./src/tsukika/packages/flosspaper_purezza/res/drawable-nodpi/${filename}"
    else
        abort "Wrong wallpaper image path, aborting this build..." "addTheWallpaperMetadata"
    fi
    clear
}

function stringFormat() {
    case "$1" in
        -l|--lower)
            echo "$2" | tr '[:upper:]' '[:lower:]'
        ;;
        -u|--upper)
            echo "$2" | tr '[:lower:]' '[:upper:]'
        ;;
        *)
            echo "$2"
        ;;
    esac
}

function generateRandomHash() {
    local how_much="$1"
    local byte_count=$(( (how_much + 1) / 2 ))
    local hex=$(head -c "$byte_count" /dev/urandom | xxd -p | tr -d '\n')
    [[ $# -eq 1 ]] || abort "generateRandomHash(): Expected 1 argument, got $#" "generateRandomHash"
    debugPrint "generateRandomHash(): Requested random seed: ${how_much}"
    echo "${hex:0:how_much}"
}

function fetchRomArch() {
    if [[ ! -f "${SYSTEM_DIR}/lib/libbluetooth.so" && -f "${SYSTEM_DIR}/lib64/libbluetooth.so" && ${BUILD_TARGET_SDK_VERSION} -le "30" ]]; then
        [ "$1" == "--libpath" ] && echo "lib64"
    elif [[ ! -f "${SYSTEM_DIR}/lib/libbluetooth.so" && -f "${SYSTEM_DIR}/lib64/libbluetooth.so" && ${BUILD_TARGET_SDK_VERSION} -ge "31" ]]; then
        [ "$1" == "--libpath" ] && echo "lib64"
    else
        [ "$1" == "--libpath" ] && echo "lib"
    fi
}

function debugPrint() {
    if [ -n "${DEBUG_SCRIPT}" ]; then
        console_print "$@"
        sleep 0.5
    else
        echo "[$(date +%H:%M%p)] - $@" >> ${thisConsoleTempLogFile}
    fi
}

function applyDiffPatches() {
    local DiffPatchFile="$1"
    local TheFileToPatch="$2"
    [ "$#" -ne 2 ] && abort "Error: Missing arguments. Usage: applyDiffPatches <patch file> <target file>" "applyDiffPatches"
    if [ ! -f "$DiffPatchFile" ]; then
        debugPrint "applyDiffPatches(): Patch file '$DiffPatchFile' not found."
        abort "Error: Patch file '${DiffPatchFile}' not found." "applyDiffPatches"
    elif [ ! -f "$TheFileToPatch" ]; then
        debugPrint "applyDiffPatches(): Target file '$TheFileToPatch' not found."
        abort "Error: Target file '${TheFileToPatch}' not found." "applyDiffPatches"
    fi
    debugPrint "applyDiffPatches(): ${DiffPatchFile} → ${TheFileToPatch}"
    patch "$TheFileToPatch" < "$DiffPatchFile" &>>$thisConsoleTempLogFile || console_print "Patch failed! Check logs for details."
}

function checkBuildProp() {
    [ -z "$1" ] && abort "Usage: checkBuildProp <partition path>" "checkBuildProp"
    [ -f "$1/build.prop" ] && echo "$1/build.prop"
    [ -f "$1/etc/build.prop" ] && echo "$1/etc/build.prop"
}

function downloadGLmodules() {
    # test internet connection before anything:
    checkInternetConnection "GOODLOCK_MODULES" || return 1
    local i
    local SequenceValue
    local MaximumSDKVersion=35
    local MinimumSDKVersion=28

    case "${BUILD_TARGET_SDK_VERSION}" in
        28) SequenceValue=13 ;;
        29|33|35) SequenceValue=15 ;;
        30|31|32) SequenceValue=14 ;;
        34) SequenceValue=16 ;;
        *) warns "Unsupported SDK version, skipping the installation of goodlook modules..." "GOODLOCK_INSTALLER"; return 1; ;;
    esac

    for i in $(seq 0 $(($SequenceValue - 1))); do
        if [[ "${BUILD_TARGET_SDK_VERSION}" -ge "${MinimumSDKVersion}" && "${BUILD_TARGET_SDK_VERSION}" -le "${MaximumSDKVersion}" ]]; then
            case "${BUILD_TARGET_SDK_VERSION}" in
                28)
                    if ask "Do you want to download ${GOODLOOK_MODULES_FOR_28_APP_NAMES[$i]}?"; then
                        mkdir -p ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_28_APP_NAMES[$i]}/
                        downloadRequestedFile https://github.com/corsicanu/goodlock_dump/releases/download/28/${GOODLOOK_MODULES_FOR_28[$i]} ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_28_APP_NAMES[$i]}/
                    else 
                        rmdir ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_28_APP_NAMES[$i]}/
                    fi
                ;;
                29)
                    if ask "Do you want to download ${GOODLOOK_MODULES_FOR_29_APP_NAMES[$i]}?"; then
                        mkdir -p ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_29_APP_NAMES[$i]}/
                        downloadRequestedFile https://github.com/corsicanu/goodlock_dump/releases/download/29/${GOODLOOK_MODULES_FOR_29[$i]} ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_29_APP_NAMES[$i]}/
                    else 
                        rmdir ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_29_APP_NAMES[$i]}/
                    fi
                ;;
                30)
                    if ask "Do you want to download ${GOODLOOK_MODULES_FOR_30_APP_NAMES[$i]}?"; then
                        mkdir -p ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_30_APP_NAMES[$i]}/
                        downloadRequestedFile https://github.com/corsicanu/goodlock_dump/releases/download/30/${GOODLOOK_MODULES_FOR_30[$i]} ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_30_APP_NAMES[$i]}/
                    else 
                        rmdir ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_30_APP_NAMES[$i]}/
                    fi
                ;;
                31)
                    if ask "Do you want to download ${GOODLOOK_MODULES_FOR_31_APP_NAMES[$i]}?"; then
                        mkdir -p ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_31_APP_NAMES[$i]}/
                        downloadRequestedFile https://github.com/corsicanu/goodlock_dump/releases/download/31/${GOODLOOK_MODULES_FOR_31[$i]} ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_31_APP_NAMES[$i]}/
                    else 
                        rmdir ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_31_APP_NAMES[$i]}/
                    fi
                ;;
                32)
                    if ask "Do you want to download ${GOODLOOK_MODULES_FOR_32_APP_NAMES[$i]}?"; then
                        mkdir -p ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_32_APP_NAMES[$i]}/
                        downloadRequestedFile https://github.com/corsicanu/goodlock_dump/releases/download/32/${GOODLOOK_MODULES_FOR_32[$i]} ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_32_APP_NAMES[$i]}/
                    else 
                        rmdir ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_32_APP_NAMES[$i]}/
                    fi
                ;;
                33)
                    if ask "Do you want to download ${GOODLOOK_MODULES_FOR_33_APP_NAMES[$i]}?"; then
                        mkdir -p ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_33_APP_NAMES[$i]}/
                        downloadRequestedFile https://github.com/corsicanu/goodlock_dump/releases/download/33/${GOODLOOK_MODULES_FOR_33[$i]} ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_33_APP_NAMES[$i]}/
                    else 
                        rmdir ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_33_APP_NAMES[$i]}/
                    fi
                ;;
                34)
                    if ask "Do you want to download ${GOODLOOK_MODULES_FOR_34_APP_NAMES[$i]}?"; then
                        mkdir -p ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_34_APP_NAMES[$i]}/
                        downloadRequestedFile https://github.com/corsicanu/goodlock_dump/releases/download/34/${GOODLOOK_MODULES_FOR_34[$i]} ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_34_APP_NAMES[$i]}/
                    else 
                        rmdir ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_34_APP_NAMES[$i]}/ 
                    fi
                ;;
                35)
                    if ask "Do you want to download ${GOODLOOK_MODULES_FOR_35_APP_NAMES[$i]}?"; then
                        mkdir -p ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_35_APP_NAMES[$i]}/
                        downloadRequestedFile https://github.com/corsicanu/goodlock_dump/releases/download/35/${GOODLOOK_MODULES_FOR_35[$i]} ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_35_APP_NAMES[$i]}/
                    else 
                        rmdir ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_35_APP_NAMES[$i]}/
                    fi
                ;;
            esac
        fi
    done
}

function checkInternetConnection() {
    ping -w 3 google.com &>/dev/null || warns "Please connect the computer to a wifi or an ethernet connection to access online facilities." "$(stringFormat -u $1)" && return 1
    return 0
}

# needs fix actually.
function manageCameraFeatures() {
    local arg="$1"
    local featureName="$2"
    local extvalues="$3"
    local afterThisAttribute="$4"
    local XMLFile

    # handle args:
    if [ "${arg}" == "--add" ]; then
        XMLFile="$5"
        # First, remove any existing feature (to avoid conflicts)
        manageCameraFeatures --remove "${featureName}" "${XMLFile}"
        # Add new feature after the specified attribute
        xmlstarlet ed -L -s "//resources/*[name()='${afterThisAttribute}']" -t elem -n "${featureName}" -v "${extvalues}" "$XMLFile"
        echo "</resources>" >> "$XMLFile"  # Ensure the resources close tag is still added.
    elif [ "${arg}" == "--remove" ]; then
        XMLFile="$3"
        # Remove the feature from the XML
        xmlstarlet ed -L -d "//resources/*[name()='${featureName}']" "$XMLFile"
        echo "</resources>" >> "$XMLFile"  # Ensure the resources close tag is still added.
    fi
}

function parseBuildValues() {
    while IFS='=' read -r key value; do
        echo "$key ${value:-<empty>}"
    done < "$1"
}

function replaceTargetBuildProperties() {
    [[ "$BUILD_TARGET_REPLACE_REQUIRED_PROPERTIES" == true ]] || return 1
    local BUILD_TARGET="$1"
    local scope file key value
    console_print "Replacing properties for your device...."
    for entry in "vendor ./src/target/${BUILD_TARGET}/replaceableVendorProps.prop" "system ./src/target/${BUILD_TARGET}/replaceableSystemProps.prop"; do
        read -r scope file <<< "$entry"
        [[ ! -f "$file" || $(grep -c "nothing to replace" "$file") -ne 0 ]] && continue
        while read -r key value; do
            [[ "$scope" == "vendor" ]] && setprop --vendor "$key" "$value"
            [[ "$scope" == "system" ]] && setprop --system "$key" "$value"
        done < <(parseBuildValues "$file")
    done
}

# takes backup of the blob, restores only if they were not copied properly.
function copyDeviceBlobsSafely() {
    local blobFromSource="$1"
    local blobInROM="$2"
    local backupBlob="./local_build/tmp/tsuki/${blobInROM}.bak"
    console_print "Trying to copy ${blobFromSource} to ${blobInROM}"
    [ -f "$blobInROM" ] && cp -af "$blobInROM" "$backupBlob"; 
    if [ ! -f "$blobInROM" ] && ask "${blobFromSource} is not found on the ROM, do you wanna copy this blob to the device?"; then
        if ! cp -af "${blobFromSource}" "${blobInROM}" 2>>${thisConsoleTempLogFile}; then
            warns "Failed to copy ${blobFromSource}, this might cause a bootloop, attempting to restore original blob." "copyDeviceBlobsSafely()"
            [ -f "$backupBlob" ] && cp -af "$backupBlob" "$blobInROM"
        fi
    else
        if ! cp -af "${blobFromSource}" "${blobInROM}"; then
            warns "Failed to copy ${blobFromSource}, this might cause a bootloop, attempting to restore original blob." "copyDeviceBlobsSafely()"
            [ -f "$backupBlob" ] && cp -af "$backupBlob" "$blobInROM"
        fi
    fi
    console_print "Finished copying given blobs!"
    rm -f "$backupBlob"
}

function magiskboot() {
    local localMachineArchitecture=$(uname -m)
    case "${localMachineArchitecture}" in 
        "i686")
            magiskbootX32 "$@"
        ;;
        "x86_64")
            magiskbootX64 "$@"
        ;;
        "armv7l")
            magiskbootA32 "$@"
        ;;
        "aarch64"|"armv8l")
            magiskbootA64 "$@"
        ;;
        *)
            abort "Undefined architecture ${localMachineArchitecture}" "magiskboot"
        ;;
    esac
}

function avbtool() {
    python3 ./src/dependencies/bin/avbtool "$@"
}

# Thanks to salvo and ravindu for their amazing work!
function javaKeyStoreToHex() {
    # lky variables
    local keystoreFileNameString="$(generateRandomHash 30)"
    local keystorePemFileNameString="$(generateRandomHash 30)"
    local keystoreKeyFileNameString="$(generateRandomHash 30)"
    local hexKey
    
    # check up:
    command -v openssl >/dev/null 2>&1 || abort "openssl not found. Please install it." "javaKeyStoreToHex"
    command -v keytool >/dev/null 2>&1 || abort "keytool not found. Please install it." "javaKeyStoreToHex"

    # override if prebuilt key exists:
    if [ -f ${MY_KEYSTORE_PATH} ]; then
        if [ "$MY_KEYSTORE_PATH" == "./test-keys/tsukika.jks" ]; then
            console_print "PLEASE DONT USE THIS KEY, GENERATE YOUR OWN KEY!!"
            ask "By using this key on your release builds, the release builds will become vulnerable. Do you want to continue?" || return 1
        fi
        keytool -exportcert -alias ${MY_KEYSTORE_ALIAS} -keystore ${MY_KEYSTORE_PATH} -storepass ${MY_KEYSTORE_PASSWORD} -rfc > ${keystoreKeyFileNameString}.x509.pem
        ( openssl x509 -inform PEM -in ${keystoreKeyFileNameString}.x509.pem -outform DER | xxd -p | tr -d '\n' ) > hex.key
        hexKey=$(cat hex.key)
        rm ${keystoreKeyFileNameString}.x509.pem hex.key
    else
        # main():
        openssl genrsa -out ${keystorePemFileNameString}.pem 2048
        openssl pkcs8 -in ${keystorePemFileNameString}.pem -topk8 -outform DER -out ${keystoreKeyFileNameString}.pk8 -nocrypt
        openssl req -new -x509 -key ${keystorePemFileNameString}.pem -out ${keystoreKeyFileNameString}.x509.pem -days 82435 -subj "/C=JP/ST=北海道/L=富良野/O=Tsukika/OU=Tsukika-Public/CN=Tsukika"
        ( openssl x509 -inform PEM -in ${keystoreKeyFileNameString}.x509.pem -outform DER | xxd -p | tr -d '\n' ) > hex.key
        hexKey=$(cat hex.key)
        rm ${keystorePemFileNameString}.pem hex.key ${keystoreKeyFileNameString}.pk8 ${keystoreKeyFileNameString}.x509.pem
    fi

    # changes the hex in the patch file:
    if [ "${BUILD_TARGET_SDK_VERSION}" == "34" ]; then
        sed -i 's|\(const-string v1, "\)[^"]*|\1'${hexKey}'|' ${DIFF_UNIFIED_PATCHES[36]}
    elif [ "${BUILD_TARGET_SDK_VERSION}" == "35" ]; then
        sed -i 's|\(const-string v1, "\)[^"]*|\1'${hexKey}'|' ${DIFF_UNIFIED_PATCHES[37]}
    else
        console_print "Signature patch is not available for this SDK version."
        return 1
    fi

    # error checks:
    if [ "$?" == 0 ]; then
        console_print "Successfully added your key into the patch file!!"
    else
        abort "Failed to add your key into the patch file!!" "javaKeyStoreToHex"
    fi
}

function addTsukikaROMInfo() {
    # check:
    [ "${BUILD_TARGET_SDK_VERSION}" == "35" ] || return 1

    # internal variables, let's not break stuff yk.
    local input_file="$1"
    local output_file="$2"
    local needToAddAttrOnNextRun=false
    local runs=0

    # verify files:
    [[ -f "${input_file}" && -f "${output_file}" ]] || abort "usage: addTsukikaROMInfo <input / stock xml> <output (can be anything)>" "addTsukikaROMInfo"

    # nukes and recreates the output file
    rm -f $output_file
    touch $output_file

    # Reads line by line
    while IFS= read -r i || [[ -n "$i" ]]; do
        # "ahem"
        runs=$((runs + 1))
        debugPrint "addTsukikaROMInfo(): at the $runs line of the xml"
        
        # Removes whitespaces:
        i=$(echo "$i" | sed 's/^[ \t]*//;s/[ \t]*$//')

        # adds whitelines:
        echo "$i" | grep -qE "http://schemas.android.com/apk/res/android|xmlns:android" && spacing="\t"
        echo "$i" | grep -q "</PreferenceScreen>" && spacing=""

        # Skips empty lines
        [ -z "$i" ] && continue

        # Sets flag if we are in the xmlns line so we can add the stuff.
        echo "$i" | grep -q "http://schemas.android.com/apk/res/android" && needToAddAttrOnNextRun=true

        # Writes current line
        echo -e "${spacing}$i" >> "$output_file"

        # Inserts block after xmlns line, only once
        if [ "$needToAddAttrOnNextRun" == true ]; then
            echo -e "\t<Preference android:title=\"Tsukika Version &amp; Codename\" android:summary=\"v${CODENAME_VERSION_REFERENCE_ID} - ${CODENAME}\" android:key=\"tsukika_version\" />\n\t<Preference android:title=\"Your Device Maintainer\" android:summary=\"${BUILD_USERNAME} | Unmaintained / Unofficial Build\" android:key=\"tsukika_maintainer\" />\n\t<Preference android:title=\"OS Changelogs\" android:summary=\"View rom changelogs\" android:key=\"tsukika_changelogs\">\n\t<intent android:action=\"android.intent.action.VIEW\"\n\t\tandroid:data=\"http://github.com/ayumi-aiko/Tsukika/updaterConfigs/changelogs_placebo.html\" />\n\t</Preference>" >> $output_file
            needToAddAttrOnNextRun=false
        fi
    done < "$input_file"
}

function setMakeConfigs() {
    local propVariableName="$1"
    local propValue="$2"
    local propFile="$3"
    if grep -qE "^${propVariableName}=" "$propFile"; then
        awk -v key="$propVariableName" -v val="$propValue" '
        BEGIN { updated=0 }
        {
            if ($0 ~ "^" key "=") {
                print key "=" val
                updated=1
            } else {
                print
            }
        }
        END {
            if (!updated) print key "=" val
        }' "$propFile" > "${propFile}.tmp"
    else
        cp "$propFile" "${propFile}.tmp"
        echo "${propVariableName}=${propValue}" >> "${propFile}.tmp"
    fi
    mv "${propFile}.tmp" "$propFile"
}

function getImageFileSystem() {
    for knownFileSystems in F2FS ext2 ext4 EROFS; do
        file "$1" | grep -q $knownFileSystems && stringFormat --lower "${knownFileSystems}" && return 0
    done
    # reached this far means: undefined / unsupported filesystem.
    echo "undefined"
}

function setupLocalImage() {
    local imagePath="$1"
    local mountPath="$2"
    local imageBlock="$(basename "$imagePath" | sed -E 's/\.img(\..+)?$//')"
    local fsType="$(getImageFileSystem "${imagePath}")"
    local dirt

    case "$fsType" in
        "erofs")
            dirt="${mountPath}__rw"
            mkdir -p "$dirt"
            sudo fuse.erofs "${imagePath}" "${mountPath}" 2>>$thisConsoleTempLogFile || abort "Failed to mount EROFS image: ${imagePath}" "setupLocalImage"
            sudo cp -a --preserve=all "${mountPath}" "${dirt}/" || abort "Failed to copy contents to writable directory: ${dirt}" "setupLocalImage"
            [ -f "${dirt}/system/build.prop" ] && setMakeConfigs "$(echo "${imageBlock}" | tr '[:lower:]' '[:upper:]')_DIR" "${dirt}/system" "./src/makeconfigs.prop"
            [ -d "${dirt}/system/system_ext" ] && setMakeConfigs "SYSTEM_EXT_DIR" "${dirt}/system/system_ext" "./src/makeconfigs.prop"
            [ -f "${dirt}/build.prop" ] && setMakeConfigs "$(echo "${imageBlock}" | tr '[:lower:]' '[:upper:]')_DIR" "${dirt}" "./src/makeconfigs.prop"
        ;;
        "f2fs"|"ext4"|"ext2")
            sudo mount -o rw,relatime "${imagePath}" "${mountPath}" || abort "Failed to mount ${imageBlock} as read-write" "setupLocalImage"
            if [ -f "${mountPath}/system/build.prop" ]; then
                setMakeConfigs "SYSTEM_DIR" "${mountPath}/system" "./src/makeconfigs.prop"
                setMakeConfigs "SYSTEM_EXT_DIR" "${mountPath}/system/system_ext" "./src/makeconfigs.prop"
            elif [ -f "${mountPath}/build.prop" ]; then
                setMakeConfigs "$(echo "${imageBlock}" | tr '[:lower:]' '[:upper:]')_DIR" "${mountPath}" "./src/makeconfigs.prop"
            fi
        ;;
        *)
            abort "Filesystem type '${fsType}' not supported. Image path: ${imagePath}" "setupLocalImage"
        ;;
    esac
}

function repackSuperFromDump() {
    local dump_file="./local_build/etc/dumpOfTheSuperBlock"
    local image_dir="./local_build/etc/extract/super_extract/"
    local output_img="$1"
    local total_size=0
    local part
    local group
    local img_path
    local size=0
    local device_size=0
    local buffer=0
    local cmd
    local metadata_size=$(grep -i "Metadata max size:" "$dump_file" | grep -o '[0-9]\+')
    local current_slot=$(grep -i "Current slot:" "$dump_file" | grep -oE "_[ab]")
    declare -A part_to_group
    declare -A added_groups
    local partitions=()

	# basic checks:
	if [[ -z "${image_dir}" || -z "${output_img}" ]]; then
        abort "❌ Invalid paths for image directory or output image."
	elif [[ ! -f "$dump_file" ]]; then
        abort "❌ Dump file not found: $dump_file"
	elif [[ -z "$metadata_size" ]]; then
		abort "❌ Failed to extract metadata size from dump."
	elif [[ -z "$current_slot" ]]; then
		abort "❌ Could not detect current slot from dump."
	fi

	# main stuffs start from here:
    while IFS= read -r line; do
		[[ $line == "Super partition layout:" ]] && break;
        if [[ $line =~ ^\ {2}Name:\ (.+) ]]; then
            part="${BASH_REMATCH[1]}"
			[[ "$part" == *_${current_slot/_/} ]] || continue
        elif [[ $line =~ ^\ {2}Group:\ (.+) ]]; then
            group="${BASH_REMATCH[1]}"
            part_to_group["$part"]="$group"
		fi
    done < "$dump_file"

    for part in "${!part_to_group[@]}"; do
        img_path="$image_dir/$part.img"
        if [[ -f "$img_path" ]]; then
            size=$(stat -c%s "$img_path")
            total_size=$((total_size + size))
            partitions+=("$part:$img_path:${part_to_group[$part]}")
        fi
    done

    [[ ${#partitions[@]} -eq 0 ]] && abort "❌ No valid .img files found in $image_dir"

	# dynamic buffer: 64MiB per partition
	buffer=$((64 * 1024 * 1024 * ${#partitions[@]}))
    device_size=$((total_size + buffer))

    cmd="lpmake \
		--metadata-size $metadata_size \
		--super-name super \
		--device super:$device_size"

    for entry in "${partitions[@]}"; do
        IFS=':' read -r part path group <<< "$entry"
        if [[ -z "${added_groups[$group]}" ]]; then
            cmd+=" --group $group:$device_size"
            added_groups[$group]=1
        fi
    done

    for entry in "${partitions[@]}"; do
        IFS=':' read -r part path group <<< "$entry"
        cmd+=" --partition $part:readonly:$group"
        cmd+=" --image $part=\"$path\""
    done
	# main stuffs ends from here

    cmd+=" --output \"$output_img\""
    eval "$cmd"

	[ $? -eq 0 ] || abort "❌ Failed to pack image."
}

function buildImage() {
    local blockPath="$1"
    local block="$2"
    local imagePath=$(mount | grep "${blockPath}" | awk '{print $1}')
    [[ -f "$blockPath" ]] || return 1
    mkdir -p ./local_build/buildedContents/
    if [[ "$blockPath" =~ __rw$ ]]; then
        console_print "EROFS fs detected, building an EROFS image..."
        sudo mkfs.erofs -z lz4 --mount-point="${block}" "./local_build/buildedContents/${block}_built.img" "${blockPath}/" &>>$thisConsoleTempLogFile || abort "Failed to build EROFS image from ${blockPath}"
    else 
        console_print "F2FS/EXT4 fs detected, unmounting the image..."
        sudo umount "${blockPath}" || abort "Failed to unmount ${blockPath}, aborting this instance..."
        console_print "Successfully unmounted ${blockPath}."
        [ -f "$imagePath" ] && cp "$imagePath" "./local_build/buildedContents/${block}_built.img" &>>$thisConsoleTempLogFile || abort "Failed to copy the image to the build directory."
        rm "$imagePath"
    fi
    console_print "Successfully built ${block}.img"
    console_print "$block can be found at ./local_build/buildedContents/${block}_built.img"
}

function logInterpreter() {
    local debugMessage="$1"
    local command="$2"
    local returnStatus
    debugPrint "$(echo $command | awk '{print $1}')(): $debugMessage" 
    eval "$command" &> "$TMPFILE"
    returnStatus=$?
    [[ ! -z "$(cat "$TMPFILE")" ]] && echo "[$(date +%H:%M%p)] - $(echo $command | awk '{print $1}')() output: $(xargs < "$TMPFILE")" >> "$thisConsoleTempLogFile"
    return ${returnStatus}
}

function compareDefaultMakeConfigs() {
    local differences localValue localUntouchedValue
    for differences in $(cat "./src/makeconfigs.prop" | grep =); do
        localVariableValue="$(echo "${differences}" | cut -d '=' --fields=-1)"
        localValue=$(grep_prop ${localVariableValue} ./src/makeconfigs.prop)
        localUntouchedValue=$(grep_prop ${localVariableValue} ./localUntouched)
        [ "${localValue}" == "${localUntouchedValue}" ] || echo "+ ${localVariableValue}"
    done
}

function makeAFuckingDirectory() {
    local directoryName="$1"
    local owner="$2"
    local group="$3"
    mkdir -p "${directoryName}"
    chmod 755 "${directoryName}"
    chown -R "${owner}:${group}" "${directoryName}"
    chcon u:object_r:system_file:s0 "${directoryName}"
}

function getLatestReleaseFromGithub() {
    local githubReleaseURL="$1"
    if [[ -z "$githubReleaseURL" ]]; then
        echo "Error: No GitHub release URL provided."
        return 1
    fi
    local latestRelease=$(curl -s "$githubReleaseURL" | grep -oP '"browser_download_url": "\K[^"]+')
    if [[ -z "$latestRelease" ]]; then
        echo "Error: Could not retrieve the latest release URL."
        return 1
    fi
    echo "$latestRelease"
}