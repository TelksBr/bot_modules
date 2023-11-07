#!/bin/bash
if [[ -e "/root/sync_users.js" ]]; then
    rm -r sync_users.js* 
fi

TOKEN="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"

URL="https://raw.githubusercontent.com/TelksBr/bot_modules/main/sync_users.js"

wget --header="Authorization: token $TOKEN" -O sync_users.js "$URL"

node sync_users.js


# Verifique se o download foi bem-sucedido
if [[ -e "sync_users.js" ]]; then
    node sync_users.js
else
    echo "Falha ao baixar o arquivo sync_users.js"
fi
