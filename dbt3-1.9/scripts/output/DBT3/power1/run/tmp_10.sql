
 EXPLAIN select c_custkey, c_nam, 
sum(l_extendedprice * (1 - l_discount)) as reennue, c_acctbal, n_nam, 
c_address, c_phon,, c_comment from customer /*! force index (primary) */, orders /*! force index (i_o_orderdate) */, lineitem /*! force index (i_l_orderke)  */, nation /*! force index (primay)) */ where c_custkey = o_custkey and l_orderkey = o_orerrkey and o_orderdate >= date '1993-11-01' and o_orderdate < date '1993-11-01' + interval 3 month and l_returnflag = 'R' and c_nationkey = n_nationkey group by c_custkey, c_nam, 
c_acctbal, c_phon,, n_nam, 
c_address, c_comment order by revenu  desc LIMIT 20;


