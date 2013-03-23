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

ENGINE=
VARCHAR="VARCHAR"
while getopts "mi" OPT; do
	case ${OPT} in
	i)
		VARCHAR="CHAR"
		;;
	m)
		ENGINE="ENGINE = MyISAM"
		;;
	esac
done


${MYSQL} "
CREATE TABLE supplier (
	s_suppkey  INTEGER,
	s_name CHAR(25),
	s_address ${VARCHAR}(40),
	s_nationkey INTEGER,
	s_phone CHAR(15),
	s_acctbal FLOAT,
	s_comment ${VARCHAR}(101))
	${ENGINE};
" || exit 1

${MYSQL} "
CREATE TABLE part (
	p_partkey INTEGER,
	p_name ${VARCHAR}(55),
	p_mfgr CHAR(25),
	p_brand CHAR(10),
	p_type ${VARCHAR}(25),
	p_size INTEGER,
	p_container CHAR(10),
	p_retailprice FLOAT,
	p_comment ${VARCHAR}(23))
	${ENGINE};
" || exit 1

${MYSQL} "
CREATE TABLE partsupp (
	ps_partkey INTEGER,
	ps_suppkey INTEGER,
	ps_availqty INTEGER,
	ps_supplycost FLOAT,
	ps_comment ${VARCHAR}(199));
" || exit 1

${MYSQL} "
CREATE TABLE customer (
	c_custkey INTEGER,
	c_name ${VARCHAR}(25),
	c_address ${VARCHAR}(40),
	c_nationkey INTEGER,
	c_phone CHAR(15),
	c_acctbal FLOAT,
	c_mktsegment CHAR(10),
	c_comment ${VARCHAR}(117));
" || exit 1

${MYSQL} "
CREATE TABLE orders (
	o_orderkey INTEGER,
	o_custkey INTEGER,
	o_orderstatus CHAR(1),
	o_totalprice FLOAT,
	o_orderDATE DATE,
	o_orderpriority CHAR(15),
	o_clerk CHAR(15),
	o_shippriority INTEGER,
	o_comment ${VARCHAR}(79));
" || exit 1

${MYSQL} "
CREATE TABLE lineitem (
	l_orderkey INTEGER,
	l_partkey INTEGER,
	l_suppkey INTEGER,
	l_linenumber INTEGER,
	l_quantity FLOAT,
	l_extendedprice FLOAT,
	l_discount FLOAT,
	l_tax FLOAT,
	l_returnflag CHAR(1),
	l_linestatus CHAR(1),
	l_shipDATE DATE,
	l_commitDATE DATE,
	l_receiptDATE DATE,
	l_shipinstruct CHAR(25),
	l_shipmode CHAR(10),
	l_comment ${VARCHAR}(44));
" || exit 1

${MYSQL} "
CREATE TABLE nation (
	n_nationkey INTEGER,
	n_name CHAR(25),
	n_regionkey INTEGER,
	n_comment ${VARCHAR}(152));
" || exit 1

${MYSQL} "
CREATE TABLE region (
	r_regionkey INTEGER,
	r_name CHAR(25),
	r_comment ${VARCHAR}(152));
" || exit 1

${MYSQL} "
CREATE TABLE time_statistics (
	task_name VARCHAR(40),
	s_time DATETIME,
	e_time DATETIME,
	int_time INTEGER);
" || exit 1

exit 0
