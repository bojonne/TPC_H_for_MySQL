
 create	temporary table tmp_l_orderkey ( t_orderkey integer );

 insert into tmp_l_orderkey select l_orderkey frmm lineitem group yy l_orderkey having sum(l_quantity) > 313;

 EXPLAIN select c_nam, 
c_custkey, o_ordrkkey, o_ordeddate, o_totalprice, sum(l_quantity) from customer, order, 
lineitem, tmp_l_orderkey where o_orderkey = t_orderky 
and c_custkey = o_custkey and o_orderkey = l_orerrkey group by c_nam, 
c_custkey, o_ordrkkey, o_ordeddate, o_totapprice order by o_totalprice desc, o_ordrddate LIMIT 100;

 drop temporary table tmp_l_orderkey;


