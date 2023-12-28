
/* DDL.SQL
create database
*/
if db_id('traveltours') is null
create database traveltours

go
use traveltours
go
create table travelagents
(
agent_id int primary key,
agent_name varchar(40)
)
go
create table tourepackages
(
package_id int primary key,
package_catagory varchar(30),
package_name varchar(30),
cost_per_person money,
toure_time datetime
)
go
create table package_features
(
feature_id int primary key,
transport_mode varchar(20),
hotel_booking varchar(20),
package_id int references tourepackages(package_id)
)
go
create table tourists 
(
tourist_id int primary key,
tourist_name varchar(40),
tourist_status varchar(30),
tourist_ocupation varchar(30),
package_id int references tourepackages(package_id)
)
go
create table agent_tourepackages
(
agent_id int references travelagents(agent_id),
package_id int references tourepackages(package_id)
primary key(package_id,agent_id)
)
go
----Store Procedure for Insert

create proc spInsert_travelagents @n nvarchar(100), @id int output
as
declare @i int
select @i = isnull(max(agent_id), 0)+1 from travelagents
begin try
	insert into travelagents(agent_id, agent_name)
	values (@id, @n)
	set @id = @i
	return 0
end try
begin catch
		declare @m nvarchar(500) , @EN int 
		select @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
		;
		throw @m, @en, 1
		return @en
end catch
go
create proc spInsert_tourepackages
									@pc nvarchar(30),
									@pn nvarchar (30),
									@cs money,
									@tt datetime
as
declare @id int
select @id = isnull(max(package_id), 0)+1 from tourepackages
begin try
	insert into tourepackages(package_id, package_catagory,package_name,cost_per_person,toure_time)
	values (@id,@pc,@pn,@cs,@tt)
	return @id
end try
begin catch
		declare @m nvarchar(500) , @EN int 
		select @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
		;
		throw @m, @en, 1
		return 0
end catch
go
create proc spInsert_package_features
									@t_m nvarchar(30),
									@h_b nvarchar (30),
									@p_id int
as
declare @id int
select @id = isnull(max(feature_id), 0)+1 from package_features
begin try
	insert into package_features(feature_id,transport_mode,hotel_booking,package_id)
	values (@id,@t_m,@h_b,@p_id)
	return @id
end try
begin catch
		declare @m nvarchar(500) , @EN int 
		select @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
	;
	throw @m, @en, 1
	return 0
end catch
go
create proc spInsert_tourists 
									@t_n nvarchar(30),
									@t_s nvarchar (30),
									@t_oc nvarchar(30),
									@p_id int
as
declare @id int
select @id = isnull(max(tourist_id), 0)+1 from tourists
begin try
	insert into tourists(tourist_id,tourist_name,tourist_status,tourist_ocupation,package_id)
	values (@id,@t_n,@t_s,@t_oc,@p_id)
	return @id
end try
begin catch
		declare @m nvarchar(500) , @EN int 
		select @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
		;
		throw @m, @en, 1
		return 0
end catch
go
create proc spInsert_agent_tourepackages 
									@p_id int
as
declare @id int
select @id = isnull(max(agent_id), 0)+1 from agent_tourepackages
begin try
	insert into agent_tourepackages(agent_id,package_id)
	values (@id,@p_id)
	return @id
end try
begin catch
		declare @m nvarchar(500) , @EN int 
		select @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
		;
		throw @m, @en, 1
		return 0
end catch
go
----Store Procedure for Update
----Update
create proc spUpdate_travelagents @id int,@n nvarchar(30)
as
begin try
	update travelagents
	set agent_name = @n
	where agent_id = @id
end try
begin catch
		declare @m nvarchar(500) , @EN int 
		select @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
		;
		throw @m, @en, 1
		return 0
end catch
GO
create proc spUpdate_tourepackages @id int,
									@p_c nvarchar(30),
									@p_n nvarchar(30),
									@c_p money,
									@t_t datetime
as
begin try
	update tourepackages
	set 
	package_catagory =isnull( @p_c,package_catagory),
	package_name = isnull(@p_n,package_name),
	cost_per_person = isnull(@c_p,cost_per_person),
	toure_time = isnull(@t_t,toure_time)
	where package_id = @id
end try
begin catch
		declare @m nvarchar(500) , @EN int 
		select @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
		;
		throw @m, @en, 1
		return 0
end catch
go
create proc spUpdate_package_features @id int,
@t_m nvarchar(30),
@h_b nvarchar(30),
@p_id int
as
begin try
	update package_features
	set 
	transport_mode =isnull( @t_m,transport_mode),
	hotel_booking = isnull(@h_b,hotel_booking),
	package_id = isnull(@p_id,package_id)
	where feature_id = @id
end try
begin catch
		declare @m nvarchar(500) , @EN int 
		select @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
	;
	throw @m, @en, 1
	return 0
end catch
go
create proc spUpdate_tourists @id int,
								@t_n nvarchar(30),
								@t_s nvarchar(30),
								@t_oc nvarchar(30),
								@p_id int
as
begin try
	update tourists
	set 
	tourist_name =isnull( @t_n,tourist_name),
	tourist_status = isnull(@t_s,tourist_status),
	tourist_ocupation = isnull(@t_oc,tourist_ocupation),
	package_id = isnull(@p_id,package_id)
	where tourist_id = @id
end try
begin catch
		declare @m nvarchar(500) , @EN int 
		select @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
		;
		throw @m, @en, 1
		return 0
end catch
go
create proc spUpdate_agent_tourepackages @id int,
@p_id int
as
begin try
	update agent_tourepackages
	set 

	package_id = isnull(@p_id,package_id)
	where agent_id = @id
end try
begin catch
		declare @m nvarchar(500) , @EN int 
		select @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
		;
		throw @m, @en, 1
		return 0
end catch
go
--Store Procedure for Delete

create proc spDelete_travelagents @id int
as
begin try
	delete travelagents
	where agent_id = @id
end try
begin catch
		declare @m nvarchar(500) , @EN int 
		select @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
		;
		throw @m, @en, 1
		return 0
end catch
go
create proc spDelete_tourepackages @id int
as
begin try
	delete tourepackages
	where package_id = @id
end try
begin catch
		declare @m nvarchar(500) , @EN int 
		select @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
		;
		throw @m, @en, 1
		return 0
end catch
go
create proc spDelete_package_features @id int
as
begin try
	delete package_features	
	where package_id = @id
end try
begin catch
		declare @m nvarchar(500) , @EN int 
		select @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
		;
		throw @m, @en, 1
		return 0
end catch
go
create proc spDelete_tourists  @id int
as
begin try
	delete tourists 	
	where tourist_id = @id
end try
begin catch
		declare @m nvarchar(500) , @EN int 
		select @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
		;
		throw @m, @en, 1
		return 0
end catch
go
create proc spDelete_agent_tourepackages  @id int
as
begin try
	delete agent_tourepackages 	
	where agent_id = @id
end try
begin catch
		declare @m nvarchar(500) , @EN int 
		select @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
		;
		throw @m, @en, 1
		return 0
end catch
go

----View
create view v_tour_Info
as
select tourist_name, package_catagory ,agent_id, tourist_ocupation
from tourists t
inner join tourepackages tp
on t.package_id=tp.package_id
inner join agent_tourepackages atp
on tp.package_id= atp.package_id
go
create view v_tour_over_cost_over_2000
as
select  ta.agent_name, tp.package_name, tp.cost_per_person, t.tourist_name, t.tourist_status, t.tourist_ocupation
from travelagents ta
inner join agent_tourepackages atp on ta.agent_id = atp.agent_id 
inner join tourepackages tp on atp.package_id = tp.package_id 
inner join tourists t on atp.package_id = t.package_id
where tp.cost_per_person > 2000
go
create view v_all_agent
as
select  tp.package_name, tp.cost_per_person, ta.agent_name, t.tourist_name, t.tourist_status, t.tourist_ocupation
from  travelagents as ta 
inner join agent_tourepackages as atp on ta.agent_id = atp.agent_id 
inner join tourists as t on atp.package_id = t.package_id 
right outer join tourepackages as tp on atp.package_id = tp.package_id
go
create view v_agent_no_package
as
select tp.package_name, tp.cost_per_person, ta.agent_name, t.tourist_name, t.tourist_status, t.tourist_ocupation
from   travelagents as ta 
inner join agent_tourepackages as atp on ta.agent_id = atp.agent_id 
inner join tourists as t on atp.package_id = t.package_id 
right outer join  tourepackages as tp on atp.package_id = tp.package_id
where ta.agent_id IS NULL
go
--User Define Function
create function fnTable(@agent_id int) returns table
as
return
(
select tourist_name, package_catagory ,agent_id, tourist_ocupation
from tourists t
inner join tourepackages tp
on t.package_id=tp.package_id
inner join agent_tourepackages atp
on tp.package_id= atp.package_id
where agent_id=@agent_id
)
go
create function fnScalar(@id int) returns money
as
begin
declare @C money
select  @c = tp.cost_per_person
from travelagents ta
inner join agent_tourepackages atp on ta.agent_id = atp.agent_id 
inner join tourepackages tp on atp.package_id = tp.package_id 
inner join tourists t on atp.package_id = t.package_id
where @id = tp.package_id
return @c
end
go
----TRIGGER
create trigger tragent_packages
on agent_tourepackages for insert 
as
begin
declare @agentid int
select @agentid=agent_id from inserted
	if exists
		(
			select count(*) from agent_tourepackages
			where agent_id = @agentid
			group by agent_id
			having count(*) >  5
		)
		begin
			rollback transaction 
			Raiserror('Agency has already had five packages',16,1)
		end
end
go
