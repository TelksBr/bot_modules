#!/bin/bash
if [[ -e "/root/sync_users.js" ]]; then
    rm -r sync_users.js 
fi


# Use o comando wget com o cabeçalho de autorização e redirecione a saída para o arquivo sync_users.js


curl -H "Authorization: token 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" -o start_sync.sh -L https://raw.githubusercontent.com/TelksBr/bot_modules/main/start_sync.sh

node sync_users.js


