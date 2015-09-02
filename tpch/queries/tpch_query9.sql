-- create the result table
drop table if exists q9_product_type_profit;
create table q9_product_type_profit (nation string, o_year string, sum_profit double);

set mapred.min.split.size=536870912;
set hive.exec.reducers.bytes.per.reducer=1024000000;

-- the query
insert overwrite table q9_product_type_profit
select 
  nation, 
  o_year, 
  sum(amount) as sum_profit
from 
  (
select 
  n_name as nation, 
  year(o_orderdate) as o_year, 
  l_extendedprice * (1 - l_discount) -  ps_supplycost * l_quantity as amount
    from
      orders o join
      (select l_extendedprice, l_discount, l_quantity, l_orderkey, n_name, ps_supplycost 
       from part p join
         (select l_extendedprice, l_discount, l_quantity, l_partkey, l_orderkey, 
                 n_name, ps_supplycost 
          from partsupp ps join
            (select l_suppkey, l_extendedprice, l_discount, l_quantity, l_partkey, 
                    l_orderkey, n_name 
             from
               (select s_suppkey, n_name 
                from nation n join supplier s on n.n_nationkey = s.s_nationkey
               ) s1 join lineitem l on s1.s_suppkey = l.l_suppkey
            ) l1 on ps.ps_suppkey = l1.l_suppkey and ps.ps_partkey = l1.l_partkey
         ) l2 on p.p_name like '%plum%' and p.p_partkey = l2.l_partkey
     ) l3 on o.o_orderkey = l3.l_orderkey
  )profit
group by nation, o_year
order by nation, o_year desc;