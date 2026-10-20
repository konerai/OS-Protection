#!/bin/bash
# Устранение уязвимостей CUPS: обновление, отключение cups-browsed, фаервол.
set -e
echo "=== Устранение уязвимостей CUPS ==="
echo
echo "[1/3] Обновление пакетов до исправленных версий..."
apt-get update -qq
apt-get install -y -q --only-upgrade \
    cups cups-browsed cups-filters libcupsfilters2t64 libppd2 >/dev/null
echo "    Готово. Текущие версии:"
dpkg -l | grep -E 'cups-browsed|libcupsfilters2t64|libppd2:|cups-filters ' \
        | awk '{printf "    %-28s %s\n", $2, $3}'
echo
echo "[2/3] Отключение приёма удалённых протоколов и остановка cups-browsed..."
sed -i 's/^BrowseRemoteProtocols.*/BrowseRemoteProtocols none/' /etc/cups/cups-browsed.conf
pkill cups-browsed 2>/dev/null || true
# В системе с systemd: systemctl disable --now cups-browsed
echo "    BrowseRemoteProtocols -> none, сервис cups-browsed остановлен."
echo
echo "[3/3] Ограничение доступа к порту 631 межсетевым экраном..."
iptables -A INPUT -p udp --dport 631 -j DROP 2>/dev/null || \
    echo "    (iptables недоступен в этом контейнере - примените на хосте/в ВМ)"
iptables -A INPUT -p tcp --dport 631 ! -s 127.0.0.1 -j DROP 2>/dev/null || true
echo
echo "Готово. Проверьте результат командой check_vuln.sh"
