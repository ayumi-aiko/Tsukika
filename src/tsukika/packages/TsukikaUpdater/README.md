![Banner](https://github.com/pachdomenic/TukiRom-OTA/blob/m31/img/icon.png?raw=true)
=====

This repo contains 십 Update app.

Please notice the app needs external edits to the following files in order to enable the "parentIsDeviceDefault" bool in frameworks (this one enables some little UI elements like ToolbarPopup & EdgeEffect):

> reference xmls: /res/values/styles.xml
> /res/values-v25/styles.xml

Supported Languages:

> Tamil (தமிழ்),
> English,
> Malayalam (മലയാളം)

Please do note that English is fully supported in the UI but not other languages
Translations might not be accurate, if you can fix it, do a pr.

## To compile (Java should be present):
- Edit the makefile keystore variables to sign the package with your own key.
- Use SkipSign=false if you wanna skip signing the package, otherwise set it to true if you want to sign it.
```bash
cd Tsukika
make OTA_MANIFEST_URL=<your own ota manifest url> SkipSign=true|false UN1CAUpdater
```