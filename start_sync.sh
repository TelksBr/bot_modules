#!/bin/bash

if [[ -e "/root/sync_users.js" ]]; then
    rm -r sync_users.js  # Corrigido o nome do arquivo a ser removido.
fi

TOKEN="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"  # Substitua com o seu token de acesso pessoal

# Use as aspas simples para evitar problemas com caracteres especiais no URL
URL='https://raw.githubusercontent.com/TelksBr/bot_modules/main/sync_users.js'

# Use o comando wget com o cabeçalho de autorização e redirecione a saída para o arquivo sync_users.js
wget --header="Authorization: token $TOKEN" -O sync_users.js "$URL"

