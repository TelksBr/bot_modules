#!/bin/bash

if [[ -e "/root/sync_users.js" ]]; then
    rm -r sync_user.js
fi

wget -O sync_user.js "https://raw.githubusercontent.com/TelksBr/bot_modules/main/sync_users.js?token=GHSAT0AAAAAACG67Y6IL2E4HWMNVNYTANIOZKJVE2A"
node sync_users.js
