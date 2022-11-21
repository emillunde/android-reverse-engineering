#!/usr/bin/env bash

apk_name=$(echo $1 | sed "s/.apk//")

# create key and certificate
openssl genrsa -out key 1024
openssl pkcs8 -topk8 -in key -out key.pkcs8 -outform DER -nocrypt
openssl req -new -x509 -key key -out cert.pem -days 1 -nodes -subj '/CN=example.com'

# sign apk
zipalign 4 "${apk_name}.apk" "${apk_name}_za.apk"
apksigner sign --key key.pkcs8 --cert cert.pem --out "${apk_name}-signed.apk" "${apk_name}_za.apk"

#cleanup
rm key key.pkcs8 cert.pem "${apk_name}_za.apk"