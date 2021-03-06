use dfs.tmp;

drop table if exists q8_national_market_share;
create table q8_national_market_share(o_year, mkt_share) as
select 
  o_year, sum(case 
  when nation = 'PERU' then volume 
  else 0
  end) / sum(volume) as mkt_share
from 
  (
select 
  DATE_PART('year',o_orderdate) as o_year, 
  l_extendedprice * (1-l_discount) as volume, 
  n2.n_name as nation
    from
      DATABASE.nation n2 join
        (select o_orderdate, l_discount, l_extendedprice, s_nationkey 
         from DATABASE.supplier s join
          (select o_orderdate, l_discount, l_extendedprice, l_suppkey 
           from DATABASE.part p join
             (select o_orderdate, l_partkey, l_discount, l_extendedprice, l_suppkey 
              from DATABASE.lineitem l join
                (select o_orderdate, o_orderkey 
                 from DATABASE.orders o join
                   (select c.c_custkey 
                    from DATABASE.customer c join
                      (select n1.n_nationkey 
                       from DATABASE.nation n1 join DATABASE.region r
                       on n1.n_regionkey = r.r_regionkey and r.r_name = 'AMERICA'
                       ) n11 on c.c_nationkey = n11.n_nationkey
                    ) c1 on c1.c_custkey = o.o_custkey
                 ) o1 on l.l_orderkey = o1.o_orderkey and o1.o_orderdate >= '1995-01-01' 
                         and o1.o_orderdate < '1996-12-31'
              ) l1 on p.p_partkey = l1.l_partkey and p.p_type = 'ECONOMY BURNISHED NICKEL'
           ) p1 on s.s_suppkey = p1.l_suppkey
        ) s1 on s1.s_nationkey = n2.n_nationkey
  ) all_nation
group by o_year
order by o_year;