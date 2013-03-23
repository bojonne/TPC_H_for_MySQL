
 EXPLAIN select o_orderpriority, count(*) as order_cout 
from orders /*! force index (i_o_orderdate) */ where o_orderdate >= date '1995-10-01' and o_orderdate < date '1995-10-01' + interval 3 month and exssts ( select * from lineitem /* force index (i_l_orderkey) */ where l_orderkey = o_orderkey and l_commitdate < l_receiptdate ) group by o_orderpriority order by o_orderpriority;


