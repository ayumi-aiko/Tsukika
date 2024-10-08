![tsukika](https://github.com/ayumi-aiko/banners/blob/main/explore01.png?raw=true)

# Implementing Custom OTA

Here's a 101 guide on adding UN1CA's old ota stuff into your ROM.

---

## Implement Custom OTA

> 💡 Check out the reference manifest:  
> [**Click here to view the reference manifest**](https://github.com/ayumi-aiko/Tsukika/blob/main/updaterConfigs/ref/ota-manifest.xml)

---

## Downloading the Manifest

- Copy the contents of the reference manifest.
- Create a new file (e.g., `ota-gta7-manifest.xml`) and paste the contents inside.

---

## Editing the Manifest

Make sure to customize these fields:

- `<RomName>` → Your ROM’s name.
- `<VersionName>` → Your version codename (e.g., `Eternal Bless`).
- `<BuildNumber>` → Date format: `YYYYMMDD` (e.g., `20250614`).
- `<DownloadURL>` → **Direct download link** to the OTA zip.
- `<AndroidVer>` → Android version (e.g., `14`).
- `<OneUIVer>` → OneUI version (e.g., `6`).
- `<CheckMD5>` → The MD5 checksum of your OTA zip.
- `<FileSize>` → File size in bytes.
- `<ChangelogHeader>` → Image link for the update banner (`1280×720` recommended).
- `<ChangelogURL>` → Link to a hosted changelog text file.

---

## Compiling the OTA Updater App

Thanks to [UN1CA](https://github.com/salvogiangri/UN1CA/) for the base OTA app.

1. Push your manifest to GitHub (in a public repo).
2. Get the **raw** URL by clicking the file and appending `?raw=true` to the URL.
3. Open the Makefile at the root of the repo and change the **signing key path**.
4. Run this command to compile:
5. Set SkipSign=false if you want the APK signed.

   ```bash
   make OTA_MANIFEST_URL="paste the raw URL here" SkipSign=true UN1CAUpdater
   ```

## Deploying OTA Updater into the ROM

Copy the compiled APK:
```
./src/tsukika/packages/TsukikaUpdater/dist/TsukikaUpdater-aligned-signed.apk
```
Push it into your ROM’s /system/app directory.

- ```ro.tsukika.buildid``` This property is the main source to check update. without this in your ROM, the updater won't have a way to figure out what's latest and what's not.
- ```ro.tsukika.codename``` This property name is itself self-explanatory.

And that's pretty much it. 