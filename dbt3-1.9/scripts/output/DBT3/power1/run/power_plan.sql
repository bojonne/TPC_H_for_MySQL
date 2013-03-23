-- using 1 as a seed to the RNG
-- @(#)14.sql	2.1.8.1
-- TPC-H/TPC-R Promotion Effect Query (Q14)
-- Functional Query Definition
-- Approved February 1998
START TRANSACTION

EXPLAIN


select
	100.00 * sum(case
		when p_type like 'PROMO%'
			then l_extendedprice * (1 - l_discount)
		else 0
	end) / sum(l_extendedprice * (1 - l_discount)) as promo_revenue
from
	lineitem,
	part
where
	l_partkey = p_partkey
	and l_shipdate >= date '1993-05-01'
	and l_shipdate < date '1993-05-01' + interval 1 month;
COMMIT;

-- @(#)2.sql	2.1.8.2
-- TPC-H/TPC-R Minimum Cost Supplier Query (Q2)
-- Functional Query Definition
-- Approved February 1998
START TRANSACTION

EXPLAIN


select
	s_acctbal,
	s_name,
	n_name,
	p_partkey,
	p_mfgr,
	s_address,
	s_phone,
	s_comment
from
	part,
	supplier,
	partsupp,
	nation,
	region
where
	p_partkey = ps_partkey
	and s_suppkey = ps_suppkey
	and p_size = 38
	and p_type like '%STEEL'
	and s_nationkey = n_nationkey
	and n_regionkey = r_regionkey
	and r_name = 'ASIA'
	and ps_supplycost = (
		select
			min(ps_supplycost)
		from
			partsupp,
			supplier,
			nation,
			region
		where
			p_partkey = ps_partkey
			and s_suppkey = ps_suppkey
			and s_nationkey = n_nationkey
			and n_regionkey = r_regionkey
			and r_name = 'ASIA'
	)
order by
	s_acctbal desc,
	n_name,
	s_name,
	p_partkey
LIMIT 100;
COMMIT;

-- @(#)9.sql	2.1.8.1
-- TPC-H/TPC-R Product Type Profit Measure Query (Q9)
-- Functional Query Definition
-- Approved February 1998
START TRANSACTION

EXPLAIN


select
	nation,
	o_year,
	sum(amount) as sum_profit
from
	(
		select
			n_name as nation,
			extract(year from o_orderdate) as o_year,
			l_extendedprice * (1 - l_discount) - ps_supplycost * l_quantity as amount
		from
			part /*! force index (primary) */,
			supplier /*! force index (i_s_nationkey) */,
			lineitem /*! force index (i_l_suppkey_partkey) */,
			partsupp /*! force index (i_ps_suppkey) */,
			orders /*! force index (primary) */,
			nation /*! ignore index (primary) */
		where
			s_suppkey = l_suppkey
			and ps_suppkey = l_suppkey
			and ps_partkey = l_partkey
			and p_partkey = l_partkey
			and o_orderkey = l_orderkey
			and s_nationkey = n_nationkey
			and p_name like '%thistle%'
	) as profit
group by
	nation,
	o_year
order by
	nation,
	o_year desc;
COMMIT;

-- @(#)20.sql	2.1.8.1
-- TPC-H/TPC-R Potential Part Promotion Query (Q20)
-- Function Query Definition
-- Approved February 1998
START TRANSACTION

EXPLAIN


select
	s_name,
	s_address
from
	supplier,
	nation
where
	s_suppkey in (
		select
			distinct (ps_suppkey)
		from
			partsupp,
			part
		where
			ps_partkey=p_partkey
			and p_name like 'ivory%'
			and ps_availqty > (
				select
					0.5 * sum(l_quantity)
				from
					lineitem
				where
					l_partkey = ps_partkey
					and l_suppkey = ps_suppkey
					and l_shipdate >= '1996-01-01'
					and l_shipdate < date '1996-01-01' + interval 1 year
			)
	)
	and s_nationkey = n_nationkey
	and n_name = 'KENYA'
order by
	s_name;
COMMIT;

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
	l_shipdate >= date '1993-01-01'
	and l_shipdate < date '1993-01-01' + interval 1 year
	and l_discount between 0.07 - 0.01 and 0.07 + 0.01
	and l_quantity < 25;
COMMIT;

-- @(#)17.sql	2.1.8.1
-- TPC-H/TPC-R Small-Quantity-Order Revenue Query (Q17)
-- Functional Query Definition
-- Approved February 1998
START TRANSACTION

EXPLAIN


select
	sum(l_extendedprice) / 7.0 as avg_yearly
from
	lineitem,
	part
where
	p_partkey = l_partkey
	and p_brand = 'Brand#12'
	and p_container = 'SM BAG'
	and l_quantity < (
		select
			0.2 * avg(l_quantity)
		from
			lineitem
		where
			l_partkey = p_partkey
	);
COMMIT;

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

-- @(#)8.sql	2.1.8.1
-- TPC-H/TPC-R National Market Share Query (Q8)
-- Functional Query Definition
-- Approved February 1998
START TRANSACTION

EXPLAIN


select
	o_year,
	sum(case
		when nation = 'MOZAMBIQUE' then volume
		else 0
	end) / sum(volume) as mkt_share
from
	(
		select
			extract(year from o_orderdate) as o_year,
			l_extendedprice * (1 - l_discount) as volume,
			n2.n_name as nation
		from
			part /*! force index (primary) */,
			supplier /*! force index (primary) */,
			lineitem /*! force index (i_l_orderkey_quantity) */,
			orders /*! force index (i_o_custkey) */,
			customer /*! force index (i_c_nationkey) */,
			nation n1 /*! force index (i_n_regionkey) */,
			nation n2 /*! force index (primary) */,
			region /*! ignore index (primary) */
		where
			p_partkey = l_partkey
			and s_suppkey = l_suppkey
			and l_orderkey = o_orderkey
			and o_custkey = c_custkey
			and c_nationkey = n1.n_nationkey
			and n1.n_regionkey = r_regionkey
			and r_name = 'AFRICA'
			and s_nationkey = n2.n_nationkey
			and o_orderdate between date '1995-01-01' and date '1996-12-31'
			and p_type = 'PROMO POLISHED TIN'
	) as all_nations
group by
	o_year
order by
	o_year;
COMMIT;

-- @(#)21.sql	2.1.8.1
-- TPC-H/TPC-R Suppliers Who Kept Orders Waiting Query (Q21)
-- Functional Query Definition
-- Approved February 1998
START TRANSACTION

EXPLAIN


select
	s_name,
	count(*) as numwait
from
	supplier /*! force index (i_s_nationkey) */,
	lineitem l1 /*! force index (i_l_suppkey) */,
	orders /*! force index (primary) */,
	nation /*! ignore index (primary) */
where
	s_suppkey = l1.l_suppkey
	and o_orderkey = l1.l_orderkey
	and o_orderstatus = 'F'
	and l1.l_receiptdate > l1.l_commitdate
	and exists (
		select
			*
		from
			lineitem l2 /*! force index (primary) */
		where
			l2.l_orderkey = l1.l_orderkey
			and l2.l_suppkey <> l1.l_suppkey
	)
	and not exists (
		select
			*
		from
			lineitem l3 /*! force index (primary) */
		where
			l3.l_orderkey = l1.l_orderkey
			and l3.l_suppkey <> l1.l_suppkey
			and l3.l_receiptdate > l3.l_commitdate
	)
	and s_nationkey = n_nationkey
	and n_name = 'PERU'
group by
	s_name
order by
	numwait desc,
	s_name
LIMIT 100;
COMMIT;

-- @(#)13.sql	2.1.8.1
-- TPC-H/TPC-R Customer Distribution Query (Q13)
-- Functional Query Definition
-- Approved February 1998
START TRANSACTION

EXPLAIN


select
	c_count,
	count(*) as custdist
from
	(
		select
			c_custkey,
			count(o_orderkey) as c_count
		from
			customer left outer join orders on
				c_custkey = o_custkey
				and o_comment not like '%special%packages%'
		group by
			c_custkey
	) as c_orders
group by
	c_count
order by
	custdist desc,
	c_count desc;
COMMIT;

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
	c_mktsegment = 'FURNITURE'
	and c_custkey = o_custkey
	and l_orderkey = o_orderkey
	and o_orderdate < date '1995-03-17'
	and l_shipdate > date '1995-03-17'
group by
	l_orderkey,
	o_orderdate,
	o_shippriority
order by
	revenue desc,
	o_orderdate
LIMIT 10;
COMMIT;

-- @(#)22.sql	2.1.8.1
-- TPC-H/TPC-R Global Sales Opportunity Query (Q22)
-- Functional Query Definition
-- Approved February 1998
START TRANSACTION

EXPLAIN


select
	cntrycode,
	count(*) as numcust,
	sum(c_acctbal) as totacctbal
from
	(
		select
			substr(c_phone, 1, 2) as cntrycode,
			c_acctbal
		from
			customer
		where
			substr(c_phone, 1, 2) in
				('24', '11', '14', '23', '31', '26', '10')
			and c_acctbal > (
				select
					avg(c_acctbal)
				from
					customer
				where
					c_acctbal > 0.00
					and substr(c_phone, 1, 2) in
						('24', '11', '14', '23', '31', '26', '10')
			)
			and not exists (
				select
					*
				from
					orders
				where
					o_custkey = c_custkey
			)
	) as vip
group by
	cntrycode
order by
	cntrycode;
COMMIT;

-- @(#)16.sql	2.1.8.1
-- TPC-H/TPC-R Parts/Supplier Relationship Query (Q16)
-- Functional Query Definition
-- Approved February 1998
START TRANSACTION

EXPLAIN


select
	p_brand,
	p_type,
	p_size,
	count(distinct ps_suppkey) as supplier_cnt
from
	partsupp,
	part
where
	p_partkey = ps_partkey
	and p_brand <> 'Brand#41'
	and p_type not like 'MEDIUM BURNISHED%'
	and p_size in (4, 21, 15, 41, 49, 43, 27, 47)
	and ps_suppkey not in (
		select
			s_suppkey
		from
			supplier
		where
			s_comment like '%Customer%Complaints%'
	)
group by
	p_brand,
	p_type,
	p_size
order by
	supplier_cnt desc,
	p_brand,
	p_type,
	p_size;
COMMIT;

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

-- @(#)11.sql	2.1.8.1
-- TPC-H/TPC-R Important Stock Identification Query (Q11)
-- Functional Query Definition
-- Approved February 1998
START TRANSACTION

EXPLAIN


select
	ps_partkey,
	sum(ps_supplycost * ps_availqty) as value
from
	partsupp,
	supplier,
	nation
where
	ps_suppkey = s_suppkey
	and s_nationkey = n_nationkey
	and n_name = 'JAPAN'
group by
	ps_partkey having
		sum(ps_supplycost * ps_availqty) > (
			select
				sum(ps_supplycost * ps_availqty) * 0.0001000000
			from
				partsupp,
				supplier,
				nation
			where
				ps_suppkey = s_suppkey
				and s_nationkey = n_nationkey
				and n_name = 'JAPAN'
		)
order by
	value desc;
COMMIT;

-- @(#)15.sql	2.1.8.1
-- TPC-H/TPC-R Top Supplier Query (Q15)
-- Functional Query Definition
-- Approved February 1998
START TRANSACTION

create view revenue0 (supplier_no, total_revenue) as
	select
		l_suppkey,
		sum(l_extendedprice * (1 - l_discount))
	from
		lineitem
	where
		l_shipdate >= '1995-08-01'
		and l_shipdate < date'1995-08-01' + interval 90 day
	group by
		l_suppkey;

EXPLAIN


select
	s_suppkey,
	s_name,
	s_address,
	s_phone,
	total_revenue
from
	supplier,
	revenue0
where
	s_suppkey = supplier_no
	and total_revenue = (
		select
			max(total_revenue)
		from
			revenue0
	)
order by
	s_suppkey;

drop view revenue0;
COMMIT;

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
	and o_orderdate >= date '1993-11-01'
	and o_orderdate < date '1993-11-01' + interval 3 month
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

-- @(#)19.sql	2.1.8.1
-- TPC-H/TPC-R Discounted Revenue Query (Q19)
-- Functional Query Definition
-- Approved February 1998
START TRANSACTION

EXPLAIN


select
	sum(l_extendedprice* (1 - l_discount)) as revenue
from
	lineitem,
	part
where
	(
		p_partkey = l_partkey
		and p_brand = 'Brand#13'
		and p_container in ('SM CASE', 'SM BOX', 'SM PACK', 'SM PKG')
		and l_quantity >= 6 and l_quantity <= 6+10
		and p_size between 1 and 5
		and l_shipmode in ('AIR', 'AIR REG')
		and l_shipinstruct = 'DELIVER IN PERSON'
	)
	or
	(
		p_partkey = l_partkey
		and p_brand = 'Brand#43'
		and p_container in ('MED BAG', 'MED BOX', 'MED PKG', 'MED PACK')
		and l_quantity >= 11 and l_quantity <= 11+10
		and p_size between 1 and 10
		and l_shipmode in ('AIR', 'AIR REG')
		and l_shipinstruct = 'DELIVER IN PERSON'
	)
	or
	(
		p_partkey = l_partkey
		and p_brand = 'Brand#55'
		and p_container in ('LG CASE', 'LG BOX', 'LG PACK', 'LG PKG')
		and l_quantity >= 27 and l_quantity <= 27+10
		and p_size between 1 and 15
		and l_shipmode in ('AIR', 'AIR REG')
		and l_shipinstruct = 'DELIVER IN PERSON'
	);
COMMIT;

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
	and r_name = 'AMERICA'
	and o_orderdate >= date '1993-01-01'
	and o_orderdate < date '1993-01-01' + interval 1 year
group by
	n_name
order by
	revenue desc;
COMMIT;

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
				(n1.n_name = 'MOZAMBIQUE' and n2.n_name = 'UNITED KINGDOM')
				or (n1.n_name = 'UNITED KINGDOM' and n2.n_name = 'MOZAMBIQUE')
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

-- @(#)12.sql	2.1.8.1
-- TPC-H/TPC-R Shipping Modes and Order Priority Query (Q12)
-- Functional Query Definition
-- Approved February 1998
START TRANSACTION

EXPLAIN


select
	l_shipmode,
	sum(case
		when o_orderpriority = '1-URGENT'
			or o_orderpriority = '2-HIGH'
			then 1
		else 0
	end) as high_line_count,
	sum(case
		when o_orderpriority <> '1-URGENT'
			and o_orderpriority <> '2-HIGH'
			then 1
		else 0
	end) as low_line_count
from
	orders /*! ignore index (primary) */,
	lineitem /*! force index (primary) */
where
	o_orderkey = l_orderkey
	and l_shipmode in ('FOB', 'REG AIR')
	and l_commitdate < l_receiptdate
	and l_shipdate < l_commitdate
	and l_receiptdate >= date '1993-01-01'
	and l_receiptdate < date '1993-01-01' + interval 1 year
group by
	l_shipmode
order by
	l_shipmode;
COMMIT;

