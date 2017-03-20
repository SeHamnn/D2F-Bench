use dfs.tmp;
drop table if exists q2_minimum_cost_supplier_tmp1;
create table q2_minimum_cost_supplier_tmp1 (s_acctbal, s_name, n_name, p_partkey, ps_supplycost, p_mfgr, s_address, s_phone, s_comment) as 
select 
  s.s_acctbal, 
  s.s_name, 
  n.n_name, 
  p.p_partkey, 
  ps.ps_supplycost, 
  p.p_mfgr, 
  s.s_address, 
  s.s_phone, 
  s.s_comment 
from 
  DATABASE.nation n join DATABASE.region r 
  on 
    n.n_regionkey = r.r_regionkey and r.r_name = 'EUROPE' 
  join DATABASE.supplier s 
  on 
s.s_nationkey = n.n_nationkey 
  join DATABASE.partsupp ps 
  on  
s.s_suppkey = ps.ps_suppkey 
  join DATABASE.part p 
  on 
    p.p_partkey = ps.ps_partkey 
and 
p.p_size = 37 and p.p_type like '%COPPER' ;

drop table if exists q2_minimum_cost_supplier_tmp2;
create table q2_minimum_cost_supplier_tmp2 (p_partkey, ps_min_supplycost) as 
select 
  p_partkey, min(ps_supplycost) 
from  
  q2_minimum_cost_supplier_tmp1 
group by p_partkey;



drop table if exists q2_minimum_cost_supplier;
create table q2_minimum_cost_supplier (s_acctbal, s_name, n_name , p_partkey, p_mfgr, s_address, s_phone, s_comment) as
select 
  t1.s_acctbal, 
  t1.s_name, 
  t1.n_name, 
  t1.p_partkey, 
  t1.p_mfgr, 
  t1.s_address, 
  t1.s_phone, 
  t1.s_comment 
from 
  q2_minimum_cost_supplier_tmp1 t1 join q2_minimum_cost_supplier_tmp2 t2 
on 
  t1.p_partkey = t2.p_partkey 
and 
t1.ps_supplycost=t2.ps_min_supplycost 
order by 
s_acctbal desc, n_name, s_name, p_partkey 
limit 100;
