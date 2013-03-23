#!/bin/bash
# q_time.sh: get task execution times
#
# This file is released under the terms of the Artistic License.  Please see
# the file LICENSE, included in this package, for details.
#
# Copyright (C) 2003 Jenny Zhang & Open Source Development Lab, Inc.
#
# Author: Jenny Zhang
# Heavily modified by: Mark Wong
#
# This file is modified for adding MySQL support.
#
# (c)Copyright 2006 Hewlett-Packard Development Company, L.P.
# Copyright(c) Information-technology Promotion Agency, Japan. All rights reserved 2006.
# Result of Open Source Software Development Activities
# of Information-technology Promotion Agency, Japan.
#

DIR=`dirname $0`
. ${DIR}/mysql_profile
MYSQL="/sraid/local/mysql/bin/mysql --defaults-file=${MYSQL_CONFIG} --database=${SID} ${MYSQL_OPTS} -e"

SQL="SELECT task_name, s_time, e_time, TIMEDIFF(e_time, s_time) AS diff_time, TIME_TO_SEC(TIMEDIFF(e_time, s_time)) AS seconds FROM time_statistics;"
ARGS=
while getopts "ho:" opt; do
	case $opt in
		h)
			ARGS="-H"
			SQL="SELECT task_name AS Task, s_time AS Start_Time, e_time AS End_Time, TIMEDIFF(e_time, s_time) AS Elapsed_Time FROM time_statistics;"
			;;
		o)
			OUTPUT=1
			OUTPUT_FILE="$OPTARG/q_time.out"
			;;
	esac
done

if [ "x$OUTPUT" = "x" ]; then
    $MYSQL "${SQL}" $ARGS
else
    $MYSQL "${SQL}" $ARGS >> $OUTPUT_FILE
fi

