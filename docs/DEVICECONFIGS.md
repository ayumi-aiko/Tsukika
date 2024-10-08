![tsukika](https://github.com/ayumi-aiko/banners/blob/main/explore00.png?raw=true)

# Tsukika (月華) | Build Configuration Variables

## Device-Specific Configuration (`genericTargetProperties` / `buildTargetProperties`)

### Common Options

| Variable | Description |
|---------|-------------|
| `BUILD_TARGET_INCLUDE_FASTBOOTD_PATCH` | Adds fastbootd support to the stock recovery. Make sure `RECOVERY_IMAGE_PATH` is set correctly in `src/makeconfigs.prop`. |
| `BUILD_TARGET_DISABLE_KNOX_PROPERTIES` | For Android <= 11, use at your own risk as it disables Knox via untested properties. |
| `BUILD_TARGET_BOOT_ANIMATION_FPS` | Sets the frame rate for boot animations (must be ≤ 60). |
| `BUILD_TARGET_SHUTDOWN_ANIMATION_FPS` | Sets the frame rate for shutdown animations (must be ≤ 60). |
| `BUILD_TARGET_DEFAULT_SCREEN_REFRESH_RATE` | Sets the default screen refresh rate (e.g., 60Hz). |
| `BUILD_TARGET_HAS_HIGH_REFRESH_RATE_MODES` | Set to `true` to enable changing the default refresh rate. |
| `BUILD_TARGET_USES_DYNAMIC_PARTITIONS` | Set to `true` if your device uses dynamic partitions. |
| `BUILD_TARGET_REQUIRES_BLUETOOTH_LIBRARY_PATCHES` | Applies Bluetooth library patches for specific devices. |

### For Supported Devices

| Variable | Description |
|---------|-------------|
| `BUILD_TARGET_REPLACE_REQUIRED_PROPERTIES` | Replaces specific required properties that are provided by the maintainer, useful in certain scenarios. |

### Advanced

| Variable | Description |
|---------|-------------|
| `BUILD_TARGET_DISABLE_DISPLAY_REFRESH_RATE_OVERRIDE` | Prevents refresh rate override during media playback. |
| `BUILD_TARGET_DISABLE_DYNAMIC_RANGE_COMPRESSION` | Disables audio dynamic range compression. |
| `BUILD_TARGET_RECOVERY_IMAGE_PATH` | Patches stock recovery to enable fastbootd. Thanks to <a href="https://github.com/ravindu644">Ravindu Deshan</a> |

## Generative AI Feature Support

| Variable | Description |
|---------|-------------|
| `BUILD_TARGET_IS_CAPABLE_FOR_GENERATIVE_AI` | Enables AI support. Only use if the device is capable. |
| `BUILD_TARGET_SUPPORTS_GENERATIVE_AI_OBJECT_ERASER` | Enables Object Eraser (requires AI support). |
| `BUILD_TARGET_SUPPORTS_GENERATIVE_AI_REFLECTION_ERASER` | Enables Reflection Eraser (requires AI support). |
| `BUILD_TARGET_SUPPORTS_GENERATIVE_AI_UPSCALER` | Enables AI-based content upscaling (requires AI support). |

# Target Refresh Rate Overclock
> ⚠️ **WARNING:** Set `BUILD_TARGET_ENABLE_DISPLAY_OVERCLOCKING` to true in order to overclock your screen rate.
- **BUILD_TARGET_MAX_OVERCLOCKABLE_REFRESH_RATE**: Set the max overclockable rate of your device.
- **BUILD_TARGET_DTBO_IMAGE_PATH**: Set the path to the DTBO image
- **BUILD_TARGET_DEVICE_DTBO_CONFIG_PATH**: Put the path to the config file to overclock the display.

## Vulkan SystemUI Rendering (Experimental)

### Required Properties

```ini
BUILD_TARGET_ENABLE_VULKAN_UI_RENDERING=true
BUILD_TARGET_GPU_VULKAN_VERSION=<hex value from below, paste the correct one according to your device spec>
```

### Vulkan Version Table

| Vulkan Version     | Hex Value     |
|--------------------|---------------|
| 1.1                | `0x00401000`  |
| 1.1.1              | `0x00401001`  |
| 1.2 / 1.2.0        | `0x00402000`  |
| 1.2.162            | `0x004020A2`  |
| 1.3                | `0x00403000`  |
| 1.3 / 1.3.0        | `0x00403000`  |

**Note:** Vulkan-based SystemUI rendering gave me bootloop in some ROMS.

And no need to fill `BUILD_TARGET_DTBO_IMAGE_PATH` and `BUILD_TARGET_RECOVERY_IMAGE_PATH` if you are building this rom by either:
    
> Passing a zip file as an argument

> Passing a firmware url as an argument