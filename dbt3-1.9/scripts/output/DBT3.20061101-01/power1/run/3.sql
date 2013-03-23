-- using 205164841 as a seed to the RNG
-- @(#)3.sql	2.1.8.1
-- TPC-H/TPC-R Shipping Priority Query (Q3)
-- Functional Query Definition
-- Approved February 1998
START TRANSACTION

EXPLAIN


select
	l_orderkey,
	sum(l_extendedprice * (1 - l_discount)) as revenue,
	o_orderdate,
	o_shippriority
from
	customer /*! ignore index (primary) */,
	orders /*! force index (i_o_custkey) */,
	lineitem /*! force index (i_l_orderkey) */
where
	c_mktsegment = 'BUILDING'
	and c_custkey = o_custkey
	and l_orderkey = o_orderkey
	and o_orderdate < date '1995-03-18'
	and l_shipdate > date '1995-03-18'
group by
	l_orderkey,
	o_orderdate,
	o_shippriority
order by
	revenue desc,
	o_orderdate
LIMIT 10;
COMMIT;

