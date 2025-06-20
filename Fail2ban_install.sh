#!/bin/bash

# Скрипт установки и настройки Fail2Ban для защиты от SSH брутфорса

# Проверяем, запущен ли скрипт от имени root
if [ "$(id -u)" != "0" ]; then
    echo "Этот скрипт нужно запускать от имени root!"
    exit 1
fi

# Обновление системы
echo "Обновление системы..."
apt update -y

# Установка Fail2Ban
echo "Установка Fail2Ban..."
apt install fail2ban -y

# Включение автозапуска сервиса при загрузке
echo "Включение автозапуска Fail2Ban..."
systemctl enable fail2ban

# Создание копии конфигурационного файла
echo "Создание копии конфигурационного файла..."
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Настройка параметров защиты
echo "Настройка параметров защиты..."
sed -i 's/^#ignoreip = 127.0.0.1/ignoreip = 127.0.0.1/g' /etc/fail2ban/jail.local
sed -i 's/^bantime = 10m/bantime = 9999999/g' /etc/fail2ban/jail.local
sed -i 's/^findtime = 600/findtime = 120/g' /etc/fail2ban/jail.local
sed -i 's/^maxretry = 5/maxretry = 3/g' /etc/fail2ban/jail.local

# Настройка секции для SSH
echo "Настройка параметров для SSH..."
sed -i '/\[sshd\]/,/^$/s/enabled = false/enabled = true/g' /etc/fail2ban/jail.local
sed -i '/\[sshd\]/,/^$/s/^filter =.*/filter = sshd/g' /etc/fail2ban/jail.local
sed -i '/\[sshd\]/,/^$/s/^action =.*/action = iptables-multiport\[name=SSH, port="ssh", protocol=tcp\]/g' /etc/fail2ban/jail.local
sed -i '/\[sshd\]/,/^$/s/^#banaction =.*/banaction = iptables-multiport/g' /etc/fail2ban/jail.local

# Настройка параметров бана
sed -i '/\[sshd\]/,/^$/s/^#maxretry =.*/maxretry = 3/g' /etc/fail2ban/jail.local
sed -i '/\[sshd\]/,/^$/s/^#findtime =.*/findtime = 120/g' /etc/fail2ban/jail.local
sed -i '/\[sshd\]/,/^$/s/^#bantime =.*/bantime = 999999/g' /etc/fail2ban/jail.local

# Перезапуск сервиса
echo "Перезапуск Fail2Ban..."
systemctl restart fail2ban

echo "Настройка Fail2Ban завершена!"
echo "Для просмотра статуса: fail2ban-client status"
