#!/usr/bin/env ruby

MYSQL_USER=ENV['MYSQL_USER']
MYSQL_PASS=ENV['MYSQL_PASS']
REP_USER=ENV['REP_USER']
REP_PASS=ENV['REP_PASS']
PORT=ENV['PORT']
PROTO=ENV['PROTO']
DATA_DIR=ENV['DATA_DIR']


DATA_DIR=DATA_DIR + '/' + ENV['HOST']


firstrun() {
	cp -r /var/lib/mysql/* ${DATA_DIR}
	chown -R mysql ${DATA_DIR}
	chown root ${DATA_DIR}/debian*
}

main() {
	if [[ ! -f /data/debian-5.5.flag ]]
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