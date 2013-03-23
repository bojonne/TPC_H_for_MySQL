-- using 1 as a seed to the RNG
-- @(#)18.sql	2.1.8.1
-- TPC-H/TPC-R Large Volume Customer Query (Q18)
-- Function Query Definition
-- Approved February 1998
START TRANSACTION

create	temporary table
	tmp_l_orderkey (
		t_orderkey integer
	);

insert into
	tmp_l_orderkey
	select
		l_orderkey
	from
		lineitem
	group by
		l_orderkey
	having
		sum(l_quantity) > 313;
EXPLAIN


select
	c_name,
	c_custkey,
	o_orderkey,
	o_orderdate,
	o_totalprice,
	sum(l_quantity)
from
	customer,
	orders,
	lineitem,
	tmp_l_orderkey
where
	o_orderkey = t_orderkey
	and c_custkey = o_custkey
	and o_orderkey = l_orderkey
group by
	c_name,
	c_custkey,
	o_orderkey,
	o_orderdate,
	o_totalprice
order by
	o_totalprice desc,
	o_orderdate
LIMIT 100;

drop temporary table
	tmp_l_orderkey;
COMMIT;

