# KSC 14 Linux

## Description
Данный скрипт позволяет установить KSC 14 Linux c развертыванием БД mariadb на локальной машине.
### Состав репозитория
install.sh - установочный скрипт
ksc64_14.0.0-4490_amd64.deb - деб пакет ksc
ksc-web-console-14.0.1330.x86_64.deb - деб пакет веб консоли
ksc-web-console-setup.json - файл настроек веб консоли
mariadb.cnf - конфиг для маридб
sources.list - файл с репозиториями из /etc/apt/

## Requirements
1.  Astra Linux 1.7 (Возможно подойдут и версии ниже)
2. Доступ к репозиториям астры через интернет или через 10.148.2.25

## Installation

### Подготовка ОС
1. Установить Astra Linux Special Edition 1.7
2. При установке выбрать "Смоленск"
3. В следующем окне (где выбираем политики) **отключить все галочки** кроме "Пароль sudo"

### Клонирование репозитория
1. Скачать исходные файлы [с гитлаба](https://git.dev.ap17.mil.ru/av.kalinkin/ksc14_installer/-/archive/main/ksc14_installer-main.zip "с гитлаба")
2. Разархивировать
3. Закинуть папку KSC14_installer на подготовленный сервер.

### Подготовка настроек
Исходные настройки уже установлены при необходимости вы можете поменять: mariadb.cnf в соостветствии с этими доками:  [kaspersky](https://support.kaspersky.com/KSCLinux/14/ru-RU/210277.htm "kaspersky") - имеются параметры зависящие от размера базы данных, [mariadb](https://mariadb.com/kb/en/configuring-mariadb-with-option-files/ "mariadb")
ksc-web-console-setup.json:  [минимальная настройка](https://support.kaspersky.com/KSCLinux/14/ru-RU/181968.htm "минимальная настройка"), [синтаксис файла настроек](https://support.kaspersky.com/KSCLinux/14/ru-RU/181969.htm "синтаксис файла настроек")

### Установка
Повышаемся до superuserа
`# sudo su`

Переходим в папку KSC14
`# cd KSC14_installer/`

Делаем скрипт install.sh исполняемым
`# chmod +x install.sh`

Запускаем
`# ./install.sh`

#### Конфигурирование
1. Вы подключены к сети интернет?[Y/n] - отвечаем как есть (если нет репозитории будут скачиваться с 10.148.2.25 - за подробностями ко 2 отделу, если да - с интернета)
##### Настариваем mariadb
------------
2. Enter current password for root (enter for none): - вводим текущий пароль к базе mariadb (т.к. текущего пароля нет жмем enter)
3. Set root password? [Y/n] - *Y*
4. New password: - вводим новый пароль для пользователя root от mariadb
5. Re-enter new password: - повторяем пароль
6. Remove anonymous users? [Y/n] - *Y*
7. Disallow root login remotely? [Y/n] - *Y*
8. Remove test database and access to it? [Y/n] - *Y*
9. Reload privilege tables now? [Y/n] - *Y*
10. Введите ip с которого пользователь будет подключаться к mariadb [127.0.0.1] - *127.0.0.1* вводим ip c которого пользователь ksc будет подключаться к maraidb (в нашем случае локалхост т.к. базу и сервер разворачиваем на одной машине. Если появится необходимость на разных - то можно разделить скрипт на две части)
11. Введите пароль для пользователя ksc используещегося для подключения к mariadb - на данном этапе создается пользователь с именем ksc **внутри mariadb**
##### Создаем локального пользователя ksc и группу kladmins
------------
12. Создается локальный пользователь ksc
	Добавляется пользователь «ksc» ...
	Добавляется новая группа «ksc» (1002) ...
	 Добавляется новый пользователь «ksc» (1001) в группу «ksc» ...
	 Создаётся домашний каталог «/home/ksc» ...
	Копирование файлов из «/etc/skel» ...
	Новый пароль : - задаем пароль для локального пользователя ksc
##### Проходим postinstall касперского
------------
19. После появления соглашения касперского -* нажимаем пару раз Enter и потом Ctrl+C*
20. Enter 'Y' to confirm that you understand and accept the terms of the End User License Agreement (EULA). You must accept the terms and conditions of the EULA to install the application. Enter 'N' providing you do not accept the terms of the EULA or 'R' to view it again [N]: - *Y*
24. Enter 'Y' to confirm that you accept the terms of the Privacy Policy. You must accept the terms and conditions of the Privacy Policy to install the application. Entering 'Y' means that you are aware that your data will be handled and transmitted (including to third countries) as described in the Privacy Policy. Enter 'N' providing you do not accept the Privacy Policy [N]: - *Y*
30. Choose the Administration Server installation mode:
	1) Standard
	2) Primary cluster node
	3) Secondary cluster node
34. Enter the range number (1, 2, or 3) [1]:  - *1* выбираем стандартный режим, остальные режимы предназначены для развертывания [отказоустойчивого кластера](https://support.kaspersky.com/KSCLinux/14/ru-RU/222395.htm "отказоустойчивого кластера") (пока заниматься этим не будем)
35. Enter Administration Server DNS-name or static IP-address: вводим сетевой ip нашего сервера. В моем случае 192.168.10.58 (AVZ Polygon)
36. Enter Administration Server port number [14000]: - *14000*
37. Enter Administration Server SSL port number [13000]: - *13000*
38. Define the approximate number of devices that you intend to manage:
	1) 1 to 100 networked devices
	2) 101 to 1 000 networked devices
	3) More than 1 000 networked devices
42. Enter the range number (1, 2, or 3) [1]: - *1* количество узлов в сети (я выбирал 1, остальные значения не тестил на что будут влиять - не знаю)
43. Enter the security group name for services: - *kladmins*
44. Enter the account name to start the Administration Server service. The account must be a member of the entered security group: - *ksc*
46. Enter the account name to start other services. The account must be a member of the entered security group: - ksc
48. Enter the database address: - *127.0.0.1*
49. Enter the database port: - *3306*
50. Enter the database name: - *ksc_base* (задаем название БД, можно придумать любое)
51. Enter the database login: - *ksc*
52. Enter the database password: Вводим пароль от **пользователя mariadb**
##### Создаем пользователя вебки
------------
Enter the user name: - *ksc*
Password: *gJsqkw3.* (Обращаю внимание, то пароль должен содержать большие и маленькие буквы, цифры и символ)
В том случае если вы зафейлили создание пароля делаем следующее:
`/opt/kaspersky/ksc64/sbin/kladduser -n ksc -p QweRty123.!` ksc - имя польователя, QweRty123.! - пароль.
## Usage
### Подключение
Доступно два варианта подключения к созданному серверу ksc:
1. Веб интерфейс (работает не очень, но позволяет устанавливать веб плагины)
	Открываем браузер и переходим на https://192.168.10.58:8080/ вместо 192.168.10.58 - ip вашего сервера. Вводим логин и пароль от **вебки**
2. Консоль MMC
	Копируем сертификат на комп с обычной консолью (сертификат лежит в папке со скриптом)
`scp admsys@192.168.10.58:/home/admsys/KSC14_installer/klserver.cer .`
Добавляем сервер администрирования. Адрес такой же как и вебке - 192.168.10.58. Имя пользователя и пароль аналогично. Выбираем "Повторить аутентификацию Сервера администрирования, используя сертификат:" и выбираем скаченный нами сертификат.

### Добавление веб плагинова
1. Скачиваем веб плагин. Например этот [Kaspersky Endpoint Security 11.11.0 для Windows](https://media.kaspersky.com/utilities/CorporateUtilities/KSC/Multilanguage/keswin_web_plugin_11.11.0.452.zip?_ga=2.200446829.2133069140.1667220835-668926032.1663224128 "Kaspersky Endpoint Security 11.11.0 для Windows")
2. Открываем веб консоль и жмем:
		Параметры консоли
		Веб-плагины
		Добавить из файла
6. Добавляем plugin.zip и signature.txt

*Теперь можно создавать задачи специфичные для KES11 с любого компа без наличия расширений для консоли MMC (Но только через вебку)*

### Создание инсталяционных пакетов
Пердпочтительным вариантом добавления инсталяционных пакетов явялется использование MMC консоли, но добавление инсталяционного пакета удаленной установки для KESL чрез MMC не получилось. Поэтому используем следущий способ:
1. Переходим на страницу[ инсталяционных пакетов](https://www.kaspersky.ru/small-to-medium-business-security/downloads/endpoint?icid=ru_sup-site_trd_ona_oth__onl_b2b_klsupport_tri-dl____kes___&_ga=2.167418686.1835273657.1666852553-668926032.1663224128 " инсталяционных пакетов")
2. Пакет должен состоять из трех компонентов
	- Версия 11.2.0.4528 | AstraLinux x64 | Distributive
	- Версия 11.2.0.4528 | AstraLinux x64 | Files for Agent remote installation
	- Версия 11.2.0.4528 | AstraLinux x64 | Product GUI

3. Скачиваем все файлы, **разархивируем** и помещаем в архив .zip
4. Загружаем инсталяционный пакет в хранилище
		Операции
		Хранилища
		Инсталяционные пакеты
		Добавить
		Загружем пакет слепленный из трех

## Resources
- [Официальная документация](https://support.kaspersky.com/KSCLinux/14/ru-RU/176383.htm "Официаяльная документация")
- [Веб плагины управления](https://support.kaspersky.ru/9333?_ga=2.240230339.1339567028.1666676262-1834826871.1654588874#block8 "Веб плагины управления")
- [Файлы для создания инсталяционных пакетов](https://www.kaspersky.ru/small-to-medium-business-security/downloads/endpoint?icid=ru_sup-site_trd_ona_oth__onl_b2b_klsupport_tri-dl____kes___&_ga=2.167418686.1835273657.1666852553-668926032.1663224128 "Файлы для создания инсталяционных пакетов")
- [Создание пользователя в mariadb](https://mertviyprorok.com/articles/instructions/programs/sozdanie-bazy-dannyh-i-polzovatelja-v-mariadb-cherez-terminal/ "Создание пользователя в mariadb")
- [Открытие порта 13291 для подключения через MMC](https://support.kaspersky.com/KSCLinux/14/ru-RU/230088.htm "Открытие порта 13291 для подключения через MMC")



