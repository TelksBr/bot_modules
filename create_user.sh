#!/bin/bash

usuario=$1
senha=$2
dias=$3
limite=$4

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