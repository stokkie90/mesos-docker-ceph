#!/usr/bin/env ruby

MYSQL_USER=${MYSQL_USER:-admin}
MYSQL_PASS=${MYSQL_PASS:-admin}
REP_USER=${REP_USER:-replicator}
REP_PASS=${REP_PASS:-replicator}
PORT=${PORT:-3306}
PROTO=${PROTO:-tcp}
DATA_DIR=${DATA_DIR:-/data}


DATA_DIR=${DATA_DIR}/${HOST}


firstrun() {
	cp -r /var/lib/mysql/* ${DATA_DIR}
	chown -R mysql ${DATA_DIR}
	chown root ${DATA_DIR}/debian*
}

main() {
	if [[ ! -f ${DATA_DIR}/debian-5.5.flag ]]
	then
		firstrun
	fi

	echo "datadir=${DATA_DIR}" >> /etc/mysql/my.cnf
	echo "wsrep_data_home_dir=${DATA_DIR}/" >> /etc/mysql/my.cnf

#	case "$1" in
#		master)
#			echo "Starting master"
#			echo "wsrep_cluster_address=gcomm://" >> /etc/mysql/my.cnf
#			/usr/bin/mysqld_safe
#			;;
#		node)
#			echo "Starting node"
#			if [[ -z "$2" ]]
#			then
#				echo "Missing master node IP"
#			else
#				echo "wsrep_cluster_address=gcomm://$2" >> /etc/mysql/my.cnf
#				/usr/bin/mysqld_safe
#			fi
#			;;
#		*)
#			echo "start <master|node> <master node ip>"
#	esac
}

main $@