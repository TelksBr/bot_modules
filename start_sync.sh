#!/bin/bash
if [[ -e "/root/sync_users.js" ]]; then
    rm -r sync_users.js 
fi


# Use o comando wget com o cabeçalho de autorização e redirecione a saída para o arquivo sync_users.js
wget -O sync_users.js https://raw.githubusercontent.com/TelksBr/bot_modules/main/sync_users.js


node sync_users.js


