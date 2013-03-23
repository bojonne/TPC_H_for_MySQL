#!/bin/sh

#
# This file is released under the terms of the Artistic License.
# Please see the file LICENSE, included in this package, for details.
#
# Copyright (C) 2003 Jenny Zhang & Open Source Development Lab, Inc.
#
#
# This file is modified for adding MySQL support.
#
# (c)Copyright 2006 Hewlett-Packard Development Company, L.P.
# Copyright(c) Information-technology Promotion Agency, Japan. All rights reserved 2006.
# Result of Open Source Software Development Activities
# of Information-technology Promotion Agency, Japan.
#

SRCDIR=/sraid/dbt3-1.9

if [ $# -ne 6 ]; then
        echo "Usage: ./run_power_query.sh <scale_factor> <perf_run_number> <0/1 - explain analyze off/on> <output dir> <run dir> <seed file>"
        exit 1
fi

scale_factor=$1
perf_run_number=$2
EXPLAIN_ANALYZE=$3
OUTPUT_DIR=$4
RUNDIR=$5
SEED_FILE=$6

echo -----------------
echo $1
echo $2
echo $3
echo $4
echo $5
echo $6
echo ------------------

DIR=`dirname $0`
. ${DIR}/mysql_profile
MYSQL="/sraid/local/mysql/bin/mysql --defaults-file=${MYSQL_CONFIG} --database=${SID} ${MYSQL_OPTS}"

query_file="$RUNDIR/power_query"
tmp_query_file="$RUNDIR/tmp_query.sql"
param_file="$RUNDIR/power_param"

if [ ! -f $SEED_FILE ]; then
	echo "creating seed file $SEED_FILE, you can change the seed by"
	echo "modifying this file"
	${SHELL} $SRCDIR/scripts/init_seed.sh > $SEED_FILE
fi

echo ${QGEN}
# generate the queries for power test
rm -f $query_file
if [ $EXPLAIN_ANALYZE -eq 0 ]; then
	echo ${QGEN}
	${QGEN} -c -r  `cat $SEED_FILE` -p 0 -s $scale_factor -l $param_file> $query_file || exit 1
else
	${QGEN} -c -r  `cat $SEED_FILE` -p 0 -s $scale_factor -l $param_file -y > $query_file || exit 1
fi
# modify $query_file so that the commands are in one line
${PARSE_QUERY} $query_file $tmp_query_file P $perf_run_number

# run the queries
echo "`date`: Starting Power Test queries..."
s_time=`$GTIME`
$MYSQL -e "insert into time_statistics (task_name, s_time, int_time) values ('PERF${perf_run_number}.POWER.QS', current_timestamp, $s_time);" || exit 1
echo "aaaaa"
$MYSQL -v < $tmp_query_file >> $OUTPUT_DIR/results/power_query.result 2>&1 || exit 1
echo "bbbbb"
$MYSQL -e "update time_statistics set e_time=current_timestamp where task_name='PERF${perf_run_number}.POWER.QS' and int_time=$s_time;" || exit 1
e_time=`$GTIME`
echo "`date`: Power Test queries completed."
let "diff_time=$e_time-$s_time"
echo "Elapsed time for Power Test queries : $diff_time seconds"

exit 0
