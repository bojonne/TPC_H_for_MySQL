#!/bin/sh
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

MYSQL="/sraid/local/mysql/bin/mysql --defaults-file=${MYSQL_CONFIG} ${MYSQL_OPTS} -e"

${MYSQL} "DROP DATABASE IF EXISTS ${SID};" || exit 1
