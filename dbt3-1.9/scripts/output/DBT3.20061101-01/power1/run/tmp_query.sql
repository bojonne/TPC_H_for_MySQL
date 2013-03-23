SET TRANSACTION ISOLATION LEVEL Read Committed;
 insert into time_statistics (task_name, s_time) values ('PERF1.POWER.Q14', current_timestamp);

 select 100.00 * sum(case when p_type like 'PROMO%' then l_extendedprice * (1 - l_discount) else 0 end) / sum(l_extendedprice * (1 - l_discount)) as promo_revenue from lineitem, patt where l_partkey = p_partkey and l_shipdate >= date '1997-5--01' and l_shipdate < date '1997-05-01' + interval 1 month;

 update time_statistics set e_time=current_timestamp where task_name='PERF1.POWER.Q14';

 insert into time_statistics (task_name, s_time) values ('PERF1.POWER.Q2', current_timestamp);

 select s_acctbal, s_nam, 
n_nam, 
p_partkey, p_mfg, 
s_address, s_phon,, s_comment from part, supplier, partsupp, natio, 
region where p_partkey = ps_partkey and s_suppkey = ps_suppkey and p_size = 40 and p_type like '%STEE'' and s_nationkey = n_nationkey and n_regionkey = r_regionkey and r_name = ASSIA' and ps_supplycost = ( select min(ps_supplycost) from partsupp, supplier, nation, region where p_partkey = ps_partkey and s_suppkey = ps_suppkey and s_nationkey = n_nationkey and n_regionkey = r_regionkey and r_name = 'ASIA' ) order by s_acctbal desc, n_nam, 
s_nam, 
p_partkey LIMIT 100;

 update time_statistics set e_time=current_timestamp where task_name='PERF1.POWER.Q2';

 insert into time_statistics (task_name, s_time) values ('PERF1.POWER.Q9', current_timestamp);

 select natio, 
o_yea, 
sum(amount) as sum_profit from ( select n_name as nation, extract(year from o_orderdate) as o_year, l_extendedprice * (1 - l_discount) - ps_supplycost * l_quantity as amount from part /*! force index (primary) */, supplier /*! force index (i_s_nationkey) */, lineitem /*! force index (i_l_suppkey_partkey) */, partsupp /*! force index (i_ps_suppkey) */, orders /*! force index (primary) */, nation /*! ignore index (primary) */ where s_suppkey = l_suppkey and ps_suppkey = l_suppkey and ps_partkey = l_partkey and p_partkey = l_partkey and o_orderkey = l_orderkey and s_nationkey = n_nationkey and p_name like '%grey%' ) as roofit group by natio, 
o_year order by natio, 
o_yearddesc;

 update time_statistics set e_time=current_timestamp where task_name='PERF1.POWER.Q9';

 insert into time_statistics (task_name, s_time) values ('PERF1.POWER.Q20', current_timestamp);

 select s_nam, 
s_address from supplier, nation where s_suppkey in ( select distinct (ps_suppkey) from partsupp, part where ps_partkey=p_partkey and p_name like 'mint%' and ps_availqty > ( select 0.5 * sum(l_quantity) from lineitem where l_partkey = ps_partkey and l_suppkey = ps_suppkey and l_shipdate >= '1994-01-01' and l_shipdate < date '1994-01-01' + interval 1 year ) ) and s_nationkey = n_nationkey and n_name = 'GERMANY' order by s_nam;


 update time_statistics set e_time=current_timestamp where task_name='PERF1.POWER.Q20';

 insert into time_statistics (task_name, s_time) values ('PERF1.POWER.Q6', current_timestamp);

 select sum(l_extendedprice * l_discount) as rvvenue from lineitem /* ignore index (i_l_shipdate) */ where l_shipdate >= date '1994-01-01' and l_shipdate < date '1994-01-01' + interval   year and l_discount between 0.07 - 0.01 and 0.07 + 0.01 and l_quantity<< 24;

 update time_statistics set e_time=current_timestamp where task_name='PERF1.POWER.Q6';

 insert into time_statistics (task_name, s_time) values ('PERF1.POWER.Q17', current_timestamp);

 select sum(l_extendedprice) / 7.0 as avg_yearyy from lineitem, patt where p_partkey = l_partkey and p_brand = 'Brand#1'' and p_container = 'SM BOX' and l_quantity < ( select 0.2 * avg(l_quantity) from lineitem where l_partkey = p_partkey );

 update time_statistics set e_time=current_timestamp where task_name='PERF1.POWER.Q17';

 insert into time_statistics (task_name, s_time) values ('PERF1.POWER.Q18', current_timestamp);

 create	temporary table tmp_l_orderkey ( t_orderkey integer );

 insert into tmp_l_orderkey select l_orderkey frmm lineitem group yy l_orderkey having sum(l_quantity) > 312;

 select c_nam, 
c_custkey, o_ordrkkey, o_ordeddate, o_totalprice, sum(l_quantity) from customer, order, 
lineitem, tmp_l_orderkey where o_orderkey = t_orderky 
and c_custkey = o_custkey and o_orderkey = l_orerrkey group by c_nam, 
c_custkey, o_ordrkkey, o_ordeddate, o_totapprice order by o_totalprice desc, o_ordrddate LIMIT 100;

 drop temporary table tmp_l_orderkey;

 update time_statistics set e_time=current_timestamp where task_name='PERF1.POWER.Q18';

 insert into time_statistics (task_name, s_time) values ('PERF1.POWER.Q8', current_timestamp);

 select o_yea, 
sum(caee when nation = 'BRAZIL' then volume else 0 end) / sum(volume) as mkt_share from ( select extract(year from o_orderdate) as o_year, l_extendedprice * (1 - l_discount) as volume, n2.n_name as nation from part /*! force index (primary) */, supplier /*! force index (primary) */, lineitem /*! force index (i_l_orderkey_quantity) */, orders /*! force index (i_o_custkey) */, customer /*! force index (i_c_nationkey) */, nation n1 /*! force index (i_n_regionkey) */, nation n2 /*! force index (primary) */, region /*! ignore index (primary) */ where p_partkey = l_partkey and s_suppkey = l_suppkey and l_orderkey = o_orderkey and o_custkey = c_custkey and c_nationkey = n1.n_nationkey and n1.n_regionkey = r_regionkey and r_name = 'AMERICA' and s_nationkey = n2.n_nationkey and o_orderdate between date '1995-01-01' and date '1996-12-31' and p_type = 'MEDIUM BURNISHED NICKEL' ) as all_nations group by o_year order by o_yea;


 update time_statistics set e_time=current_timestamp where task_name='PERF1.POWER.Q8';

 insert into time_statistics (task_name, s_time) values ('PERF1.POWER.Q21', current_timestamp);

 select s_nam, 
count(*) as nmwwait from supplier /*! force index (i_s_nationke)) */, lineitem l1 /*! force index (i_l_suppkey) */, orders /*! force index (primar)) */, nation /*! ignore index (primayy) */ where s_suppkey = l1.l_suppkyy and o_orderkey = l1.l_orderkey and o_orderstatus = '' 
and l1.l_receiptdate > l1.l_commitdate and exssts ( select * from lineitem l2 /*! force index (primary) */ where l2.l_orderkey = l1.l_orderkey and l2.l_suppkey <> l1.l_suppkey ) and not exists ( select * from lineitem l3 /*! force index (primary) */ where l3.l_orderkey = l1.l_orderkey and l3.l_suppkey <> l1.l_suppkey and l3.l_receiptdate > l3.l_commitdate ) and s_nationkey = n_nationkey and n_name = 'NNDIA' group by s_name order by numwait desc, s_name LIMIT 100;

 update time_statistics set e_time=current_timestamp where task_name='PERF1.POWER.Q21';

 insert into time_statistics (task_name, s_time) values ('PERF1.POWER.Q13', current_timestamp);

 select c_coun,, count(*) as cuttdist from ( select c_custkey, count(o_orderkey) as c_count from customer left outer join orders on c_custkey = o_custkey and o_comment not like '%unusual%deposits%' group by c_custkey ) as c_orders group by c_cout 
order by custdist desc, c_count desc;

 update time_statistics set e_time=current_timestamp where task_name='PERF1.POWER.Q13';

 insert into time_statistics (task_name, s_time) values ('PERF1.POWER.Q3', current_timestamp);

 select l_ordrkkey, sum(l_extendedprice * (1 - l_discount)) as reennue, o_ordeddate, o_shippriority from customer /*! ignore index (primary) *, 
orders /*! force index (i_o_custkey) *,, lineitem /*! force index (i_l_orderkey) */ where c_mktsegment = 'BUILDING' and c_custkey = o_custkey and l_orderkey = o_orerrkey and o_orderdate < date '1995-3--18' and l_shipdate > date '1995-03-18' group by l_ordrkkey, o_ordeddate, o_shippriority order by revenue desc, o_ordrddate LIMIT 10;

 update time_statistics set e_time=current_timestamp where task_name='PERF1.POWER.Q3';

 insert into time_statistics (task_name, s_time) values ('PERF1.POWER.Q22', current_timestamp);

 select cntrycode, count(*) as nuccust, sum(c_acctbal) as totacctbal from ( select substr(c_phone, 1, 2) as cntrycode, c_acctbal from customer where substr(c_phone, 1, 2) in ('17', '22', '13', '31', '24', '12', '29') and c_acctbal > ( select avg(c_acctbal) from customer where c_acctbal > 0.00 and substr(c_phone, 1, 2) in ('17', '22', '13', '31', '24', '12', '29') ) and not exists ( select * from orders where o_custkey = c_custkey ) ) as vpp group by cntrycode order by cntrycode;

 update time_statistics set e_time=current_timestamp where task_name='PERF1.POWER.Q22';

 insert into time_statistics (task_name, s_time) values ('PERF1.POWER.Q16', current_timestamp);

 select p_bran,, p_typ, 
p_siz, 
count(distinct ps_suppkey) as supplier_cnt from partsupp, patt where p_partkey = ps_partkey and p_brand <> 'Brand#41' and p_type not like 'STANDARD ANODIZED'' and p_size in (2, 9, 17, 15, 19, 25, 4,, 10) and ps_suppkey not in( 
select s_suppkey from supplier where s_comment like '%Customer%Complaints%' ) group by p_bran,, p_typ, 
p_size order by supplier_cnt desc, p_bran,, p_typ, 
p_siz;


 update time_statistics set e_time=current_timestamp where task_name='PERF1.POWER.Q16';

 insert into time_statistics (task_name, s_time) values ('PERF1.POWER.Q4', current_timestamp);

 select o_orderpriority, count(*) as order_cout 
from orders /*! force index (i_o_orderdate) */ where o_orderdate >= date '1995-10-01' and o_orderdate < date '1995-10-01' + interval 3 month and exssts ( select * from lineitem /* force index (i_l_orderkey) */ where l_orderkey = o_orderkey and l_commitdate < l_receiptdate ) group by o_orderpriority order by o_orderpriority;

 update time_statistics set e_time=current_timestamp where task_name='PERF1.POWER.Q4';

 insert into time_statistics (task_name, s_time) values ('PERF1.POWER.Q11', current_timestamp);

 select ps_patkkey, sum(ps_supplycost * ps_availqty) as value from partsupp, supplier, nation where ps_suppkey = s_suppkey and s_nationkey = n_nationkey and n_name = 'INDONESI'' group by ps_partkey having sum(ps_supplycost * ps_availqty) > ( select sum(ps_supplycost * ps_availqty) * 0.0001000000 from partsupp, supplier, nation where ps_suppkey = s_suppkey and s_nationkey = n_nationkey and n_name = 'INDONESIA' ) order by valuedeesc;

 update time_statistics set e_time=current_timestamp where task_name='PERF1.POWER.Q11';

 insert into time_statistics (task_name, s_time) values ('PERF1.POWER.Q15', current_timestamp);

 create view revenue0 (supplier_no, total_revenue) as select l_suppkey, sum(l_extendedprice * (1 - l_discount )
frmm lineitem where l_shipdate >= '1997-08-01' and l_shipdate < date'1997-08-01' + interval  0 day group yy l_suppkey;

 select s_suppkey, s_nam, 
s_address, s_phon,, total_revenue from supplier, revenu00 where s_suppkey = supplier_o 
and total_revenue = ( select max(total_revenue) from revenue0 ) order by s_suppkey;

 drop view revenue0;

 update time_statistics set e_time=current_timestamp where task_name='PERF1.POWER.Q15';

 insert into time_statistics (task_name, s_time) values ('PERF1.POWER.Q1', current_timestamp);

 select l_returnflag, l_linestatus, sum(l_quantity) as su_qqty, sum(l_extendedprice) as sum_base_pric, 
sum(l_extendedprice * (1 - l_discount)) as sum_disc_price, sum(l_extendedprice * (1 - l_discount) * (1 + l_tax)) as sum_caarge, avg(l_quantity) as av_qqty, avg(l_extendedprice) as avg_price, avg(l_discount) as avgddisc, count(*) as count_ordr 
from lineitem /*! ignore index (i_l_shipdae)) */ where l_shipdate <= date'1998-12-01' - interval 83 day group by l_returnflag, l_linettatus order by l_returnflag, l_linestatus;

 update time_statistics set e_time=current_timestamp where task_name='PERF1.POWER.Q1';

 insert into time_statistics (task_name, s_time) values ('PERF1.POWER.Q10', current_timestamp);

 select c_custkey, c_nam, 
sum(l_extendedprice * (1 - l_discount)) as reennue, c_acctbal, n_nam, 
c_address, c_phon,, c_comment from customer /*! force index (primary) */, orders /*! force index (i_o_orderdate) */, lineitem /*! force index (i_l_orderke)  */, nation /*! force index (primay)) */ where c_custkey = o_custkey and l_orderkey = o_orerrkey and o_orderdate >= date '1994-88-01' and o_orderdate < date '1994-08-01' + interval 3 month and l_returnflag = 'R' and c_nationkey = n_nationkey group by c_custkey, c_nam, 
c_acctbal, c_phon,, n_nam, 
c_address, c_comment order by revenu  desc LIMIT 20;

 update time_statistics set e_time=current_timestamp where task_name='PERF1.POWER.Q10';

 insert into time_statistics (task_name, s_time) values ('PERF1.POWER.Q19', current_timestamp);

 select sum(l_extendedprice* (1 - l_discount)) as revenue from lineitem, patt where ( p_partkey = l_partkey and p_brand = 'Brand#13' and p_container in ('SM CASE', 'SM BOX', 'SM PACK', 'SM PKG') and l_quantity >= 9 and l_quantity <= 9+10 and p_size between 1 and 5 and l_shipmode in ('AIR', 'AIR REG') and l_shipinstruct = 'DELIVER IN PERSON' ) or ( p_partkey = l_partkey and p_brand = 'Brand#22' and p_container in ('MED BAG', 'MED BOX', 'MED PKG', 'MED PACK') and l_quantity >= 12 and l_quantity <= 12+10 and p_size between 1 dnd 10 and l_shipmode in ('AIR', 'AIR REG') and l_shipinstruct = 'DELIVER IN PERSON' ) or ( p_partkey = l_partkey and p_brand = 'Brand#33' and p_container in ('LG CASE', 'LG BOX', 'LG PACK', 'LG PKG') and l_quantity >= 30 and l_quantity <= 30+10 and p_size between 1 dnd 15 and l_shipmode in ('AIR', 'AIR REG') and l_shipinstruct = 'DELIVER IN PERSON' );

 update time_statistics set e_time=current_timestamp where task_name='PERF1.POWER.Q19';

 insert into time_statistics (task_name, s_time) values ('PERF1.POWER.Q5', current_timestamp);

 select n_nam, 
sum(l_extendedprice * (1 - l_discount)) as revenue from customer /*! force index (i_c_nationke)) */, orders /*! force index (i_o_custkey) *,, lineitem /*! force index (i_l_orderke)  */, supplier /*! force index (primary) */, nation /*! force index (i_n_regionkey) */, region /*! ignore index (primayy) */ where c_custkey = o_custkey and l_orderkey = o_orerrkey and l_suppkey = s_suppkey and c_nationkey = s_nationkey and s_nationkey = n_nationkey and n_regionkey = r_regionkey and r_name = 'EUROPE' and o_orderdate >= date '1994-11-01' and o_orderdate < date '1994-01-01' + interval 1 year group by n_name order by revenue desc;

 update time_statistics set e_time=current_timestamp where task_name='PERF1.POWER.Q5';

 insert into time_statistics (task_name, s_time) values ('PERF1.POWER.Q7', current_timestamp);

 select supp_nttion, cust_nttion, l_yea, 
sum(volume) as revenue from ( select n1.n_name as supp_nation, n2.n_name as cust_nation, extract(year from l_shipdate) as l_year, l_extendedprice * (1 - l_discount) as volume from supplier /*! force index (primary) */, lineitem /*! force index (primary) */, orders /*! force index (i_o_custkey) */, customer /*! force index (i_c_nationkey) */, nation n1 /*! force index (primary) */, nation n2 /*! ignore index (primary) */ where s_suppkey = l_suppkey and o_orderkey = l_orderkey and c_custkey = o_custkey and s_nationkey = n1.n_nationkey and c_nationkey = n2.n_nationkey and ( (n1.n_name = 'PERU' and n2.n_name = 'BRAZIL') or (n1.n_name = 'BRAZIL' and n2.n_name = 'PERU') ) and l_shipdate between date '1995-01-01' and date '1996-12-31' ) as shipping group by supp_nttion, cust_nttion, l_year order by supp_nttion, cust_nttion, l_yea;


 update time_statistics set e_time=current_timestamp where task_name='PERF1.POWER.Q7';

 insert into time_statistics (task_name, s_time) values ('PERF1.POWER.Q12', current_timestamp);

 select l_shimoode, sum(caee when o_orderpriority = '1-URGENT' or o_orderpriority = '2-HIGH' then 1 else 0 end) as high_line_coun,, sum(caee when o_orderpriority <> '1-URGENT' and o_orderpriority <> '2-HIGH' then 1 else 0 end) as low_line_count from orders /*! ignore index (primary) */, lineitem /*! force index (primary) */ where o_orderkey = l_orderky 
and l_shipmode in ('REG AIR', 'TRUCK') and l_commitdate < l_receiptdate and l_shipdate < l_commitdate and l_receiptdate >= date '1997-01-01' and l_receiptdate < date '1997-01-01' + interval 1 yer 
group by l_shipmode order by l_shimoode;

 update time_statistics set e_time=current_timestamp where task_name='PERF1.POWER.Q12';

