set -e

__MYSQL_REPLICATION_MASTER_HOST__='10.0.0.115'
__MYSQL_REPLICATION_MASTER_PORT__='23306'

master_log_file=`mysql -uroot -p$MYSQL_REPLICATION_MASTER_PASS -h $__MYSQL_REPLICATION_MASTER_HOST__ -P$__MYSQL_REPLICATION_MASTER_PORT__ -e"show master status\G" | grep mysql-bin`
re="[a-z]*-bin.[0-9]*"

if [[ ${master_log_file} =~ $re ]];then
    master_log_file=${BASH_REMATCH[0]}
fi

master_log_pos=`mysql -uroot -p$MYSQL_REPLICATION_MASTER_PASS -h $__MYSQL_REPLICATION_MASTER_HOST__ -P$__MYSQL_REPLICATION_MASTER_PORT__ -e"show master status\G" | grep Position`
re="[0-9]+"

if [[ ${master_log_pos} =~ $re ]];then
    master_log_pos=${BASH_REMATCH[0]}
fi

query="change master to master_host='$__MYSQL_REPLICATION_MASTER_HOST__', master_user='$MYSQL_REPLICATION_USER', master_password='$MYSQL_REPLICATION_PASS', master_log_file='${master_log_file}', master_log_pos=${master_log_pos}, master_port=$__MYSQL_REPLICATION_MASTER_PORT__"
echo ${query}
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "${query}"
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "start slave"