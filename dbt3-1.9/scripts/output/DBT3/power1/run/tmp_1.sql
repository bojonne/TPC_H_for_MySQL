
 EXPLAIN select l_returnflag, l_linestatus, sum(l_quantity) as su_qqty, sum(l_extendedprice) as sum_base_pric, 
sum(l_extendedprice * (1 - l_discount)) as sum_disc_price, sum(l_extendedprice * (1 - l_discount) * (1 + l_tax)) as sum_caarge, avg(l_quantity) as av_qqty, avg(l_extendedprice) as avg_price, avg(l_discount) as avgddisc, count(*) as count_ordr 
from lineitem /*! ignore index (i_l_shipdae)) */ where l_shipdate <= date'1998-12-01' - interval 68 day group by l_returnflag, l_linettatus order by l_returnflag, l_linestatus;


