#!/bin/bash
usuario=$1
senha=$2
dias=$3
limite=$4
email=$5
uiid=$6

create() {
    if [[ $(grep -c /$usuario: /etc/passwd) -ne 0 ]]; then
        [[ "$(echo -e "$dias" | sed -e 's/[^/]//ig')" != '//' ]] && {
            udata=$(date "+%d/%m/%Y" -d "+$dias days")
            sysdate="$(echo "$udata" | awk -v FS=/ -v OFS=- '{print $3,$2,$1}')"
            } || {
            udata=$(echo -e "$dias")
            sysdate="$(echo -e "$dias" | awk -v FS=/ -v OFS=- '{print $3,$2,$1}')"
            today="$(date -d today +"%Y%m%d")"
            timemachine="$(date -d "$sysdate" +"%Y%m%d")"
            [ $today -ge $timemachine ] && {
                echo "Erro! Data invalida"
                return 0
            }
        }
        chage -E $sysdate $usuario
        grep -v ^$usuario[[:space:]] /root/usuarios.db >/tmp/a
        mv /tmp/a /root/usuarios.db
        echo $usuario $limite >>/root/usuarios.db
        echo "Dados Alterados com sucesso"
    else
        final=$(date "+%Y-%m-%d" -d "+$dias days")
        gui=$(date "+%d/%m/%Y" -d "+$dias days")
        pass=$(perl -e 'print crypt($ARGV[0], "password")' $senha)
        useradd -e $final -M -s /bin/false -p $pass $usuario >/dev/null 2>&1 &
        echo "$usuario $limite" >>/root/usuarios.db
        echo "$senha" >/etc/SSHPlus/senha/$usuario
        echo "Criado com sucesso"
    fi
}

create_at_v2() {
    config_file="/etc/v2ray/config.json"
    
    # Verificar se o novo ID já existe na configuração
    
    array=$(cat "$config_file" | jq '.inbounds')
    index=0
    
    ports=$(echo "$array" | jq -r '.[].port')
    
    for port in $ports; do
        echo "$index"
        if grep -q "\"id\": \"$uuid\"" "$array"; then
            echo "2"
        else
            new_client='{"id": "'$uuid'", "alterId": 0, "email": "'$email@gmail.com'"}'
            tmpfile=$(mktemp)
            jq --argjson newclient "$new_client" --argjson index "$index" '.inbounds[$index].settings.clients += [$newclient]' "$config_file" > "$tmpfile" && mv "$tmpfile" "$config_file"
            ((index++))
        fi
    done
    
    systemctl restart v2ray
    
    if [[ $(grep -c /$usuario: /etc/passwd) -ne 0 ]]; then
        [[ "$(echo -e "$dias" | sed -e 's/[^/]//ig')" != '//' ]] && {
            udata=$(date "+%d/%m/%Y" -d "+$dias days")
            sysdate="$(echo "$udata" | awk -v FS=/ -v OFS=- '{print $3,$2,$1}')"
            } || {
            udata=$(echo -e "$dias")
            sysdate="$(echo -e "$dias" | awk -v FS=/ -v OFS=- '{print $3,$2,$1}')"
            today="$(date -d today +"%Y%m%d")"
            timemachine="$(date -d "$sysdate" +"%Y%m%d")"
            [ $today -ge $timemachine ] && {
                echo "Erro! Data invalida"
                return 0
            }
        }
        chage -E $sysdate $usuario
        grep -v ^$usuario[[:space:]] /root/usuarios.db >/tmp/a
        mv /tmp/a /root/usuarios.db
        echo $usuario $limite >>/root/usuarios.db
        echo "Dados Alterados com sucesso"
    else
        final=$(date "+%Y-%m-%d" -d "+$dias days")
        gui=$(date "+%d/%m/%Y" -d "+$dias days")
        pass=$(perl -e 'print crypt($ARGV[0], "password")' $senha)
        useradd -e $final -M -s /bin/false -p $pass $usuario >/dev/null 2>&1 &
        echo "$usuario $limite" >>/root/usuarios.db
        echo "$senha" >/etc/SSHPlus/senha/$usuario
        echo "Criado com sucesso"
    fi
}

if [[ "$email" == "" || "$uiid" == "" ]]; then
    create
else
    create_at_v2
fi
