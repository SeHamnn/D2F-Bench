use dfs.tmp;

drop table if exists q4_order_priority_tmp;
CREATE TABLE q4_order_priority_tmp (O_ORDERKEY) as 
select 
  DISTINCT l_orderkey 
from 
  DATABASE.lineitem 
where 
  l_commitdate < l_receiptdate;


drop table if exists q4_order_priority;
CREATE TABLE q4_order_priority (O_ORDERPRIORITY, ORDER_COUNT) as
select 
	o.o_orderpriority, 
	count(1) as order_count 
from 
  DATABASE.orders o join q4_order_priority_tmp t 
  on 
o.o_orderkey = t.o_orderkey 
and o.o_orderdate >= '1996-05-01' 
and o.o_orderdate < '1996-08-01' 
group by o.o_orderpriority 
order by o.o_orderpriority;