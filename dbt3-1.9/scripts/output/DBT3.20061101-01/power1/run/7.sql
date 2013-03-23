-- using 205164841 as a seed to the RNG
-- @(#)7.sql	2.1.8.1
-- TPC-H/TPC-R Volume Shipping Query (Q7)
-- Functional Query Definition
-- Approved February 1998
START TRANSACTION

EXPLAIN


select
	supp_nation,
	cust_nation,
	l_year,
	sum(volume) as revenue
from
	(
		select
			n1.n_name as supp_nation,
			n2.n_name as cust_nation,
			extract(year from l_shipdate) as l_year,
			l_extendedprice * (1 - l_discount) as volume
		from
			supplier /*! force index (primary) */,
			lineitem /*! force index (primary) */,
			orders /*! force index (i_o_custkey) */,
			customer /*! force index (i_c_nationkey) */,
			nation n1 /*! force index (primary) */,
			nation n2 /*! ignore index (primary) */
		where
			s_suppkey = l_suppkey
			and o_orderkey = l_orderkey
			and c_custkey = o_custkey
			and s_nationkey = n1.n_nationkey
			and c_nationkey = n2.n_nationkey
			and (
				(n1.n_name = 'PERU' and n2.n_name = 'BRAZIL')
				or (n1.n_name = 'BRAZIL' and n2.n_name = 'PERU')
			)
			and l_shipdate between date '1995-01-01' and date '1996-12-31'
	) as shipping
group by
	supp_nation,
	cust_nation,
	l_year
order by
	supp_nation,
	cust_nation,
	l_year;
COMMIT;

