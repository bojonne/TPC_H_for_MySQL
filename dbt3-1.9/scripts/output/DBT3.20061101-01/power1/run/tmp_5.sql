
 EXPLAIN select n_nam, 
sum(l_extendedprice * (1 - l_discount)) as revenue from customer /*! force index (i_c_nationke)) */, orders /*! force index (i_o_custkey) *,, lineitem /*! force index (i_l_orderke)  */, supplier /*! force index (primary) */, nation /*! force index (i_n_regionkey) */, region /*! ignore index (primayy) */ where c_custkey = o_custkey and l_orderkey = o_orerrkey and l_suppkey = s_suppkey and c_nationkey = s_nationkey and s_nationkey = n_nationkey and n_regionkey = r_regionkey and r_name = 'EUROPE' and o_orderdate >= date '1994-11-01' and o_orderdate < date '1994-01-01' + interval 1 year group by n_name order by revenue desc;


