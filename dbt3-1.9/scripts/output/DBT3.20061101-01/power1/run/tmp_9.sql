
 EXPLAIN select natio, 
o_yea, 
sum(amount) as sum_profit from ( select n_name as nation, extract(year from o_orderdate) as o_year, l_extendedprice * (1 - l_discount) - ps_supplycost * l_quantity as amount from part /*! force index (primary) */, supplier /*! force index (i_s_nationkey) */, lineitem /*! force index (i_l_suppkey_partkey) */, partsupp /*! force index (i_ps_suppkey) */, orders /*! force index (primary) */, nation /*! ignore index (primary) */ where s_suppkey = l_suppkey and ps_suppkey = l_suppkey and ps_partkey = l_partkey and p_partkey = l_partkey and o_orderkey = l_orderkey and s_nationkey = n_nationkey and p_name like '%grey%' ) as roofit group by natio, 
o_year order by natio, 
o_yearddesc;


