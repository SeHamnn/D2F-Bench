
orders = load '$input/orders' USING 
OrcStorage() as (o_orderkey:long, o_custkey:long, o_orderstatus:chararray, o_totalprice:double, o_orderdate:chararray, o_orderpriority:chararray, o_clerk:chararray, o_shippriority:long, o_comment:chararray);

lineitem = load '$input/lineitem' USING 
OrcStorage() as (l_orderkey:long, l_partkey:long, l_suppkey:long, l_linenumber:long, l_quantity:double, l_extendedprice:double, l_discount:double, l_tax:double, l_returnflag:chararray, l_linestatus:chararray, l_shipdate:chararray, l_commitdate:chararray, l_receiptdate:chararray,l_shippingstruct:chararray, l_shipmode:chararray, l_comment:chararray);

flineitem = FILTER lineitem BY l_shipmode MATCHES 'MAIL|REG AIR' AND
                   l_commitdate < l_receiptdate AND l_shipdate < l_commitdate AND
                   l_receiptdate >= '1995-01-01' AND l_receiptdate < '1996-01-01';

l1 = JOIN flineitem BY l_orderkey, orders by o_orderkey;
sell1 = FOREACH l1 GENERATE l_shipmode, o_orderpriority;

grpResult = GROUP sell1 BY l_shipmode;
sumResult = FOREACH grpResult{
    urgItems = FILTER sell1 BY o_orderpriority MATCHES '1-URGENT' or o_orderpriority MATCHES '2-HIGH';
    GENERATE group, COUNT(urgItems), COUNT(sell1) - COUNT (urgItems);
};
sortResult = ORDER sumResult BY group;

store sortResult into '$output/Q12_out' USING PigStorage('|');