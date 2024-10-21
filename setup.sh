#!/bin/bash

# Запускать с Jump Node. Настраивает окружение для практических заданий.

set -e

if [[ ! -f .env ]]; then
    cp .env.example .env
    echo "Создал .env файл. Пожалуйста, заполните данные в нем и перезапустите скрипт."
    exit 1
fi

source .env

if [[ ! $(which sshpass) ]]; then
    echo "Устанавливаю sshpass..."
    echo $PASSWORD | sudo -S apt-get update && sudo apt-get install sshpass
fi

if [[ ! $(which ansible) ]]; then
    echo "Устанавливаю ansible..."
    sshpass -p $PASSWORD sudo apt-get install -y ansible
fi

if ! [[ -f ~/.ssh/id_rsa ]]; then
    echo "Генерирую ssh-ключ..."
    ssh-keygen -b 2048 -t rsa -q -N ""
fi

# Можно добавить новую namenode/datanode
for node in $NAMENODE_IP $DATANODE_0_IP $DATANODE_1_IP; do
    echo "Добавляю ssh-ключ на ноду $node ..."
    sshpass -p $PASSWORD ssh-copy-id $SCRIPT_USER@$node
done

echo "▗▄▄▄  ▗▄▖ ▗▖  ▗▖▗▄▄▄▖"
echo "▐▌  █▐▌ ▐▌▐▛▚▖▐▌▐▌   "
echo "▐▌  █▐▌ ▐▌▐▌ ▝▜▌▐▛▀▀▘"
echo "▐▙▄▄▀▝▚▄▞▘▐▌  ▐▌▐▙▄▄▖"
echo ""
