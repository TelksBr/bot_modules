#!/bin/bash

if [[ -e "/root/sync_users.js" ]]; then
    rm -r sync_user.js
fi

wget https://raw.githubusercontent.com/TelksBr/bot_modules/main/sync_users.js
node sync_users.js