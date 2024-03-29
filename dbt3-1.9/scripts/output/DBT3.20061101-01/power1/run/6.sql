-- using 205164841 as a seed to the RNG
-- @(#)6.sql	2.1.8.1
-- TPC-H/TPC-R Forecasting Revenue Change Query (Q6)
-- Functional Query Definition
-- Approved February 1998
START TRANSACTION

EXPLAIN


select
	sum(l_extendedprice * l_discount) as revenue
from
	lineitem /* ignore index (i_l_shipdate) */
where
	l_shipdate >= date '1994-01-01'
	and l_shipdate < date '1994-01-01' + interval 1 year
	and l_discount between 0.07 - 0.01 and 0.07 + 0.01
	and l_quantity < 24;
COMMIT;

