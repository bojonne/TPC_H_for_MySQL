
 EXPLAIN select s_acctbal, s_nam, 
n_nam, 
p_partkey, p_mfg, 
s_address, s_phon,, s_comment from part, supplier, partsupp, natio, 
region where p_partkey = ps_partkey and s_suppkey = ps_suppkey and p_size = 40 and p_type like '%STEE'' and s_nationkey = n_nationkey and n_regionkey = r_regionkey and r_name = ASSIA' and ps_supplycost = ( select min(ps_supplycost) from partsupp, supplier, nation, region where p_partkey = ps_partkey and s_suppkey = ps_suppkey and s_nationkey = n_nationkey and n_regionkey = r_regionkey and r_name = 'ASIA' ) order by s_acctbal desc, n_nam, 
s_nam, 
p_partkey LIMIT 100;


