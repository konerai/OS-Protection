#!/bin/bash
# Собирает готовый OVA-образ учебной ВМ (уязвимое ядро + старый CUPS + скрипты).
# Требуется: VirtualBox + Vagrant на ЛОКАЛЬНОЙ машине (с поддержкой виртуализации).
set -e
OVA="os-security-lab.ova"
echo "[1/3] Поднимаем ВМ и провиженим уязвимое состояние..."
vagrant up
echo "[2/3] Останавливаем ВМ перед экспортом..."
vagrant halt
echo "[3/3] Экспортируем в OVA: $OVA"
VMNAME="os-security-lab"
VBoxManage export "$VMNAME" --output "$OVA" --ovf20 \
  --vsys 0 --product "OS Security Lab (CUPS + Dirty Pipe)" \
  --description "Учебная ВМ с уязвимыми CUPS и ядром."
echo
echo "Готово: $(pwd)/$OVA"
echo "Импорт у преподавателя: VirtualBox → Файл → Импорт конфигураций → $OVA"
