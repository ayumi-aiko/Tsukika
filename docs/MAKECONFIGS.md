![tsukika](https://github.com/ayumi-aiko/banners/blob/main/explore00.png?raw=true)

# Tsukika (月華) | Build Configuration Variables

> **Important**: Please note that while everything works, some configurations might cause issues. Some of these configs can lead to a bootloop.

---

## Set the Extracted Directory Variables

Please provide the paths for each extracted partition:

- **SYSTEM_DIR**
- **SYSTEM_EXT_DIR**
- **VENDOR_DIR**
- **PRODUCT_DIR**
- **OPTICS_DIR**

> **Note:** You usually don't need to fill these variables if you're building Tsukika using a full firmware package, especially one downloaded from [samfw.com](https://samfw.com) or by using a firmware link via the builder script as an argument.

---

## Debugging

- **TARGET_BUILD_IS_FOR_DEBUGGING**: Enables verbose logging for debugging, which impacts performance.

---

## Security

- **TARGET_REMOVE_NONE_SECURITY_OPTION**: Disables the "None" option for lock screen security.
- **TARGET_REMOVE_SWIPE_SECURITY_OPTION**: Disables the swipe-to-unlock option.

---

## Bloatware & Features

- **TARGET_REMOVE_USELESS_VENDOR_STUFFS**: Removes bloat from the vendor partition.
- **TARGET_REMOVE_USELESS_SAMSUNG_APPLICATIONS_STUFFS**: Removes unnecessary Samsung apps (note: Android 9 is not fully supported).
- **TARGET_ADD_EXTRA_ANIMATION_SCALES**: Adds extra animation scales for customization.
- **TARGET_FLOATING_FEATURE_ENABLE_BLUR_EFFECTS**: Enables live blur effects for aesthetics. Please note that this impacts battery life and performance.
- **TARGET_FLOATING_FEATURE_ENABLE_ULTRA_POWER_SAVING**: Enables ultra power saving. This feature is generally unnecessary, but you can enable it if you want.
- **TARGET_FLOATING_FEATURE_DISABLE_SMART_SWITCH**: Disables Smart Switch during setup.
- **TARGET_INCLUDE_SAFETYCORESTUB**: Safetycore stub app made by me, include this if you really want to, <a href="https://www.reddit.com/r/technology/comments/1iy19yt/a_new_android_feature_is_scanning_your_photos_for/">learn about it from here.</a> This app is made by <a href="https://github.com/daboynb">@daboynb</a>

---

## Special Features

- **TARGET_FLOATING_FEATURE_ENABLE_ENHANCED_PROCESSING**: Attempts to boost performance at the cost of increased heat and reduced battery life.
- **TARGET_INCLUDE_UNLIMITED_BACKUP**: Enables unlimited photo backup in a specific app.
- **TARGET_INCLUDE_SAMSUNG_THEMING_MODULES**: Installs patched Samsung Good Lock modules.
- **TARGET_FLOATING_FEATURE_INCLUDE_SPOTIFY_AS_ALARM**: Includes Spotify as an option for alarm tones.
- **TARGET_FLOATING_FEATURE_INCLUDE_EASY_MODE**: Enables Easy Mode, which provides larger icons and is designed for users with visual difficulties.
- **TARGET_FLOATING_FEATURE_INCLUDE_CLOCK_LIVE_ICON**: Enables a live clock icon in the launcher. Disable this if you prefer.
- **TARGET_FLOATING_FEATURE_ENABLE_EXTRA_SCREEN_MODES**: Requires proper or minimum mdNIE support in the ROM and possibly the device for proper functionality.
- **TARGET_FLOATING_FEATURE_ENABLE_VOICE_MEMO_ON_NOTES**: Enables the voice memo feature in the Notes app. Only supported on UI7.
- **TARGET_BUILD_ENABLE_SEARCLE**: Enables Searcle (Circle to search) feature. OneUI 6 and Above.
- **TARGET_BUILD_ADD_NETWORK_SPEED_WIDGET** Brings back network speed widget in status bar.

---

## Audio & Display

- **TARGET_FLOATING_FEATURE_SUPPORTS_DOLBY_IN_GAMES**: Enables Dolby audio in games (only if supported and if the hardware is capable).

---

## Additional Customization

- **TARGET_FLOATING_FEATURE_SUPPORTS_DOLBY_IN_GAMES**
- **TARGET_FLOATING_FEATURE_LAUNCHER_CONFIG_ANIMATION_TYPE**: Adjusts launcher animation for different performance tiers (LowEnd, LowestEnd, LowEndFast, Mass, HighEnd, CHNHighEND, HighEnd_Tablet).
- **CUSTOM_WALLPAPER_RES_JSON_GENERATOR**: Adds multiple wallpapers easily.
- **TARGET_BUILD_ADD_MOBILE_DATA_TOGGLE_IN_POWER_MENU**: Adds a mobile data toggle to the power menu.
- **TARGET_BUILD_FORCE_FIVE_BAR_NETICON**: Forces the network icon to display 5 bars.
- **TARGET_BUILD_ADD_CALL_RECORDING_IN_SAMSUNG_DIALER**: Enables call recording in the Samsung Dialer app. Note: You are responsible for complying with local laws.
- **TARGET_BUILD_FORCE_SYSTEM_TO_NOT_CLOSE_CAMERA_WHILE_CALLING**: Forces the system to not close the camera app while calling
- **TARGET_BUILD_FORCE_SYSTEM_TO_PLAY_MUSIC_WHILE_RECORDING**: Forces the system to play song(s) / music(s) while recording a video
- **TARGET_BUILD_DISABLE_WIFI_CALLING**: Disables wifi calling if it set to true.
- **TARGET_BUILD_SKIP_SETUP_JUNKS**: Force skips junks like wifi setup and etc in the setup wizard
- **BLOCK_NOTIFICATION_SOUNDS_DURING_PLAYBACK**: Disables annoying sounds while calls.
- **TARGET_BUILD_FORCE_SYSTEM_TO_PLAY_SMTH_WHILE_CALL**: Forces the Media Player to play a video during an call.
- **FORCE_ENABLE_POP_UP_PLAYER_ON_SVP**: Force enables Popup player on Samsung Video Player
- **TARGET_BUILD_FORCE_DISABLE_SETUP_WIZARD**: For trusted use cases only. Disables setup wizard.
- **TARGET_FLOATING_FEATURE_INCLUDE_GAMELAUNCHER_IN_THE_HOMESCREEN**
- **TARGET_FLOATING_FEATURE_BATTERY_SUPPORT_BSOH_SETTINGS**: Adds battery health settings like iPhone. Credit: [UN1CA](https://github.com/salvogiangri/UN1CA)
- **BRINGUP_CN_SMARTMANAGER_DEVICE**: Adds Chinese Smart Manager. Credit: [@saadelasfur](https://github.com/saadelasfur)
- **TARGET_BUILD_ADD_SCREENRESOLUTION_CHANGER**: Adds resolution switcher. Credit: [@Yanndroid](https://github.com/Yanndroid)
- **TARGET_BUILD_CUSTOMIZE_SETUP_WIZARD_STRINGS**: Changes outro and intro strings on the setup wizard via an overlay.
- **TARGET_BUILD_SETUP_WIZARD_INTRO_TEXT**: This variable changes the beginning / intro message on the setup wizard
- **TARGET_BUILD_SETUP_WIZARD_OUTRO_TEXT**: This variable changes the beginning / intro message on the setup wizard
> ⚠️ **WARNING:** Set `TARGET_BUILD_CUSTOMIZE_SETUP_WIZARD_STRINGS` to true in order to change the intro/outro message.

---

## Language & Locale

- **SWITCH_DEFAULT_LANGUAGE_ON_PRODUCT_BUILD**: Sets the default language and region on first boot.
  - Requires:
    - **NEW_DEFAULT_LANGUAGE_ON_PRODUCT** (ex: en, which is English)
    - **NEW_DEFAULT_LANGUAGE_COUNTRY_ON_PRODUCT** (ex: US, which is United States)
    - From the example, en_US means that it's going set the language as english that is used widely in United States.

---

## Miscellaneous

- **TARGET_DISABLE_SAMSUNG_ASKS_SIGNATURE_VERFICATION**: Disables Samsung ASKS signature check.
- **TARGET_ADD_ROUNDED_CORNERS_TO_THE_PIP_WINDOWS**: [Adds rounded corners to the PiP window.](https://github.com/ayumi-aiko/banners/blob/main/rounded_corners_tsukika_ex.png)
- **TARGET_BUILD_FIX_ANDROID_SYSTEM_DEVICE_WARNING**: Removes Android system warning.

---

## Advanced (optional)

- **TARGET_INCLUDE_TSUKIKA_OEMCRYPTO_DISABLER**: Removes DRM files. Downgrades Widevine to L3.
- **MY_KEYSTORE_ALIAS**: Your Keystore Alias.
- **MY_KEYSTORE_ALIAS_KEY_PASSWORD**: Your keystore alias password.
- **MY_KEYSTORE_PASSWORD**: Your Keystore password.
- **MY_KEYSTORE_PATH**: Path to Keystore.
- **TARGET_REMOVE_SMARTSWITCH_DAEMON** Removes a smart switch listener port from the init shell.
- **TARGET_BUILD_REMOVE_SYSTEM_LOGGING** Removes unnecessary logging stuffs, don't disable logs on public builds.
- **TARGET_BUILD_BRING_NEWGEN_ASSISTANT**: For android 11 and below, brings assistant 2.0
- **TARGET_BUILD_MAKE_DEODEXED_ROM**: Deodexes the ROM. [What is ODEX and DEODEX?](https://xdaforums.com/t/complete-guide-what-is-odex-and-deodex-rom.2200349)
- **TARGET_DISABLE_FILE_BASED_ENCRYPTION**: Disables FBE on internal storage.

---