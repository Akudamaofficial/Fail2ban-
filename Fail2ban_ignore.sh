#!/bin/bash
IP=$1
CONFIG="/etc/fail2ban/jail.local"

if [ -z "$IP" ]; then
    echo "Использование: $0 <IP-адрес>"
    exit 1
fi

echo "=== Добавление $IP в ignoreip ==="
if grep -q "^ignoreip" "$CONFIG"; then
    sudo sed -i "s/^ignoreip = .*/& $IP/" "$CONFIG"
else
    echo "ignoreip = 127.0.0.1/8 $IP" | sudo tee -a "$CONFIG" > /dev/null
fi

echo "Не забудьте перезапустить fail2ban: sudo systemctl restart fail2ban"