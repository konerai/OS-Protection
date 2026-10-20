#!/bin/bash
# Запускает cupsd и cups-browsed в уязвимой конфигурации, затем держит контейнер.
set -e
echo "[*] Запуск cupsd..."
cupsd
sleep 1
echo "[*] Запуск cups-browsed (уязвимая конфигурация)..."
cups-browsed &>/var/log/cups-browsed.log &
sleep 2
echo
echo "========================================================"
echo " Лабораторный стенд CUPS запущен (УЯЗВИМОЕ состояние)."
echo " Проверка:   check_vuln.sh"
echo " Устранение: fix_vuln.sh"
echo "========================================================"
echo
exec bash
