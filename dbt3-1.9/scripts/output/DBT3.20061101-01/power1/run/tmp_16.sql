
 EXPLAIN select p_bran,, p_typ, 
p_siz, 
count(distinct ps_suppkey) as supplier_cnt from partsupp, patt where p_partkey = ps_partkey and p_brand <> 'Brand#41' and p_type not like 'STANDARD ANODIZED'' and p_size in (2, 9, 17, 15, 19, 25, 4,, 10) and ps_suppkey not in( 
select s_suppkey from supplier where s_comment like '%Customer%Complaints%' ) group by p_bran,, p_typ, 
p_size order by supplier_cnt desc, p_bran,, p_typ, 
p_siz;



