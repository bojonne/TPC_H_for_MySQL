#!/bin/bash

#
# This file is released under the terms of the Artistic License.
# Please see the file LICENSE, included in this package, for details.
#
# Copyright (C) 2005 Jenny Zhang & Open Source Development Labs, Inc.
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

MYSQL="/sraid/local/mysql/bin/mysql --defaults-file=${MYSQL_CONFIG} --database=${SID} ${MYSQL_OPTS} -e"

${MYSQL} "DROP TABLE supplier;"
${MYSQL} "DROP TABLE part;"
${MYSQL} "DROP TABLE partsupp;"
${MYSQL} "DROP TABLE customer;"
${MYSQL} "DROP TABLE orders;"
${MYSQL} "DROP TABLE lineitem;"
${MYSQL} "DROP TABLE nation;"
${MYSQL} "DROP TABLE region;"
${MYSQL} "DROP TABLE time_statistics;"

exit 0
