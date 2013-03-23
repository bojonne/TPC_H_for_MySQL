#!/bin/bash
#
# This file is modified for adding MySQL support.
#
# (c)Copyright 2006 Hewlett-Packard Development Company, L.P.
# Copyright(c) Information-technology Promotion Agency, Japan. All rights reserved 2006.
# Result of Open Source Software Development Activities
# of Information-technology Promotion Agency, Japan.
#

if [ "$1" = "-x" ]; then
  DB_STATS_OPT=1
  shift
else
  DB_STATS_OPT=0
fi

if [ $# -ne 2 ]; then
	echo "usage: db_stats.sh <database_name> <output_dir>"
	exit 1
fi

SID=$1
OUTPUT_DIR=$2

SAMPLE_LENGTH=60

DBOUTPUT_DIR=$OUTPUT_DIR/db
mkdir -p $DBOUTPUT_DIR

DIR=`dirname $0`
. ${DIR}/mysql_profile || exit 1
MYSQL="/sraid/local/mysql/bin/mysql --defaults-file=${MYSQL_CONFIG} --database=${SID} ${MYSQL_OPTS} -e"

# put db info into the readme.txt file
/sraid/local/mysql/bin/mysql --version >> $OUTPUT_DIR/readme.txt
echo "Database statistics taken at $SAMPLE_LENGTH second intervals, $ITERATIONS times." >> $OUTPUT_DIR/readme.txt


# save the database parameters
${MYSQL} "SHOW GLOBAL VARIABLES"  > $OUTPUT_DIR/param.out

# record indexes
${MYSQL} "SELECT * FROM information_schema.statistics WHERE table_schema = '${SID}';" > $DBOUTPUT_DIR/indexes.out

while [ 1 ]; do
	# collent ipcs stats
        ipcs >> $OUTPUT_DIR/ipcs.out
    if [ $DB_STATS_OPT -eq 1 ]; then
    	# InnoDB Status
		${MYSQL} "SHOW INNODB STATUS\G" >> $DBOUTPUT_DIR/innodb_status.txt
		# Global Status
		${MYSQL} "SHOW GLOBAL STATUS;" >> $DBOUTPUT_DIR/global_status.txt
    fi
	sleep $SAMPLE_LENGTH
done
