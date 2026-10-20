#!/bin/bash
# Проверка уязвимого состояния CUPS (CVE-2024-47076/47175/47176/47177).
# Только обнаружение, без эксплуатации.
echo "=== Проверка уязвимостей CUPS ==="
echo
echo "[1] Версии установленных пакетов:"
dpkg -l | grep -E 'cups-browsed|libcupsfilters2t64|libppd2:|cups-filters |cups-daemon' \
        | awk '{printf "    %-28s %s\n", $2, $3}'
echo
echo "[2] Фоновый сервис cups-browsed:"
if pgrep -x cups-browsed >/dev/null; then
    echo "    [УЯЗВИМО] cups-browsed ЗАПУЩЕН"
else
    echo "    [OK] cups-browsed не запущен"
fi
echo
echo "[3] Приём удалённых протоколов (BrowseRemoteProtocols):"
val=$(grep -E '^BrowseRemoteProtocols' /etc/cups/cups-browsed.conf | awk '{$1="";print $0}' | xargs)
if [ -n "$val" ] && [ "$val" != "none" ]; then
    echo "    [УЯЗВИМО] BrowseRemoteProtocols = $val (принимаются удалённые анонсы)"
else
    echo "    [OK] BrowseRemoteProtocols = ${val:-не задан}"
fi
echo
echo "[4] Прослушиваемый UDP-порт 631:"
if ss -ulpn 2>/dev/null | grep -q ':631'; then
    echo "    [УЯЗВИМО] UDP/631 прослушивается:"
    ss -ulpn | grep ':631' | sed 's/^/      /'
else
    echo "    [OK] UDP/631 не прослушивается"
fi
echo
echo "Вывод: наличие пунктов [УЯЗВИМО] означает подверженность цепочке CUPS."
