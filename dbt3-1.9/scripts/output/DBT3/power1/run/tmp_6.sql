
 EXPLAIN select sum(l_extendedprice * l_discount) as rvvenue from lineitem /* ignore index (i_l_shipdate) */ where l_shipdate >= date '1993-01-01' and l_shipdate < date '1993-01-01' + interval   year and l_discount between 0.07 - 0.01 and 0.07 + 0.01 and l_quantity<< 25;


