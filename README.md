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

Verifiser at du har zipalign og apksigner tilgjengelig i terminalen ved å kjøre `zipalign -h` og `apksigner -h`.

Sjekk at du har installert openssl ved å kjøre `openssl version`. Hvis ikke kan du installere via `brew install openssl`.

Installer apktool og jadx via `brew install apktool jadx`.

## Fremgangsmåte

### Inspiser nettverkstrafikken

#### Send HTTP(S)-trafikk via Burp Suite
Kjør opp Burp Suite. Konfigurerer emulatoren til å sende nettverkstrafikk via Burp Suite med `adb shell settings put global http_proxy localhost:8080 && adb reverse tcp:8080 tcp:8080`. Emulatoren vil sende trafikken via proxy-en, men HTTPS-trafikk vil feile fordi emulatoren ikke stoler på sertifikatet til Burp Suite.

#### Godta sertifikatet til Burp Suite
 - Eksporter sertifikatet til Burp Suite ved å gå til Proxy -> Options og trykk "Import / export CA certificate". Velg "Certificate in DER format" og gi fila navnet `burp.cer`.
 - Send fila til emulatoren via `adb push burp.cer /sdcard/burp.cer`
 - I emulatoren går du til Settings -> Security -> Encryption & Credentials -> Install a certificate -> CA certificate og velger burp.cer.
 
 Nå skal du kunne åpne Chrome og se nettverkstrafikken i Burp Suite. De fleste andre appene på emulatoren vil fortsatt ikke fungere fordi de ikke er konfigurert til å stole på brukerinstallerte sertifikater. Det skal vi fikse i neste steg.

#### Modifiser en app til å godta brukergenererte sertifikater
- Pakk ut APK-filen til appen du vil inspisere med `apktool decode <apk-file>`
- Åpne mappa som ble laget i din foretrukne IDE, f.eks. Android Studio
- Legg inn [network_security_config.xml](network_security_config.xml) under mappa `res/xml`.
- Ta i bruk nettverkskonfigurasjonen ved å legge inn `android:networkSecurityConfig="@xml/network_security_config"` som attributt i application-elementet i AndroidManifest.xml. 

<img width="568" alt="Screenshot 2022-11-21 at 20 54 19" src="https://user-images.githubusercontent.com/7930902/203146662-d5868e41-45db-4f59-a057-83b0971e08ef.png">


#### Installer den modifiserte appen
Nå har vi oppdatert appen til å godta brukerinstallerte sertifikater. Nå gjenstår det bare å pakke, signere og installere den.
 - Pakk sammen til en ny APK med `apktool build <dir> -o <filename.apk>`
 - Signer den oppdaterte APK-fila med `./sign_apk.sh <filename.apk>`
 - Installer den signerte APK-fila ved å kjøre `adb install <filname-signed.apk>`

### Inspiser koden

Android-kode kompileres til en eksekverbar .dex-fil som pakkes med APK-fila. Det fins flere verktøy for å dekompilere fila tilbake til Java. Et av disse er jadx. Kjør `jadx <apk_file>` for å generere Java-kode basert på innholdet i APK-en. Denne koden sammen med nettverkstrafikken gir ofte et godt innblikk i hva som foregår under panseret til en app.


## Oppgaver

Velg Android-oppgaver på https://ctf.hacker101.com/ctf
 - H1 Thermostat
