#!/bin/bash
#
# This file is modified for adding MySQL support.
#
# (c)Copyright 2006 Hewlett-Packard Development Company, L.P.
# Copyright(c) Information-technology Promotion Agency, Japan. All rights reserved 2006.
# Result of Open Source Software Development Activities
# of Information-technology Promotion Agency, Japan.
#

echo "Updating optimizer statistics..."

# -z $SID
DIR=`dirname $0`
. ${DIR}/mysql_profile
MYSQL="/sraid/local/mysql/bin/mysql --defaults-file=${MYSQL_CONFIG} --database=${SID} ${MYSQL_OPTS} -e"

$MYSQL "analyze table supplier"
$MYSQL "analyze table part"
$MYSQL "analyze table partsupp"
$MYSQL "analyze table customer"
$MYSQL "analyze table orders"
$MYSQL "analyze table lineitem"
$MYSQL "analyze table nation"
$MYSQL "analyze table region"
