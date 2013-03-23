#!/bin/sh

#
# This file is released under the terms of the Artistic License.
# Please see the file LICENSE, included in this package, for details.
#
# Copyright (C) 2004 Mark Wong & Open Source Development Lab, Inc.
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
DIR=`dirname $0`
. ${DIR}/mysql_profile
MYSQL="/sraid/local/mysql/bin/mysql --defaults-file=${MYSQL_CONFIG} --database=${SID} ${MYSQL_OPTS} -e"

while getopts "n:" opt; do
	case $opt in
	n)
		NAME=$OPTARG
		;;
	esac
done

SQL="UPDATE time_statistics SET e_time = current_timestamp WHERE task_name = '$NAME';"
$MYSQL "$SQL"
