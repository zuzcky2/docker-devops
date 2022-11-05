
set -e

is_replication=`mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "SHOW SLAVE STATUS\G;"  | cut -d \t -f 2`
if [ -z "$is_replication" ];then

  replication_user=`mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "SELECT distinct(COUNT(*)) AS cnt FROM mysql.user WHERE Host = '$MYSQL_REPLICATION_HOST' AND User = '$MYSQL_REPLICATION_USER';"  | cut -d \t -f 2`

  if [ "$replication_user" != "1" ];then
  	mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "CREATE USER '$MYSQL_REPLICATION_USER'@'$MYSQL_REPLICATION_HOST' IDENTIFIED WITH mysql_native_password"
    mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "ALTER USER '$MYSQL_REPLICATION_USER'@'$MYSQL_REPLICATION_HOST' IDENTIFIED BY '$MYSQL_REPLICATION_PASS'"
    mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "GRANT REPLICATION SLAVE, REPLICATION CLIENT, SUPER on *.* to '$MYSQL_REPLICATION_USER'@'$MYSQL_REPLICATION_HOST'"

    mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES"
  fi
fi

is_user=`mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "SELECT distinct(COUNT(*)) AS cnt FROM mysql.user WHERE Host = '%' AND User = 'haproxy';"  | cut -d \t -f 2`
if [ "$is_user" != "1" ];then
  mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "CREATE USER 'haproxy'@'%' IDENTIFIED WITH mysql_native_password"
  mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES"
fi
