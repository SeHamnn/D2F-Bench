use dfs.tmp;

drop table if exists supplier_tmp;
create table supplier_tmp(s_suppkey) as
select 
  s_suppkey
from 
  DATABASE.supplier
where 
  not (s_comment like '%Customer%Complaints%');

drop table if exists q16_tmp;
create table q16_tmp(p_brand, p_type, p_size, ps_suppkey) as 
select 
  p.p_brand, p.p_type, p.p_size, ps.ps_suppkey
from 
  DATABASE.partsupp ps join DATABASE.part p 
  on 
    p.p_partkey = ps.ps_partkey and p.p_brand <> 'Brand#34' 
    and not (p.p_type like 'ECONOMY BRUSHED%')
  join supplier_tmp s 
  on 
    ps.ps_suppkey = s.s_suppkey;
	

drop table if exists q16_parts_supplier_relationship;
create table q16_parts_supplier_relationship(p_brand, p_type, p_size, supplier_cnt) as
select 
  p_brand, p_type, p_size, count(distinct ps_suppkey) as supplier_cnt
from 
  (select 
     * 
   from
     q16_tmp 
   where p_size = 22 or p_size = 14 or p_size = 27 or
         p_size = 49 or p_size = 21 or p_size = 33 or
         p_size = 35 or p_size = 28
) q16_all
group by 
p_brand, 
p_type, 
p_size
order by 
supplier_cnt desc, 
p_brand, 
p_type, 
p_size;





