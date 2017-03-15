use dfs.tmp;
drop view if exists q11_part_tmp_cached;
drop view if exists q11_sum_tmp_cached;

create view q11_part_tmp_cached as
select
	ps_partkey,
	sum(ps_supplycost * ps_availqty) as part_value
from
	DATABASE.partsupp,
	DATABASE.supplier,
	DATABASE.nation
where
	ps_suppkey = s_suppkey
	and s_nationkey = n_nationkey
	and n_name = 'GERMANY'
group by ps_partkey;

create view q11_sum_tmp_cached as
select
	sum(part_value) as total_value
from
	q11_part_tmp_cached;

		
select
	ps_partkey, part_value as value_one
from (
	select
		ps_partkey,
		part_value,
		total_value
	from
		q11_part_tmp_cached  
	join q11_sum_tmp_cached on part_value > total_value * 0.0001
) a
order by
	value_one desc;
