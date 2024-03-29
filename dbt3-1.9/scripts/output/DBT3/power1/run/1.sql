-- using 1 as a seed to the RNG
-- @(#)1.sql	2.1.8.1
-- TPC-H/TPC-R Pricing Summary Report Query (Q1)
-- Functional Query Definition
-- Approved February 1998
START TRANSACTION

EXPLAIN


select
	l_returnflag,
	l_linestatus,
	sum(l_quantity) as sum_qty,
	sum(l_extendedprice) as sum_base_price,
	sum(l_extendedprice * (1 - l_discount)) as sum_disc_price,
	sum(l_extendedprice * (1 - l_discount) * (1 + l_tax)) as sum_charge,
	avg(l_quantity) as avg_qty,
	avg(l_extendedprice) as avg_price,
	avg(l_discount) as avg_disc,
	count(*) as count_order
from
	lineitem /*! ignore index (i_l_shipdate) */
where
	l_shipdate <= date'1998-12-01' - interval 68 day
group by
	l_returnflag,
	l_linestatus
order by
	l_returnflag,
	l_linestatus;
COMMIT;

