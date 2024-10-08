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

# Show help when no target is provided
ifeq ($(MAKECMDGOALS),)
	.DEFAULT_GOAL := help
endif

# common-build:
SHELL := /bin/bash
OLD_REFERENCE_URL = https://raw.githubusercontent.com/ayumi-aiko/Tsukika/ref/ota-manifest.xml

# dont ask anything bud:
UBER_SIGNER_JAR = ./src/dependencies/bin/signer.jar
APKTOOL_JAR = ./src/dependencies/bin/apktool.jar

# apk/jar signing key: please use your own private key and be sure to not leak it:
# using Tsukika's private key:
MY_KEYSTORE_ALIAS = tsukika-public
MY_KEYSTORE_PASSWORD = theDawnJKSPass
MY_KEYSTORE_PATH = ./test-keys/tsukika.jks
MY_KEYSTORE_ALIAS_KEY_PASSWORD = theDawnJKSPass

# Compiler and flags
ANDROID_NDK_ROOT = android-ndk-r27c
ANDROID_NDK_CLANG_PATH := $(ANDROID_NDK_ROOT)/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android$(SDK)-clang

# Output binaries
SAVIOUR_OUTPUT = ./local_build/binaries/bootloopSaviour
AROMA_OUTPUT = ./local_build/binaries/aromaConfig

# Source files for each target
SAVIOUR_SRCS = ./src/include/tsukika.c ./src/include/tsukikautils.c

# Main source path
SAVIOUR_MAIN = ./src/bootloopSaviour/main.c
AROMA_MAIN = ./src/rom-installer/aroma/main.c

# Error logs path
ERR_LOG = ./local_build/logs/compilerErrors.log

# Default: Build both
all: bootloop_saviour aromaInstaller

# Checks if the android ndk compiler toolchain exists
check_compiler:
	@if [ ! -f "$(ANDROID_NDK_CLANG_PATH)" ]; then \
		echo "Error: Android clang is not found. Please install it."; \
		exit 1; \
	fi

# Checks if the android ndk compiler toolchain exists
checkJava:
	@if ! command -v java >/dev/null 2>&1; then \
		echo "Error: Java is not found. Please install it."; \
		exit 1; \
	fi

checkKey:
	@if [ -z "$(MY_KEYSTORE_ALIAS)" ]; then echo "MY_KEYSTORE_ALIAS is not set!"; exit 1; fi
	@if [ -z "$(MY_KEYSTORE_PASSWORD)" ]; then echo "MY_KEYSTORE_PASSWORD is not set!"; exit 1; fi
	@if [ -z "$(MY_KEYSTORE_PATH)" ]; then echo "MY_KEYSTORE_PATH is not set!"; exit 1; fi
	@if [ -z "$(MY_KEYSTORE_ALIAS_KEY_PASSWORD)" ]; then echo "MY_KEYSTORE_ALIAS_KEY_PASSWORD is not set!"; exit 1; fi

bootloop_saviour: check_compiler
	@rm -f $(ERR_LOG)
	@echo "Building bootloopSaviour..."
	@$(ANDROID_NDK_CLANG_PATH) -static -std=c23 -I./src/include $(SAVIOUR_SRCS) $(SAVIOUR_MAIN) -o $(SAVIOUR_OUTPUT) >$(ERR_LOG) 2>&1 && \
	echo "✅ Build successful: $(SAVIOUR_OUTPUT)" || echo "❌ Error: Compilation failed. Check $(ERR_LOG) for details.";

aromaInstaller: check_compiler
	@rm -f $(ERR_LOG)
	@echo "Building aromaInstaller..."
	@$(ANDROID_NDK_CLANG_PATH) -static -I./src/include $(AROMA_MAIN) -o $(AROMA_OUTPUT) >$(ERR_LOG) 2>&1 && \
	echo "✅ Build successful: $(AROMA_OUTPUT)" || echo "❌ Error: Compilation failed. Check $(ERR_LOG) for details.";

UN1CAUpdater: checkKey checkJava
	@bash -c '\
		source ./src/misc/build_scripts/util_functions.sh && \
		[ -z "$${OTA_MANIFEST_URL}" ] && abort "- OTA_MANIFEST_URL is not mentioned, check the command again." "MAKE" "NULL"; \
		[ -z "$${SkipSign}" ] && abort "- SkipSign is not mentioned, either set it to true to skip signing or false to sign." "MAKE" "NULL"; \
		console_print "Building UN1CA updater for Tsukika.."; \
		tar -C ./src/tsukika/packages/TsukikaUpdater/ -xf ./src/tsukika/packages/TsukikaUpdater/TsukikaUpdaterSmaliFiles.tar 2>/dev/null || abort "Failed to extract the tar file to build the package."; \
		for file in ./src/tsukika/packages/TsukikaUpdater/smali_classes15/com/mesalabs/ten/update/ota/ROMUpdate\$$LoadUpdateManifest.smali ./src/tsukika/packages/TsukikaUpdater/smali_classes16/com/mesalabs/ten/update/ota/utils/Constants.smali; do \
			sed -i "s|$(OLD_REFERENCE_URL)|$${OTA_MANIFEST_URL}|g" "$${file}" || abort "- Failed to change manifest provider in $$file" "MAKE" "NULL"; \
		done; \
		java -jar $(APKTOOL_JAR) build "./src/tsukika/packages/TsukikaUpdater/" &>>$(ERR_LOG) || abort "- Failed to build the application. Please check $(ERR_LOG) for the logs." "MAKE" "NULL"; \
		if [ "$${SkipSign}" = "true" ]; then \
			console_print "Skipping signing process..."; \
		else \
			console_print "Signing the application..."; \
			java -jar $(UBER_SIGNER_JAR) \
			--verbose \
			--apk ./src/tsukika/packages/TsukikaUpdater/dist/TsukikaUpdater.apk \
			--ks $(MY_KEYSTORE_PATH) \
			--ksAlias $(MY_KEYSTORE_ALIAS) \
			--ksPass $(MY_KEYSTORE_PASSWORD) \
			--ksKeyPass $(MY_KEYSTORE_ALIAS_KEY_PASSWORD) &>/dev/null; \
			[ -f "./src/tsukika/packages/TsukikaUpdater/dist/TsukikaUpdater-aligned-signed.apk" ] && console_print "Signed APK: ./src/tsukika/packages/TsukikaUpdater/dist/TsukikaUpdater-aligned-signed.apk"; \
		fi; \
		exit 0; \
	'

# Test bootloopSaviour
test_bootloopsaviour:
	@if [ -f "$(AROMA_OUTPUT)" ]; then \
		if "$(AROMA_OUTPUT)" --test >/dev/null 2>&1; then \
			echo "✅ Test passed: $(AROMA_OUTPUT) works as expected!"; \
		else \
			echo "❌ Test failed: $(AROMA_OUTPUT) may not be compatible with this system."; \
			echo "    Possible reasons:"; \
			echo "      - Running on a non-ARM machine"; \
			echo "      - Syntax Errors in the code (or) Build Failure"; \
		fi; \
	else \
		echo "❌ Error: $(AROMA_OUTPUT) not found. Building it..."; \
		$(MAKE) bootloop_saviour && $(MAKE) test_bootloopsaviour; \
	fi

# Test aromaInstaller
test_aromaInstaller:
	@if [ -f "$(SAVIOUR_OUTPUT)" ]; then \
		if "$(SAVIOUR_OUTPUT)" --test >/dev/null 2>&1; then \
			echo "✅ Test passed: $(SAVIOUR_OUTPUT) works as expected!"; \
		else \
			echo "❌ Test failed: $(SAVIOUR_OUTPUT) may not be compatible with this system."; \
			echo "    Possible reasons:"; \
			echo "      - Running on a non-ARM machine"; \
			echo "      - Syntax Errors in the code (or) Build Failure"; \
		fi; \
	else \
		echo "❌ Error: $(SAVIOUR_OUTPUT) not found. Building it..."; \
		$(MAKE) aromaInstaller && $(MAKE) test_aromaInstaller; \
	fi

# help menu:
help:
	@echo ""
	@echo "Usage:"
	@echo "  make <target> [VARIABLE=value]"
	@echo ""
	@echo "C Build Targets (requires SDK=<version>):"
	@echo "  all                       Build all components (saviour, aromaInstaller)"
	@echo "  bootloop_saviour          Build bootloopSaviour"
	@echo "  aromaInstaller            Build aromaInstaller"
	@echo ""
	@echo "C Test Targets (requires SDK=<version>):"
	@echo "  test                      Test all C buildable programs"
	@echo "  test_bootloopsaviour      Test bootloopSaviour"
	@echo "  test_aromaInstaller       Test aromaInstaller"
	@echo ""
	@echo "General Targets:"
	@echo "  OTA_MANIFEST_URL=<url> SkipSign=true|false UN1CAUpdater"
	@echo "                           Build UN1CA Updater with the provided OTA manifest URL"
	@echo "  clean                    Clean up build artifacts"
	@echo "  help                     Show this help message"
	@echo ""

# Build and test everything
test: test_bootloopsaviour

# Clean up
clean:
	@rm -f $(SAVIOUR_OUTPUT) $(AROMA_OUTPUT) $(ERR_LOG) ./src/tsukika/packages/TsukikaUpdater/dist/ ./src/tsukika/packages/TsukikaUpdater/original/ ./src/tsukika/packages/TsukikaUpdater/build/

.PHONY: all bootloop_saviour aromaInstaller UN1CAUpdater test_bootloopsaviour test_aromaInstaller check_compiler test clean help