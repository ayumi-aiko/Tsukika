![emergency_food](https://github.com/ayumi-aiko/banners/blob/main/notFound.png?raw=true)

# To compile (Android NDK should be present):
- Change these following variables according to the toolchain path: ANDROID_NDK_CLANG_PATH
- Don't forget to change it, else the program won't get compiled or will have any random issues.
```bash
cd Tsukika
make SDK=<sdk version here> bootloop_saviour
```

## What Does This Do?
- This init daemon disables all Magisk modules if the Zygote process has a different PID (process id) every 5 seconds
- Helpful for recovering from bootloops caused by unstable modules.