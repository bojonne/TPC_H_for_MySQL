-- using 1 as a seed to the RNG
-- @(#)4.sql	2.1.8.1
-- TPC-H/TPC-R Order Priority Checking Query (Q4)
-- Functional Query Definition
-- Approved February 1998
START TRANSACTION

EXPLAIN


select
	o_orderpriority,
	count(*) as order_count
from
	orders /*! force index (i_o_orderdate) */
where
	o_orderdate >= date '1995-08-01'
	and o_orderdate < date '1995-08-01' + interval 3 month
	and exists (
		select
			*
		from
			lineitem /* force index (i_l_orderkey) */
		where
			l_orderkey = o_orderkey
			and l_commitdate < l_receiptdate
	)
group by
	o_orderpriority
order by
	o_orderpriority;
COMMIT;

