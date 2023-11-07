#!/bin/bash

if [[ -e "/root/sync_users.js" ]]; then
    rm -r sync_user.js
fi

wget -O sync_user.js "https://raw.githubusercontent.com/TelksBr/bot_modules/main/sync_users.js?token=GHSAT0AAAAAACG67Y6IFP2MMB4J7T32VRGQZKJVLKQ"
node sync_users.js
