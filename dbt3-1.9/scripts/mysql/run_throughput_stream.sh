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

if [ $# -ne 7 ]; then
        echo "Usage: $0 <scale_factor> <perf_run_num> <stream_num> <0/1 - explain analyze off/on> <run dir> <seed file> <0/1 - explain on/off>"
        exit 1
fi

scale_factor=$1
perf_run_num=$2
stream_num=$3
EXPLAIN_ANALYZE=$4
OUTPUT_DIR=$5
SEED_FILE=$6
NO_EXPLAIN=$7
RUNDIR=$OUTPUT_DIR/run

DIR=`dirname $0`
. ${DIR}/mysql_profile
MYSQL="/sraid/local/mysql/bin/mysql --defaults-file=${MYSQL_CONFIG} --database=${SID} ${MYSQL_OPTS}"

DBSCRIPTDIR=$SRCDIR/scripts/mysql
query_file="$RUNDIR/throughput_query$stream_num"
tmp_query_file="$RUNDIR/tmp_throughput_query$stream_num.sql"
param_file="$RUNDIR/throughput_param$stream_num"

# output PID to a tmp file
echo "$$" > $RUNDIR/PID$stream_num

if [ ! -f $SEED_FILE ]; then
	echo "creating seed file $SEED_FILE, you can change the seed by "
	echo "modifying this file"
	${SHELL} $SRCDIR/scripts/init_seed.sh > $SEED_FILE
fi

seed=`cat $SEED_FILE`

let "seed = $seed + $stream_num"
# generate the queries for thoughput test
rm -f $query_file
rm -f $tmp_query_file
if [ $EXPLAIN_ANALYZE -eq 0 ]; then
	$QGEN -c -r $seed -p $stream_num -s $scale_factor -l $param_file> $query_file || exit 1
else
	$QGEN -c -r $seed -p $stream_num -s $scale_factor -l $param_file -y > $query_file || exit 1
fi
# modify $query_file so that the commands are in one line
${PARSE_QUERY} $query_file $tmp_query_file T $perf_run_num $stream_num

if [ $NO_EXPLAIN -eq 0 ]; then
	# get the execution plan for each query
	${SHELL} $DBSCRIPTDIR/record_start.sh -n "PERF${perf_run_num}.THRUPUT.EXPLAIN${stream_num}" || exit 1
	PLANDIR=$OUTPUT_DIR/db/plans
	mkdir -p $PLANDIR
	i=1
	while [ $i -le 22 ]
	do
		if [ $i -ne 15 -a $i -ne 22 ]; then
			${SHELL} $DBSCRIPTDIR/record_start.sh -n "PERF${perf_run_num}.THRUPUT.EXPLAIN${stream_num}.Q${i}" || exit 1
			${SHELL} $DBSCRIPTDIR/get_query_plan.sh $scale_factor $i $PLANDIR/throughput_stream${stream_num}_query$i.txt $RUNDIR $SEED_FILE
			${SHELL} $DBSCRIPTDIR/record_end.sh -n "PERF${perf_run_num}.THRUPUT.EXPLAIN${stream_num}.Q${i}" || exit 1		
		fi
		let "i=$i+1"
	done
	${SHELL} $DBSCRIPTDIR/record_end.sh -n "PERF${perf_run_num}.THRUPUT.EXPLAIN${stream_num}" || exit 1		
fi

# run the queries
echo "`date`: start throughput queries for stream $stream_num "
s_time=`$GTIME`
${SHELL} $DBSCRIPTDIR/record_start.sh -n "PERF${perf_run_num}.THRUPUT.QS${stream_num}.ALL" || exit 1

# Output all queries to the stdout by using "-v".
$MYSQL -v < $tmp_query_file >> $OUTPUT_DIR/results/thruput_qs${stream_num}.result 2>&1 || exit 1
${SHELL} $DBSCRIPTDIR/record_end.sh -n "PERF${perf_run_num}.THRUPUT.QS${stream_num}.ALL" || exit 1
e_time=`$GTIME`
echo "`date`: end queries "
let "diff_time=$e_time-$s_time"
echo "elapsed time for queries $diff_time"

exit 0
