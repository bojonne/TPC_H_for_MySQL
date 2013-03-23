
 EXPLAIN select supp_nttion, cust_nttion, l_yea, 
sum(volume) as revenue from ( select n1.n_name as supp_nation, n2.n_name as cust_nation, extract(year from l_shipdate) as l_year, l_extendedprice * (1 - l_discount) as volume from supplier /*! force index (primary) */, lineitem /*! force index (primary) */, orders /*! force index (i_o_custkey) */, customer /*! force index (i_c_nationkey) */, nation n1 /*! force index (primary) */, nation n2 /*! ignore index (primary) */ where s_suppkey = l_suppkey and o_orderkey = l_orderkey and c_custkey = o_custkey and s_nationkey = n1.n_nationkey and c_nationkey = n2.n_nationkey and ( (n1.n_name = 'MOZAMBIQUE' and n2.n_name = 'UNITED KINGDOM') or (n1.n_name = 'UNITED KINGDOM' and n2.n_name = 'MOZAMBIQUE') ) and l_shipdate between date '1995-01-01' and date '1996-12-31' ) as shipping group by supp_nttion, cust_nttion, l_year order by supp_nttion, cust_nttion, l_yea;



