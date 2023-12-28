--DML
use traveltours
go
---inset data

insert into travelagents values
						(1, 'Hanif Travels'),
						(2, 'Greenline Travels'),
						(3, 'Sakura Tours')
select * from travelagents
go

 insert into tourepackages values
							(1, 'Single packagae', 'Nilachol Tour', 3000.0000, CasT(N'2022-03-01' as Date)),
							(2, 'Group Package', 'Nilachol Tour', 2100.0000, CasT(N'2022-03-01' as Date)),
							(3, 'Family', 'Cox''s bazar tour', 4000.0000, CasT(N'2022-03-01' as DateTime)),
							(4, 'Single packagae', 'Cox''s bazar tour', 3000.0000, CasT(N'2022-03-01' as Date)),
							(5, 'Single packagae', 'Kuakata tour', 2500.0000, CasT(N'2022-03-01' as Date)),
							(6, 'Group Package', 'Kuakata tour', 2000.0000, CasT(N'2022-03-01' as Date))
go
select * from tourepackages


insert into agent_tourepackages values (1,1)
go

insert into package_features values 
							(1, 'Air', 'Janata hotel', 1),
							(2, 'Road', 'asian hotel', 2),
							(3, 'Bus', 'Redian hotel', 3),
							(4, 'Road', 'Rajmohol', 4)


go
select * from package_features
go
insert into tourists values
					(1,'Raihan','single','Bisness man',1),
					(2,'Jamim','married','G Employee',3),
					(3,'Saima jahan','married','service',2),
					(4,'Mukit Ali','single','Student',4)
go
select *
 from tourists
 go

insert into agent_tourepackages values (1, 4),(1, 2),(2, 3),(3, 5),(2, 4)
select * from [agent_tourepackages]
go
--query
select  tourepackages.package_catagory, tourepackages.package_name, tourepackages.cost_per_person, package_features.transport_mode, package_features.hotel_booking, travelagents.agent_name, tourists.tourist_name
from  tourists inner join package_features 
  inner join tourepackages on package_features.package_id = tourepackages.package_id on tourists.package_id = tourepackages.package_id 
  inner join agent_tourepackages on tourepackages.package_id = agent_tourepackages.package_id 
  inner join travelagents on agent_tourepackages.agent_id = travelagents.agent_id
 --view
select * from v_tour_Info
go
select * from v_tour_over_cost_over_2000
go
select * from  v_all_agent
go
select * from v_agent_no_package
go
 --pocedure
--declare @i INT
--exec spInsert_travelagents 'AA Travel', @i output
go
exec spinsert_tourepackages	'Family', 'Ariful' ,10000.00, '2022-05-01'
exec spinsert_package_features		'Road','Lasia nur 3 star',5
go
exec spinsert_tourists 'Jashim Ahmed','Single','Student',5
go
exec spUpdate_package_features 5 , 'Air', 'Holet Himalaia ', 5
go
exec spDelete_package_features 5
go
select * from fnTable(1)
go
--User Define Function
	select * from fnTable(1)
go
	select  dbo.fnScalar (2)
go
/*
				 Queries, Sub Queries, Join Queries, CTE
 */
 --1 inner
select  ta.agent_name, tp.package_name, tp.cost_per_person, t.tourist_name, t.tourist_status, t.tourist_ocupation
from travelagents ta
inner join agent_tourepackages atp on ta.agent_id = atp.agent_id 
inner join tourepackages tp on atp.package_id = tp.package_id 
inner join tourists t on atp.package_id = t.package_id
go
--2 inner filter
select  ta.agent_name, tp.package_name, tp.cost_per_person, t.tourist_name, t.tourist_status, t.tourist_ocupation
from travelagents ta
inner join agent_tourepackages atp on ta.agent_id = atp.agent_id 
inner join tourepackages tp on atp.package_id = tp.package_id 
inner join tourists t on atp.package_id = t.package_id
where ta.agent_name = 'Greenline Travels'
go
--3 inner filter
select  ta.agent_name, tp.package_name, tp.cost_per_person, t.tourist_name, t.tourist_status, t.tourist_ocupation
from travelagents ta
inner join agent_tourepackages atp on ta.agent_id = atp.agent_id 
inner join tourepackages tp on atp.package_id = tp.package_id 
inner join tourists t on atp.package_id = t.package_id
where tp.cost_per_person > 2000
go
--4 right outer
select  tp.package_name, tp.cost_per_person, ta.agent_name, t.tourist_name, t.tourist_status, t.tourist_ocupation
from  travelagents as ta 
inner join agent_tourepackages as atp on ta.agent_id = atp.agent_id 
inner join tourists as t on atp.package_id = t.package_id 
right outer join tourepackages as tp on atp.package_id = tp.package_id
go
--5 right outer Non matching
select tp.package_name, tp.cost_per_person, ta.agent_name, t.tourist_name, t.tourist_status, t.tourist_ocupation
from   travelagents as ta 
inner join agent_tourepackages as atp on ta.agent_id = atp.agent_id 
inner join tourists as t on atp.package_id = t.package_id 
right outer join  tourepackages as tp on atp.package_id = tp.package_id
where ta.agent_id IS NULL
go
--6 right outer Non matching Sub- Query
select tp.package_name, tp.cost_per_person, ta.agent_name, t.tourist_name, t.tourist_status, t.tourist_ocupation
from   travelagents as ta 
inner join agent_tourepackages as atp on ta.agent_id = atp.agent_id 
inner join tourists as t on atp.package_id = t.package_id 
right outer join  tourepackages as tp on atp.package_id = tp.package_id
where not (ta.agent_id is not null and ta.agent_id in (select agent_id from travelagents))
go
--7 Convert 4 to CTE
with cte as
(
	select  atp.package_id,  ta.agent_name, t.tourist_name, t.tourist_status, t.tourist_ocupation
	from    travelagents as ta 
	inner join agent_tourepackages as atp on ta.agent_id = atp.agent_id 
	inner join tourists as t on atp.package_id = t.package_id 
)
select   c.agent_name, c.tourist_name, c.tourist_status, c.tourist_ocupation
from cte c 
go
--8 case
select   ta.agent_name,  
case 
when count(tp.package_id) = 0 then 'No package'
else CasT(count(tp.package_id) as varchar)  
end 'count'
from    tourepackages tp
inner join agent_tourepackages atp on tp.package_id = atp.package_id 
right outer join travelagents ta on atp.agent_id = ta.agent_id
group by ta.agent_id, ta.agent_name
go
--9 AggreGATE
select  ta.agent_name, tp.package_name, count(t.tourist_id) 'count'
from travelagents ta
inner join agent_tourepackages atp on ta.agent_id = atp.agent_id 
inner join tourepackages tp on atp.package_id = tp.package_id 
inner join tourists t on atp.package_id = t.package_id
group by ta.agent_name, tp.package_name
go
--10 AggreGATE+having
select  ta.agent_name, tp.package_name, count(t.tourist_id) 'count'
from travelagents ta
inner join agent_tourepackages atp on ta.agent_id = atp.agent_id 
inner join tourepackages tp on atp.package_id = tp.package_id 
inner join tourists t on atp.package_id = t.package_id
group by ta.agent_name, tp.package_name
having ta.agent_name='Hanif Travels'
go
--11 Ranking
select  ta.agent_name, tp.package_name, 
count(t.tourist_id) over(order by ta.agent_name, tp.package_name) 'count',
ROW_NUMBER() over(order by ta.agent_name, tp.package_name) 'row',
RANK() over(order by ta.agent_name, tp.package_name) 'rank',
DENSE_RANK() over(order by ta.agent_name, tp.package_name) 'dense',
NTILE(2) over(order by ta.agent_name, tp.package_name) 'ntile'
from travelagents ta
inner join agent_tourepackages atp on ta.agent_id = atp.agent_id 
inner join tourepackages tp on atp.package_id = tp.package_id 
inner join tourists t on atp.package_id = t.package_id
go