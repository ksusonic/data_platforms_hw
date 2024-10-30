#!/bin/bash

# Запускать с Jump Node. Настраивает окружение для практических заданий.

set -e


if [[ $USER != "team" ]]; then
    echo "Ожидается запуск от пользователя team"
    exit 1
fi

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
    mkdir -p ~/.ssh
    ssh-keygen -b 2048 -t rsa -q -N "" -f ~/.ssh/id_rsa
fi

if [[ ! -f /etc/sudoers.d/$USER ]]; then
    echo "$PASSWORD" | sudo -S bash -c "echo '$USER ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/$USER"
    echo "Пользователь $USER добавлен в список sudo-пользователей"
fi

# Можно добавить новую ноду
for node in $NAMENODE_IP $DATANODE_0_IP $DATANODE_1_IP; do
    echo "Добавляю ssh-ключ на ноду $node ..."
    sshpass -p $PASSWORD ssh-copy-id $node

    echo "Выполняю добавление пользователя $USER в sudoers на ноду $node ..."

    sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no $node << EOF
        if [[ -f /etc/sudoers.d/$USER ]]; then
            echo "Пользователь $USER уже в списке sudo-пользователей"
        else
            echo "$PASSWORD" | sudo -S bash -c "echo '$USER ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/$USER"
            echo "Пользователь $USER добавлен в список sudo-пользователей"
        fi
EOF

done

echo "▗▄▄▄  ▗▄▖ ▗▖  ▗▖▗▄▄▄▖"
echo "▐▌  █▐▌ ▐▌▐▛▚▖▐▌▐▌   "
echo "▐▌  █▐▌ ▐▌▐▌ ▝▜▌▐▛▀▀▘"
echo "▐▙▄▄▀▝▚▄▞▘▐▌  ▐▌▐▙▄▄▖"
echo ""
