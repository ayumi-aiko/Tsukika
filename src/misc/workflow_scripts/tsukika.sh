#!/bin/bash
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

# source the functions script:
source ./src/misc/build_scripts/util_functions.sh

# dependencies urls:
apktool="https://api.github.com/repos/iBotPeaches/Apktool/releases/latest"
uberApkSigner="https://api.github.com/repos/patrickfav/uber-apk-signer/releases/latest"

# latest version of the dependencies from the respective GitHub repositories:
apktoolVersion=$(curl -s "$apktool" | grep -oP '"tag_name": "\K(.*)(?=")' | sed 's/[^0-9.]//g')
uberApkSignerVersion=$(curl -s "$uberApkSigner" | grep -oP '"tag_name": "\K(.*)(?=")' | sed 's/[^0-9.]//g')

# local version of those dependencies:
apktoolLocalVersion=$(java -jar "./src/dependencies/bin/apktool.jar" --version 2>/dev/null | sed 's/[^0-9.]//g')
uberApkSignerLocalVersion=$(java -jar "./src/dependencies/bin/signer.jar" --version 2>/dev/null | sed 's/[^0-9.]//g')

if [ "$1" == "--update-dependencies" ]; then
    if [[ "${apktoolVersion}" == "${apktoolLocalVersion}" ]]; then
        console_print "Apktool is up to date with the repo."
    else
        console_print "Trying to update Apktool..."
        rm -rf "./src/dependencies/bin/apktool.jar"
        if downloadRequestedFile "$(getLatestReleaseFromGithub "${apktool}")" "./src/dependencies/bin/apktool.jar"; then
            console_print "Apktool updated successfully to version ${apktoolVersion}."
        else
            abort "Failed to update Apktool."
        fi
        git add "./src/dependencies/bin/apktool.jar"
        textAppend[0]="apktool updated from ${apktoolLocalVersion} to version ${apktoolVersion}"
    fi
    if [[ "${uberApkSignerVersion}" == "${uberApkSignerLocalVersion}" ]]; then
        console_print "Uber Apk Signer is up to date with the repo."
    else
        console_print "Trying to update Uber Apk Signer..."
        rm -rf "./src/dependencies/bin/signer.jar"
        if downloadRequestedFile "$(getLatestReleaseFromGithub "${uberApkSigner}")" "./src/dependencies/bin/signer.jar"; then
            console_print "Uber Apk Signer updated successfully to version ${uberApkSignerVersion}."
        else
            abort "Failed to update Uber Apk Signer."
        fi
        git add "./src/dependencies/bin/signer.jar"
        textAppend[1]="uber-apk-signer updated from ${uberApkSignerLocalVersion} to version ${uberApkSignerVersion}"
    fi
    # let's push the changes to the repository:
    if git diff --exit-code; then
        console_print "No changes to commit."
    else
        console_print "Committing changes..."
        joined=$(IFS=', '; echo "${textAppend[*]}")
        git commit -m "github-actions: dependencies: ${joined}"
        console_print "Trying to push changes to the repository..."
        git push -u origin main || abort "Failed to push changes to the repository."
        console_print "Changes pushed successfully."
        console_print "Workflow completed successfully."
    fi
fi