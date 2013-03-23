-- using 205164841 as a seed to the RNG
-- @(#)10.sql	2.1.8.1
-- TPC-H/TPC-R Returned Item Reporting Query (Q10)
-- Functional Query Definition
-- Approved February 1998
START TRANSACTION

EXPLAIN


select
	c_custkey,
	c_name,
	sum(l_extendedprice * (1 - l_discount)) as revenue,
	c_acctbal,
	n_name,
	c_address,
	c_phone,
	c_comment
from
	customer /*! force index (primary) */,
	orders /*! force index (i_o_orderdate) */,
	lineitem /*! force index (i_l_orderkey) */,
	nation /*! force index (primary) */
where
	c_custkey = o_custkey
	and l_orderkey = o_orderkey
	and o_orderdate >= date '1994-08-01'
	and o_orderdate < date '1994-08-01' + interval 3 month
	and l_returnflag = 'R'
	and c_nationkey = n_nationkey
group by
	c_custkey,
	c_name,
	c_acctbal,
	c_phone,
	n_name,
	c_address,
	c_comment
order by
	revenue desc
LIMIT 20;
COMMIT;

