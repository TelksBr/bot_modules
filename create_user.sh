#!/bin/bash
usuario=$1
senha=$2
dias=$3
limite=$4
uuid=$5

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
        if $(node validate.js $index $uuid) === "true"; then
            echo "V2RAY JA EXISTE NO INDEX $index.";
            ((index++))
        else
            new_client='{"id": "'$uuid'", "alterId": 0, "email": "'$usuario@gmail.com'"}'
            tmpfile=$(mktemp)
            jq --argjson newclient "$new_client" --argjson index "$index" '.inbounds[$index].settings.clients += [$newclient]' "$config_file" > "$tmpfile" && mv "$tmpfile" "$config_file"
            echo "V2RAY CRIADO COM SUCESSO.";
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

if [[ "$uuid" == "" ]]; then
    create
else
    create_at_v2
fi
