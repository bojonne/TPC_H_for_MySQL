#!/bin/sh

#
# This file is released under the terms of the Artistic License.
# Please see the file LICENSE, included in this package, for details.
#
# Copyright (C) 2002 Open Source Development Lab, Inc.
#

#
# This file is modified for adding MySQL support.
#
# (c)Copyright 2006 Hewlett-Packard Development Company, L.P.
# Copyright(c) Information-technology Promotion Agency, Japan. All rights reserved 2006.
# Result of Open Source Software Development Activities
# of Information-technology Promotion Agency, Japan.
#


DIR=`dirname $0`
. ${DIR}/mysql_profile || exit 1

# dont start script as root!
id=`id | sed s/\(.*// | sed s/uid=//`

if [ "$id" = "0" ]; then
	echo "dont start script as root"
	exit 1
fi

OUTPUT_DIR="."
while getopts "o:p:" OPT; do
	case ${OPT} in
	o)
		OUTPUT_DIR=${OPTARG}
		;;
	p)
		PARAMETERS=${OPTARG}
		;;
	esac
done

${SHELL} /sraid/dbt3-1.9/scripts/mysql/stop_db.sh

if [ -d $MYSQL_DATA ]; then
	echo "================================================="
	echo "MySQL Data directory $MYSQL_DATA already exists"
	echo "Skipping initdb"
	echo "================================================="

	# Don't need to initdb, blindly try to drop the dbt3 database in case
	# it exists.
	${SHELL} /sraid/dbt3-1.9/scripts/mysql/start_db.sh -o ${OUTPUT_DIR} -p "$PARAMETERS" || exit 1
	${SHELL} /sraid/dbt3-1.9/scripts/mysql/drop_db.sh
else
	# initialize database
	echo "initializing database..."
	if [ -f ${MYSQL_CONFIG} ]; then
	  echo "Use an exist my.cnf.";
	else
	  mkdir -p `dirname ${MYSQL_CONFIG}` || exit 1
	  cp /sraid/dbt3-1.9/scripts/mysql/my.cnf ${MYSQL_CONFIG} || exit 1
	fi
	mkdir -p $MYSQL_DATA || exit 1
	cd `dirname /sraid/local/mysql/scripts/mysql_install_db`/..
	/sraid/local/mysql/scripts/mysql_install_db --defaults-file=${MYSQL_CONFIG} || exit 1
	cd -
fi

${SHELL} /sraid/dbt3-1.9/scripts/mysql/start_db.sh -o ${OUTPUT_DIR} -p "$PARAMETERS" || exit

##
## Wait creating db for MAX_WAITS * 5 sec.
MAX_WAIT=720
WAIT=0
ALIVE=1
echo -n "Waiting the database initialization"
while [ $ALIVE -eq 1 -a $WAIT -lt $MAX_WAIT ];
do
  echo -n "."
  /sraid/local/mysql/bin/mysqladmin --defaults-file=${MYSQL_CONFIG} ping > /dev/null 2>&1
  ALIVE=$?
  let MAX_WAIT=$MAX_WAIT+1
  sleep 5
done
echo

MYSQL="/sraid/local/mysql/bin/mysql --defaults-file=${MYSQL_CONFIG} ${MYSQL_OPTS} -e"

${MYSQL} "CREATE DATABASE IF NOT EXISTS ${SID};" || exit 1

exit 0
