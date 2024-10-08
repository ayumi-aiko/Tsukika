#!/usr/bin/env bash
#
# Copyright (C) 2025 愛子あゆみ <ayumi.aiko@outlook.com> & BrotherBoard <82703813+brotherboard@users.noreply.github.com>
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
set -euo pipefail

# Prepare output name and hex rate
OUTPUT="dtbo.${BUILD_TARGET_MAX_OVERCLOCKABLE_REFRESH_RATE}Hz"
BUILD_TARGET_MAX_OVERCLOCKABLE_REFRESH_RATE__=$(printf '%X' "$BUILD_TARGET_MAX_OVERCLOCKABLE_REFRESH_RATE")
mkdir -p dts dtb

# Step into working dir
cd ./local_build || abort "Failed to enter local_build directory" "refresh-rate-modifier"
rm -rf "$OUTPUT"

# Extract dtbo image
logInterpreter "Trying to extract dtbo image" \
  "./imjtool ${BUILD_TARGET_DTBO_IMAGE_PATH} extract" || \
  abort "Failed to extract the dtbo image" "refresh-rate-modifier"

mv extracted "$OUTPUT"
cd "$OUTPUT" || abort "Failed to enter extracted folder" "refresh-rate-modifier"

# Validate config presence
[[ ! -f "../config.cfg" || ! -f "${BUILD_TARGET_DEVICE_DTBO_CONFIG_PATH}" ]] && \
  abort "Device-specific configuration file is not found" "refresh-rate-modifier"

# Use correct config file
cp "${BUILD_TARGET_DEVICE_DTBO_CONFIG_PATH}" ./config.cfg

# Convert DTB ➝ DTS
logInterpreter "Trying to convert dtb to dts" \
  'for f in DeviceTree*.dtb; do dtc -I dtb -O dts -o "${f%.dtb}.dts" "$f" || abort "Failed to convert $f into dts." "refresh-rate-modifier"; done'

# Remove dtb files post-conversion
rm -f *.dtb

# Patch DTS for new refresh rate
debugPrint "refresh-rate-modifier(): Overriding rate matches to ${BUILD_TARGET_MAX_OVERCLOCKABLE_REFRESH_RATE} (${BUILD_TARGET_MAX_OVERCLOCKABLE_REFRESH_RATE__})"

find . -type f -exec sed -i \
  -e "s/timing,refresh = <0x..>/timing,refresh = <0x${BUILD_TARGET_MAX_OVERCLOCKABLE_REFRESH_RATE__}>/g" \
  -e "s/active_fps = <0x..>/active_fps = <0x${BUILD_TARGET_MAX_OVERCLOCKABLE_REFRESH_RATE__}>/g" \
  -e "s/display_mode = <0x438 0x968 0x.. 0x00 0x00 0x00 0x00/display_mode = <0x438 0x968 0x${BUILD_TARGET_MAX_OVERCLOCKABLE_REFRESH_RATE__} 0x00 0x00 0x00 0x00/g" \
  {} +

# Convert DTS ➝ DTB
logInterpreter "Trying to convert dts to dtb" \
  'for f in DeviceTree*.dts; do dtc -I dts -O dtb -o "${f%.dts}.dtb" "$f" || abort "Failed to convert $f into dtb." "refresh-rate-modifier"; done'

mv *.dts ../dts/

# Rebuild final dtbo image
FINAL_IMG="dtbo.${BUILD_TARGET_MAX_OVERCLOCKABLE_REFRESH_RATE}hz.img"
rm -f "../$FINAL_IMG"

logInterpreter "Making dtbo image..." \
  "mkdtimg cfg_create $FINAL_IMG ./config.cfg -d ./" || \
  abort "This dtbo build failed" "DTHZ_BUILD_FAILED"

mv "$FINAL_IMG" ..
mv *.dtb ../dtb/

console_print "DTBO image can be found at: $(realpath ../$FINAL_IMG)"
cd ../../