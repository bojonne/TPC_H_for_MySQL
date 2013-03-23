-- using 205164841 as a seed to the RNG
-- @(#)5.sql	2.1.8.1
-- TPC-H/TPC-R Local Supplier Volume Query (Q5)
-- Functional Query Definition
-- Approved February 1998
START TRANSACTION

EXPLAIN


select
	n_name,
	sum(l_extendedprice * (1 - l_discount)) as revenue
from
	customer /*! force index (i_c_nationkey) */,
	orders /*! force index (i_o_custkey) */,
	lineitem /*! force index (i_l_orderkey) */,
	supplier /*! force index (primary) */,
	nation /*! force index (i_n_regionkey) */,
	region /*! ignore index (primary) */
where
	c_custkey = o_custkey
	and l_orderkey = o_orderkey
	and l_suppkey = s_suppkey
	and c_nationkey = s_nationkey
	and s_nationkey = n_nationkey
	and n_regionkey = r_regionkey
	and r_name = 'EUROPE'
	and o_orderdate >= date '1994-01-01'
	and o_orderdate < date '1994-01-01' + interval 1 year
group by
	n_name
order by
	revenue desc;
COMMIT;

