#!/bin/bash
#
# This file is modified for adding MySQL support.
#
# (c)Copyright 2006 Hewlett-Packard Development Company, L.P.
# Copyright(c) Information-technology Promotion Agency, Japan. All rights reserved 2006.
# Result of Open Source Software Development Activities
# of Information-technology Promotion Agency, Japan.
#

DIR=`dirname $0`
. ${DIR}/mysql_profile || exit

# We only need to stop the database if it's running.
if [ -f ${MYSQL_DATA}/`hostname`.pid ]; then
	sleep 1
	/sraid/local/mysql/bin/mysqladmin --defaults-file=${MYSQL_CONFIG} -u root shutdown ${1}
	sleep 1
fi
