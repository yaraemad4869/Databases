use Hospital
GO

create table Parents(
ID int,
Name varchar(100) not null,
PhoneNumber varchar(14) not null,
constraint PK_Parents primary key(ID)
)

GO

------------- Select Into ------------

if exists(select name from sys.tables where name='Parents')
if not exists(select name from sys.tables where name='ParentsBak')
select *
into ParentsBak
FROM Parents
else
select 'There is object named ParentsBak'
else
select 'Table Does not Exist'

GO

------------- Drop Table ------------

begin try
drop table Parents
end try
begin catch
select 'Table Parents Does not Exist'
end catch

GO

------------- Drop Constraint ------------

if exists(select name from sys.tables where name='Parents')
begin try
alter table Parents
drop constraint PK_Parents
end try
begin catch
select 'Constraint Does not Exist'
end catch
else
select 'Table Does not Exist'

GO

------------- Drop Column ------------

if exists(select name from sys.tables where name='Parents')
begin try
alter table Parents
drop column Name
end try
begin catch
select 'Column Does not Exist'
end catch
else
select 'Table Does not Exist'

GO

-------------------- Procedures -------------------

------------- Select Into Procedure ------------

CREATE PROCEDURE SelectInto @params varchar(200),@old varchar(20) , @new varchar(20)
as
if exists(select name from sys.tables where name=@old)
if not exists(select name from sys.tables where name=@new)
execute('select '+@params+' into '+@new+' from '+@old)
else
select 'There is object named '+@new
else
select 'Table '+@old+' Does not Exist'

GO

------------- Drop Table Procedure ------------

CREATE PROCEDURE DropTable @t varchar(20)
AS
begin try
execute('drop table '+@t)
end try
begin catch
select 'Table '+@t+' Does not Exist'
end catch

GO

------------- Drop Constraint Procedure ------------

CREATE PROCEDURE DropConstraint @c varchar(20), @t varchar(20)
AS
if exists(select name from sys.tables where name=@t)
begin try
execute('alter table '+@t+' drop constraint '+@c)
end try
begin catch
select 'Constraint '+@c+' Does not Exist'
end catch
else
select 'Table '+@t+' Does not Exist'

GO

------------- Drop Column Procedure ------------

CREATE PROCEDURE DropColumn @c varchar(20), @t varchar(20)
AS
if exists(select name from sys.tables where name=@t)

begin try
execute('alter table '+@t+' drop column '+@c)
end try
begin catch
select 'Column '+@c+' Does not Exist'
end catch

else
select 'Table '+@t+' Does not Exist'

GO

------------- Execute Procedure ------------

if exists(select name from sys.all_objects where name='SelectInto' and type_desc='SQL_STORED_PROCEDURE')
exec SelectInto '*','Parents','ParentsBak';
else
select 'Procedure SelectInto Does not Exist';

if exists(select name from sys.all_objects where name='DropTable' and type_desc='SQL_STORED_PROCEDURE')
exec DropTable 'Parents';
else
select 'Procedure DropTable Does not Exist';

if exists(select name from sys.all_objects where name='DropConstraint' and type_desc='SQL_STORED_PROCEDURE')
exec DropConstraint 'PK_Parents','Parents';
else
select 'Procedure DropConstraint Does not Exist';

if exists(select name from sys.all_objects where name='DropColumn' and type_desc='SQL_STORED_PROCEDURE')
exec DropColumn 'Name','Parents';
else
select 'Procedure DropColumn Does not Exist';

GO

------------- Drop Procedure ------------

if exists(select name from sys.all_objects where name='SelectInto' and type_desc='SQL_STORED_PROCEDURE')
drop procedure SelectInto;
else
select 'Procedure SelectInto Does not Exist';

if exists(select name from sys.all_objects where name='DropTable' and type_desc='SQL_STORED_PROCEDURE')
drop procedure DropTable;
else
select 'Procedure DropTable Does not Exist';

if exists(select name from sys.all_objects where name='DropConstraint' and type_desc='SQL_STORED_PROCEDURE')
drop procedure DropConstraint;
else
select 'Procedure DropConstraint Does not Exist';

if exists(select name from sys.all_objects where name='DropColumn' and type_desc='SQL_STORED_PROCEDURE')
drop procedure DropColumn;
else
select 'Procedure DropColumn Does not Exist';

----------------------------------------------------------------

------------ Synonym ------------
create synonym E for Employee
create synonym D for Doctor

------------ Max ------------

select distinct Shift_Type, max(Salary) over(partition by Shift_Type order by Shift_Type) as "Max Salary Per Shift" from E;

select Shift_Type, max(Salary) as "Max Salary" from E  group by Shift_Type order by Shift_Type;

select max(Salary) as "Max Salary Of Doctor" from D,E where D.Emp_ID=E.Emp_ID;

select max(DATEDIFF(Year,Hire_Date,GETDATE())) as "Max Experience" from E;

select max(DATEDIFF(Year,Birth_Date,GETDATE())) as "Max Age" from E;

select Dept_Name,max(Salary) as "Max Salary Of Department" from D,E,Department DP where D.Emp_ID=E.Emp_ID and DP.Dept_ID=D.Dept_ID group by Dept_Name;

------------ SubQuery With Max ------------

select max(Salary) as "Max Salary Of Doctor" from (select D_ID,Dept_ID,E.*  from D,E where D.Emp_ID=E.Emp_ID) as DocTable;

select (F_Name+' '+M_Name+' '+L_Name)as Full_Name , Salary
from D,E where D.Emp_ID=E.Emp_ID and Salary=(select max(Salary) from D,E where D.Emp_ID=E.Emp_ID);

select max(Experience) as "Max Experience" from (select DATEDIFF(Year,Hire_Date,GETDATE()) as Experience from E) as EmpExp;

-------------------- Rules -------------------

------------ Create Rules ------------

create rule SalaryR as @s>=4000;
create rule ShiftTypeR as @s='Evening' or @s='Morning' or @s='Night';
create rule GenderR as @g='M' or @g='F';
create rule AgeR as DATEDIFF(Year,@bd,GETDATE())<60 or DATEDIFF(Year,@bd,GETDATE())>18;

GO

------------ Bind Rules ------------

sp_bindrule SalaryR , 'Employee.Salary';
sp_bindrule ShiftTypeR , 'Employee.Shift_Type';
sp_bindrule GenderR , 'Employee.Gender';
sp_bindrule AgeR , 'Employee.Birth_Date';

GO

------------ Unbind Rules ------------

sp_unbindrule 'Employee.Salary';
sp_unbindrule 'Employee.Shift_Type';
sp_unbindrule 'Employee.Gender';
sp_unbindrule 'Employee.Birth_Date';

GO 
------------ Drop Rules ------------

drop rule SalaryR;
drop rule ShiftTypeR;
drop rule GenderR;
drop rule AgeR;

-------------------- Default -------------------

------------ Create Default ------------

create default SalaryD as 4000;
create default ShiftTypeD as 'Morning';
create default GenderD as 'M';
create default BirthDateD as '2006-1-1';

GO

------------ Bind Default ------------

sp_bindefault SalaryD , 'Employee.Salary';
sp_bindefault ShiftTypeD , 'Employee.Shift_Type';
sp_bindefault GenderD , 'Employee.Gender';
sp_bindefault BirthDateD , 'Employee.Birth_Date';

GO

------------ Unbind Default ------------

sp_unbindefault 'Employee.Salary';
sp_unbindefault 'Employee.Shift_Type';
sp_unbindefault 'Employee.Gender';
sp_unbindefault 'Employee.Birth_Date';

GO 
------------ Drop Default ------------

drop default SalaryD;
drop default ShiftTypeD;
drop default GenderD;
drop default BirthDateD;

-------------------- Null Functions -------------------

------------ Coalesce ------------

select coalesce(Dept_Name,Dept_Location,null) from Department;
select coalesce(Emp_ID,Dept_ID,null) from Doctor;

------------ Is Null ------------

select isnull(Dept_Name,'') from Department;
select isnull(Emp_ID,0) from Doctor;

------------ If , Else ------------

declare @age int;
select @age=DATEDIFF(Year,Birth_Date,GETDATE())from Patient where P_ID=4
select @age
if @age<15
begin
insert into Treatment(D_ID,P_ID)values(7,4);
end
else
insert into Treatment(D_ID,P_ID)values(10,4);

------------ IIf ------------

declare @age int;
select @age=DATEDIFF(Year,Birth_Date,GETDATE())from Patient where P_ID=4
select @age
insert into Treatment(D_ID,P_ID)values(IIF(@age<15, 7, 10),4);
-------------------- Views -------------------

------------ Create View ------------

create view Ages
as 
select (F_Name+' '+L_Name) as Full_Name , DATEDIFF(Year,Birth_Date,GETDATE())as Age from Patient
union
select (F_Name+' '+M_Name+' '+L_Name) as Full_Name , DATEDIFF(Year,Birth_Date,GETDATE())as Age from Employee

GO

------------ Use View ------------

select * from Ages

GO

------------ Drop View ------------

drop view Ages

------------ While ------------

declare @c int 
set @c=1
while ( @c <= (select count(*)from Patient))
begin
	select 'Patient number '+convert(varchar,@c)+' is '+F_Name+' '+L_Name+'. He is '+convert(varchar,DATEDIFF(Year,isnull(Birth_Date,'2005-1-23'),GETDATE()))+' years old.' as 'Patient Report' from Patient where P_ID=@c
	
    set @c  = convert(int,@c)  + 1;
end

declare @c int 
set @c=1
while ( @c <= 5)
begin
	select 'Yara is always RIGHT' as 'Who is Right';
    set @c  = @c  + 1
end

declare @c int 
set @c=1
while ( @c <= 5)
begin
	select 'Shrouk is the BEST <3' as 'Who is the Best';
    set @c  = @c  + 1
end