# Reverse Engineering av Android-apper

## Oppsett

Installer [Android Studio](https://developer.android.com/studio/)

Start Android Studio og velg Tools -> SDK Manager i toppmenyen

Under SDK Platforms velger du Android 12L

Under SDK Tools velger du:

 - Android SDK Build-Tools
 - Android SDK Command-line Tools
 - Android Emulator
 - Android SDK Platform-Tools

Trykk Apply

Legg inn følgende i shell-et sin konfigurasjonsfil (.zshrc, .bash-profile e.l.) for å tilgjengeliggjøre Android-verktøyene i kommandolinja:

```
export ANDROID_HOME=/Users/$(whoami)/Library/Android/sdk
export PATH=${PATH}:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin/:$ANDROID_HOME/build-tools/$(ls | tail -n 1 )/

```

Verifiser at du har zipalign og apksigner tilgjenglig i terminalen ved å kjøre `zipalign -h` og `apksigner -h`.

Sjekk at du har installert openssl ved å kjøre `openssl version`. Hvis ikke kan du installere via `brew install openssl`.

Installer apktool og jadx via `brew install apktool jadx`.
