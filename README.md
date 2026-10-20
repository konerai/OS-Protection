# 🛡️ Лабораторный стенд: уязвимости CUPS и Dirty Pipe

Учебный проект по дисциплине **«Защита операционных систем»**: воспроизведение, обнаружение и устранение двух резонансных групп уязвимостей Linux — цепочки в системе печати **CUPS** и уязвимости ядра **Dirty Pipe**.

Репозиторий содержит подробный разбор уязвимостей, готовые изолированные стенды для их демонстрации и скрипты проверки/исправления.

![Platform](https://img.shields.io/badge/platform-Linux-informational)
![Docker](https://img.shields.io/badge/CUPS%20lab-Docker-blue)
![Vagrant](https://img.shields.io/badge/Dirty%20Pipe%20lab-Vagrant-9cf)
![Purpose](https://img.shields.io/badge/purpose-education%20only-success)

> ⚠️ **Только для обучения в изолированной среде.** Стенды намеренно содержат устаревшие (уязвимые) компоненты, поэтому их нельзя подключать к рабочим сетям или публиковать порты наружу. Рабочий эксплойт-код в проект **не включён** — предоставлены только средства обнаружения уязвимого состояния и его устранения.

---

## 📋 Разбираемые уязвимости

| Уязвимость | CVE | Тип | CVSS | Стенд |
|---|---|---|---|---|
| **CUPS** (система печати) | CVE-2024-47076 / 47175 / 47176 / 47177 | Удалённое выполнение кода (цепочка) | 8.4–9.1 | `cups-lab/` — Docker |
| **Dirty Pipe** (ядро Linux) | CVE-2022-0847 | Локальное повышение привилегий до root | 7.8 | `dirtypipe-lab/` — Vagrant |

📖 **Полный отчёт с механизмами атак, оценкой критичности и скриншотами:** [`docs/report.md`](docs/report.md)

---

## 🧩 Почему два разных стенда

- **CUPS** — уязвимость пользовательского пространства (пакеты), поэтому достаточно контейнера Docker с установленными старыми версиями.
- **Dirty Pipe** — уязвимость **ядра** Linux. Контейнеры разделяют ядро хоста, поэтому для неё нужна отдельная виртуальная машина с собственным уязвимым ядром (Vagrant).

---

## 🚀 Быстрый старт

### CUPS (Docker)

```bash
cd cups-lab
docker compose up --build -d
docker compose exec cups-lab bash
# внутри контейнера:
check_vuln.sh     # показать уязвимое состояние
fix_vuln.sh       # применить исправления
check_vuln.sh     # убедиться, что всё закрыто
```

### Dirty Pipe (Vagrant)

```bash
cd dirtypipe-lab
vagrant up
vagrant ssh
# внутри ВМ:
check_dirtypipe.sh            # проверка версии ядра
sudo fix_dirtypipe.sh         # обновление ядра
sudo reboot
check_dirtypipe.sh            # убедиться, что ядро исправлено
```

### Готовый OVA-образ (единая ВМ)

Папка [`ova-build/`](ova-build/) собирает **один OVA** с обеими уязвимостями и всеми скриптами внутри — для импорта в VirtualBox:

```bash
cd ova-build
./build_ova.sh
```

Сборка OVA требует аппаратной виртуализации (VirtualBox + Vagrant) и выполняется на локальной машине — подробности в [`ova-build/README.md`](ova-build/README.md).

---

## 📁 Структура репозитория

```
.
├── README.md                  — этот файл
├── docs/
│   ├── report.md              — полный отчёт по уязвимостям
│   └── screenshots/           — скриншоты обнаружения и устранения
├── cups-lab/                  — Docker-стенд CUPS
│   ├── Dockerfile
│   ├── docker-compose.yml
│   ├── entrypoint.sh
│   ├── check_vuln.sh          — обнаружение
│   ├── fix_vuln.sh            — устранение
│   └── README.md
├── dirtypipe-lab/             — Vagrant-стенд Dirty Pipe
│   ├── Vagrantfile
│   ├── check_dirtypipe.sh     — проверка версии ядра
│   ├── fix_dirtypipe.sh       — обновление ядра
│   └── README.md
├── ova-build/                 — сборка единого OVA-образа
│   ├── Vagrantfile
│   ├── build_ova.sh
│   ├── scripts/               — те же 4 скрипта, попадают внутрь ВМ
│   └── README.md
└── scripts/
    └── dirtypipe_check.sh     — автономный проверщик версии ядра
```

---

## 🔧 Скрипты

| Скрипт | Назначение |
|---|---|
| [`cups-lab/check_vuln.sh`](cups-lab/check_vuln.sh) | Проверка версий пакетов, запуска `cups-browsed`, настройки `BrowseRemoteProtocols` и прослушивания UDP/631 |
| [`cups-lab/fix_vuln.sh`](cups-lab/fix_vuln.sh) | Обновление пакетов, отключение `cups-browsed`, закрытие порта 631 фаерволом |
| [`dirtypipe-lab/check_dirtypipe.sh`](dirtypipe-lab/check_dirtypipe.sh) | Классификация версии ядра как уязвимой или исправленной |
| [`dirtypipe-lab/fix_dirtypipe.sh`](dirtypipe-lab/fix_dirtypipe.sh) | Обновление ядра до исправленной версии |

---

## 🎯 Что демонстрирует стенд

1. **Обнаружение** — скрипты показывают признаки уязвимого состояния (старые версии пакетов, запущенный `cups-browsed`, открытый UDP/631, уязвимая версия ядра).
2. **Устранение** — обновление компонентов, отключение лишних сервисов, настройка межсетевого экрана и обновление ядра.
3. **Проверка** — повторный запуск скриптов подтверждает, что уязвимости закрыты.

Подробное описание каждого шага со скриншотами — в [отчёте](docs/report.md).
