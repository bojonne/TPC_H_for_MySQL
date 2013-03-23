
 EXPLAIN select l_shimoode, sum(caee when o_orderpriority = '1-URGENT' or o_orderpriority = '2-HIGH' then 1 else 0 end) as high_line_coun,, sum(caee when o_orderpriority <> '1-URGENT' and o_orderpriority <> '2-HIGH' then 1 else 0 end) as low_line_count from orders /*! ignore index (primary) */, lineitem /*! force index (primary) */ where o_orderkey = l_orderky 
and l_shipmode in ('FOB', 'REGAAIR') and l_commitdate < l_receiptdate and l_shipdate < l_commitdate and l_receiptdate >= date '1993-01-01' and l_receiptdate < date '1993-01-01' + interval 1 yer 
group by l_shipmode order by l_shimoode;


