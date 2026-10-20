#!/bin/bash
# Устранение Dirty Pipe: обновление ядра до исправленной версии.
# Запускать с правами root. После установки требуется reboot.
set -e
if [ "$(id -u)" -ne 0 ]; then echo "Запустите через sudo."; exit 1; fi
echo "=== Устранение Dirty Pipe: обновление ядра ==="
echo "Текущее ядро: $(uname -r)"
echo
echo "[*] Обновление списков пакетов и установка актуального ядра..."
apt-get update -qq
apt-get install -y linux-generic
echo
echo "Ядро обновлено. ВЫПОЛНИТЕ ПЕРЕЗАГРУЗКУ:  sudo reboot"
echo "После перезагрузки проверьте:  check_dirtypipe.sh"
