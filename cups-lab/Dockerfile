# Лабораторный образ: Ubuntu 24.04 с УЯЗВИМЫМИ версиями CUPS.
# Назначение: учебная демонстрация обнаружения и устранения
# CVE-2024-47076 / 47175 / 47176 / 47177.
# ВНИМАНИЕ: образ умышленно содержит устаревшие пакеты. Запускать
# только в изолированной среде, НЕ публиковать порт 631 в сеть.
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Устаревшие (уязвимые) версии пакетов из релизного pocket noble
ARG CUPS_VER=2.4.7-1.2ubuntu7
ARG BROWSED_VER=2.0.0-0ubuntu10
ARG FILTERS_VER=2.0.0-0ubuntu4

RUN apt-get update && \
    apt-get install -y --no-install-recommends --allow-downgrades \
        cups=${CUPS_VER} cups-daemon=${CUPS_VER} cups-client=${CUPS_VER} \
        libcups2t64=${CUPS_VER} cups-core-drivers=${CUPS_VER} \
        cups-ipp-utils=${CUPS_VER} cups-server-common=${CUPS_VER} \
        cups-common=${CUPS_VER} libcupsimage2t64=${CUPS_VER} \
        cups-browsed=${BROWSED_VER} cups-filters=${FILTERS_VER} \
        cups-filters-core-drivers=${FILTERS_VER} \
        libcupsfilters2t64=2.0.0-0ubuntu7 libppd2=2:2.0.0-0ubuntu4 \
        libppd-utils=2:2.0.0-0ubuntu4 \
        iproute2 iptables nmap net-tools ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Копируем учебные скрипты
COPY check_vuln.sh /usr/local/bin/check_vuln.sh
COPY fix_vuln.sh   /usr/local/bin/fix_vuln.sh
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/*.sh

EXPOSE 631/tcp 631/udp
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
