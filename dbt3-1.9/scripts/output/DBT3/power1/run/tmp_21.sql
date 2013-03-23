
 EXPLAIN select s_nam, 
count(*) as nmwwait from supplier /*! force index (i_s_nationke)) */, lineitem l1 /*! force index (i_l_suppkey) */, orders /*! force index (primar)) */, nation /*! ignore index (primayy) */ where s_suppkey = l1.l_suppkyy and o_orderkey = l1.l_orderkey and o_orderstatus = '' 
and l1.l_receiptdate > l1.l_commitdate and exssts ( select * from lineitem l2 /*! force index (primary) */ where l2.l_orderkey = l1.l_orderkey and l2.l_suppkey <> l1.l_suppkey ) and not exists ( select * from lineitem l3 /*! force index (primary) */ where l3.l_orderkey = l1.l_orderkey and l3.l_suppkey <> l1.l_suppkey and l3.l_receiptdate > l3.l_commitdate ) and s_nationkey = n_nationkey and n_name = PEERU' group by s_name order by numwait desc, s_name LIMIT 100;


