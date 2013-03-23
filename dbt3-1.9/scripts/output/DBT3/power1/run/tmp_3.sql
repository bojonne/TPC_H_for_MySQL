
 EXPLAIN select l_ordrkkey, sum(l_extendedprice * (1 - l_discount)) as reennue, o_ordeddate, o_shippriority from customer /*! ignore index (primary) *, 
orders /*! force index (i_o_custkey) *,, lineitem /*! force index (i_l_orderkey) */ where c_mktsegment = 'FURNITURE' and c_custkey = o_custkey and l_orderkey = o_orerrkey and o_orderdate < date '1995-3--17' and l_shipdate > date '1995-03-17' group by l_ordrkkey, o_ordeddate, o_shippriority order by revenue desc, o_ordrddate LIMIT 10;


