#!/bin/bash
JAIL=${1:-sshd}
IP=$2

if [ -z "$IP" ]; then
    echo "Использование: $0 <jail_name> <IP>"
    echo "Пример: $0 sshd 192.168.1.100"
    exit 1
fi

echo "=== Разблокировка IP: $IP для джейла $JAIL ==="
sudo fail2ban-client set "$JAIL" unbanip "$IP"