#!/bin/bash

HOME="$(pwd)"

echo "Вы подключены к сети интернет?[Y/n]"
read STATUS

# Копируем файлы c репозиторями
if [[ "$STATUS" = "Y" ]]; then
  sudo cp $PWD/sources_www.list /etc/apt/sources.list
  sudo apt update
  sudo apt install mariadb-server -y
  sudo cp $PWD/sources_extended_www.list /etc/apt/sources.list
  sudo apt update
  sudo apt list --upgradable
  sudo apt install mariadb-server mariadb-server-10.3 mariadb-common -y
else
  sudo cp $PWD/sources.list /etc/apt/sources.list
  sudo apt update
  sudo apt install mariadb-server -y
  sudo cp $PWD/sources_extended.list /etc/apt/sources.list
  sudo apt update
  sudo apt list --upgradable
  sudo apt install mariadb-server mariadb-server-10.3 mariadb-common -y
fi

# Копируем конфиг mariadb
sudo cp $PWD/mariadb.cnf /etc/mysql/mariadb.cnf
sudo mysql_secure_installation
sudo mysql_upgrade --verbose --force

# Создаем пользователя ksc внутри mariadb
echo "Введите ip с которого пользователь будет подключаться к mariadb [127.0.0.1]"
read ip
echo "Введите пароль для пользователя ksc используещегося для подключения к mariadb"
read pass
sudo mysql -e "USE mysql;"
sudo mysql -e "USE mysql; CREATE USER 'ksc'@'$ip' IDENTIFIED BY '$pass';"
sudo mysql -e "USE mysql; CREATE USER 'ksc'@'127.0.0.1' IDENTIFIED BY '$pass';"
sudo mysql -e "USE mysql; CREATE USER 'ksc'@'localhost' IDENTIFIED BY '$pass';"
sudo mysql -e "USE mysql; GRANT ALL PRIVILEGES ON *.* TO 'ksc'@'$ip';"
sudo mysql -e "USE mysql; GRANT ALL PRIVILEGES ON *.* TO 'ksc'@'127.0.0.1';"
sudo mysql -e "USE mysql; GRANT ALL PRIVILEGES ON *.* TO 'ksc'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Создаем локального пользователя ksc
echo "Создается локальный пользователь ksc"
sudo adduser ksc
sudo groupadd kladmins
sudo gpasswd -a ksc kladmins
sudo usermod -g kladmins ksc

# Устанавливаем ksc64 и производим настройку
sudo apt-get install $PWD/ksc64* -y
sudo /opt/kaspersky/ksc64/lib/bin/setup/postinstall.pl

# Устанавливаем web-console и производим настройку
sudo cp ./ksc-web-console-setup.json /etc/ksc-web-console-setup.json
sudo apt-get install $PWD/ksc-web*.deb -y

# Активируем подключение через mmc консоль
cd /opt/kaspersky/ksc64/sbin/
./klscflag -ssvset -pv klserver -s 87 -n KLSRV_SP_SERVER_SSL_PORT_GUI_OPEN -sv true -svt BOOL_T -ss "|ss_type = \"SS_SETTINGS\";"
sudo systemctl restart kladminserver_srv
./klscflag -ssvget -pv klserver -s 87 -n KLSRV_SP_SERVER_SSL_PORT_GUI_OPEN -svt BOOL_T -ss "|ss_type = \"SS_SETTINGS\";"

# Копируем файл сертификата
sudo cp /var/opt/kaspersky/klnagent_srv/1093/cert/klserver.cer $HOME/klserver.cer
echo "Установка завершена. Для подключения через MMC консоль скопируйте сертификат klserver.cer"
