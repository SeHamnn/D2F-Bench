use dfs.tmp;
drop table if exists q20_tmp1;
create table q20_tmp1(p_partkey) as
select distinct p_partkey
from
  DATABASE.part 
where 
  p_name like 'forest%';


drop table if exists q20_tmp2;
create table q20_tmp2(l_partkey, l_suppkey, sum_quantity) as
select 
  l_partkey, 
  l_suppkey, 
  0.5 * sum(l_quantity)
from
  DATABASE.lineitem
where
  l_shipdate >= '1994-01-01'
  and l_shipdate < '1995-01-01'
group by l_partkey, l_suppkey;


drop table if exists q20_tmp3;
create table q20_tmp3(ps_suppkey, ps_availqty, sum_quantity) as 
select 
  ps.ps_suppkey, 
  ps.ps_availqty, 
  t2.sum_quantity
from  
  DATABASE.partsupp ps join q20_tmp1 t1 
  on 
    ps.ps_partkey = t1.p_partkey
  join q20_tmp2 t2 
  on 
    ps.ps_partkey = t2.l_partkey 
	and ps.ps_suppkey = t2.l_suppkey;


drop table if exists q20_tmp4;
create table q20_tmp4(ps_suppkey) as
select 
  ps_suppkey
from 
  q20_tmp3
where 
  ps_availqty > sum_quantity
group by ps_suppkey;

drop table if exists q20_potential_part_promotion;
create table q20_potential_part_promotion(s_name, s_address) as
select 
  s.s_name, s.s_address
from 
  DATABASE.supplier s join DATABASE.nation n
  on
    s.s_nationkey = n.n_nationkey
    and n.n_name = 'CANADA'
  join q20_tmp4 t4
  on 
    s.s_suppkey = t4.ps_suppkey
order by s_name;