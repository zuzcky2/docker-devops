
set -e

mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "stop slave"
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "reset slave"
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "start slave"
