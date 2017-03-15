use dfs.tmp;
drop table if exists q9_product_type_profit;
create table q9_product_type_profit (nation, o_year, sum_profit) as
select 
  nation, 
  o_year, 
  sum(amount) as sum_profit
from 
  (
select 
  n_name as nation, 
  DATE_PART('year',o_orderdate) as o_year, 
  l_extendedprice * (1 - l_discount) -  ps_supplycost * l_quantity as amount
    from
      DATABASE.orders o join
      (select l_extendedprice, l_discount, l_quantity, l_orderkey, n_name, ps_supplycost 
       from DATABASE.part p join
         (select l_extendedprice, l_discount, l_quantity, l_partkey, l_orderkey, 
                 n_name, ps_supplycost 
          from DATABASE.partsupp ps join
            (select l_suppkey, l_extendedprice, l_discount, l_quantity, l_partkey, 
                    l_orderkey, n_name 
             from
               (select s_suppkey, n_name 
                from DATABASE.nation n join DATABASE.supplier s on n.n_nationkey = s.s_nationkey
               ) s1 join DATABASE.lineitem l on s1.s_suppkey = l.l_suppkey
            ) l1 on ps.ps_suppkey = l1.l_suppkey and ps.ps_partkey = l1.l_partkey
         ) l2 on p.p_name like '%plum%' and p.p_partkey = l2.l_partkey
     ) l3 on o.o_orderkey = l3.l_orderkey
  )profit
group by nation, o_year
order by nation, o_year desc;