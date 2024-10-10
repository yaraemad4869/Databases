create database BloodBank;
use BloodBank;
----Tables----
create table BloodBank(
Name varchar(50) constraint bb_pk primary key,
Address varchar(100) NOT NULL,
);
create table Doctors (
ID int identity (1,1) constraint doc_pk primary key,
Fname varchar(20) NOT NULL,
Sname varchar(20) NOT NULL,
Tname varchar(20) NOT NULL,
Lname varchar(20) NOT NULL,
Gender nchar(1) NOT NULL,
BDate date NOT NULL,
HDate date NOT NULL,
Address varchar(100) NOT NULL,
Email varchar(200) unique NOT NULL,
name_bb varchar(50),
id_dep int 
);
create table Donor (
ID int identity(1,1) constraint don_pk primary key,
Fname varchar(20) NOT NULL,
Sname varchar(20) NOT NULL,
Tname varchar(20) NOT NULL,
Lname varchar(20) NOT NULL,
Gender nchar(1) NOT NULL,
BDate date NOT NULL,
Address varchar(100) NOT NULL,
Email varchar(200) unique NULL
);
create table Blood_Sample(
ID int identity(1,1) constraint blood_pk primary key,
Type char(2),
IDate date NOT NULL,
EDate date NOT NULL,
NAT char(1),
HCVAB char(1),
HIVAgAb char(1),
Bloodgp char(1),
HBsAg char(1),
SyphilisAb char(1),
);
create table Employee (
ID int identity(1,1) constraint emp_pk primary key,
Fname varchar(20) NOT NULL,
Sname varchar(20) NOT NULL,
Tname varchar(20) NOT NULL,
Lname varchar(20) NOT NULL,
Gender nchar(1) NOT NULL,
BDate date NOT NULL,
HDate date NOT NULL,
Position varchar(20) NOT NULL,
Salary float,
Address varchar(100) NOT NULL,
Email varchar(200) unique NOT NULL,
name_bb varchar(50)
);
create table Nurse (
ID int identity(1,1) constraint nurse_pk primary key,
ffname varchar(20) NOT NULL,
Sname varchar(20) NOT NULL,
Tname varchar(20) NOT NULL,
Lname varchar(20) NOT NULL,
BDate date NOT NULL,
HDate date NOT NULL,
Salary float,
Address varchar(100) NOT NULL,
Email varchar(200) unique NOT NULL,
name_bb varchar(50),
);
create table Department (
ID int identity(1,1) constraint dep_pk primary key,
Name varchar(50),
);

----Phone Tables----
create table DocPhone(
ID_Doc int constraint doc_phone_fk foreign key references Doctors(ID),
Phone char(11) unique NOT NULL,
constraint doc_phone primary key(ID_Doc ,Phone),
);
create table DonPhone(
ID_Don int constraint don_phone_fk foreign key references Donor(ID),
Phone char(11) unique NOT NULL,
constraint don_phone primary key(ID_Don ,Phone),
);
create table EmpPhone(
ID_Emp int constraint emp_phone_fk foreign key references Employee(ID),
Phone char(11) unique NOT NULL,
constraint emp_phone primary key(ID_Emp ,Phone),
);
create table NursePhone(
ID_Nurse int constraint nurse_phone_fk foreign key references Nurse(ID),
Phone char(11) unique NOT NULL,
constraint nurse_phone primary key(ID_Nurse ,Phone),
);

----M-N Tables----
create table Don_BB(
ID_Don int constraint don_bb_fk foreign key references Donor(ID),
Name_BB varchar(50) constraint bb_don_fk foreign key references BloodBank(Name),
constraint don_bb_pk primary key(ID_Don,Name_BB)
);
create table Nurse_Don(
ID_Don int constraint don_nurse_fk foreign key references Donor(ID),
ID_Nurse int constraint nurse_don_fk foreign key references Donor(ID),
constraint don_nurse_pk primary key(ID_Don,ID_Nurse)
);
create table Blood_Doc(
ID_Doc int constraint doc_blood_fk foreign key references Doctors(ID),
ID_Blood int constraint blood_doc_fk foreign key references Blood_Sample(ID),
constraint doc_blood_pk primary key(ID_Doc,ID_Blood)
);
create table Blood_BB(
name_bb varchar(50) constraint bb_blood_fk foreign key references BloodBank(Name),
ID_Blood int constraint blood_bb_fk foreign key references Blood_Sample(ID),
constraint blood_bb_pk primary key(name_bb,ID_Blood)
);

----Dependents Tables----
create table NurseRelative(
Fname varchar(20) NOT NULL,
Sname varchar(20) NOT NULL,
Tname varchar(20) NOT NULL,
Lname varchar(20) NOT NULL,
Gender nchar(1) NOT NULL,
id_nurse int constraint nurse_fk foreign key references Nurse NOT NULL,
);
create table DocRelative(
Fname varchar(20) NOT NULL,
Sname varchar(20) NOT NULL,
Tname varchar(20) NOT NULL,
Lname varchar(20) NOT NULL,
Gender char(1) NOT NULL,
id_doc int constraint doc_fk foreign key references Doctors(ID) NOT NULL
);
create table EmpRelative(
Fname varchar(20) NOT NULL,
Sname varchar(20) NOT NULL,
Tname varchar(20) NOT NULL,
Lname varchar(20) NOT NULL,
Gender nchar(1) NOT NULL,
);

----Change Table Name----
exec sp_rename Doctors,Doctor;
----Change Column Name----
exec sp_rename 'Nurse.ffname','Nurse.Fname','column';
exec sp_rename 'DocRelative.Fname','DocRelative.relativename','column';

----Add Foreign Key----
alter table Doctor
add constraint bb_doc_fk foreign key(name_bb) references BloodBank(Name);
alter table Employee
add constraint bb_emp_fk foreign key(name_bb) references BloodBank(Name);
alter table Nurse
add constraint bb_nurse_fk foreign key(name_bb) references BloodBank(Name);
alter table Doctor 
add constraint doc_dep_fk foreign key(id_dep) references Department (ID);
alter table EmpRelative
add id_emp int constraint emp_fk foreign key references Employee(ID) NOT NULL;
alter table Department
add name_bb varchar(50) foreign key references BloodBank(Name);

----Add Columns----
alter table BloodBank
add Phone varchar(15) NOT NULL;
alter table Nurse
add Gender char(1) NOT NULL;
alter table Doctor
add Salary float;

----Add Check Constraint----
alter table Doctor
add constraint ageDoc_check check(DATEDIFF(year,BDate,GETDATE())<=25 );
alter table Donor
add constraint ageDon_check check(DATEDIFF(year,BDate,GETDATE())<=18 );
alter table Employee
add constraint ageEMP_check check(DATEDIFF(year,BDate,GETDATE())<=21 );
alter table Nurse
add constraint agenur_check check(DATEDIFF(year,BDate,GETDATE())<=23 );


----Insert Into Blood Bank Table----
insert into BloodBank (Name,Address,Phone) values('BSBB','Beni-Suef','01########*');
insert into BloodBank (Name,Address,Phone) values('MEBB','Menia','01#######gg');
insert into BloodBank (Name,Address,Phone) values('MABB','Mansoura','01######*');
insert into BloodBank (Name,Address,Phone) values('ASBB','Asyot','01#####**');
insert into BloodBank (Name,Address,Phone) values('KEBB','Kafr-ElSheikh','01####***');
insert into BloodBank (Name,Address,Phone) values('WGBB','Elwadi-Elgedid','01###**');
insert into BloodBank (Name,Address,Phone) values('CAIBB','Cairo','01##***');
insert into BloodBank (Name,Address,Phone) values('ALEXBB','Alex','01#***');
insert into BloodBank (Name,Address,Phone) values('SIWBB','Siwa','01*****');
insert into BloodBank (Name,Address,Phone) values('SHSHBB','Sharm-Elsheikh','01#######');
insert into BloodBank (Name,Address,Phone) values('SOHBB','Sohag','01#######');
insert into BloodBank (Name,Address,Phone) values('ASWBB','Aswan','01#######');
insert into BloodBank (Name,Address,Phone) values('LUXBB','Luxur','01#######');
insert into BloodBank (Name,Address,Phone) values('BEHBB','Behaira','01#######');
insert into BloodBank (Name,Address,Phone) values('SUESBB','Elsues','01#######');
insert into BloodBank (Name,Address,Phone) values('QENABB','Qena','01*#######*');
insert into BloodBank (Name,Address,Phone) values('FAYBB','Fayoum','01######*');
insert into BloodBank (Name,Address,Phone) values('TANBB','Tanta','01*######');
insert into BloodBank (Name,Address,Phone) values('MMBB','Marsa-Matrouh','01#*####*');
insert into BloodBank (Name,Address,Phone) values('DUMBB','Dumyat','01#*####*');

----Insert Into Doctor Table----
insert into Doctor(name_bb,Fname,Sname,Tname,Lname,Gender,Address,BDate,HDate,Email) values('BSBB','Kareem','Ahmed','Mohammed','Reda','M','GTBEGTGK','1-3-2038','5-6-1980','Kareem.COM');
insert into Doctor(name_bb,Fname,Sname,Tname,Lname,Gender,Address,BDate,HDate,Email) values('BSBB','Reda','Ahmed','Sayed','Mohammed','M','GTBEGTGK','1-3-2038','5-6-1980','Reda.COM');
insert into Doctor(name_bb,Fname,Sname,Tname,Lname,Gender,Address,BDate,HDate,Email) values('BSBB','Mohammed','Ahmed','Ali','Montaser','M','GTBEGTGK','1-3-2038','5-6-1980','Mohammed.COM');
insert into Doctor(name_bb,Fname,Sname,Tname,Lname,Gender,Address,BDate,HDate,Email) values('BSBB','Jana','Mostafa','Hussein','Ahmed','F','GTBEGTGK','1-3-2038','5-6-1980','Jana.COM');
insert into Doctor(name_bb,Fname,Sname,Tname,Lname,Gender,Address,BDate,HDate,Email) values('BSBB','Yara','Emad','Sayed','Mohammed','F','GTBEGTGK','1-3-2038','5-6-1980','Yara.COM');
insert into Doctor(name_bb,Fname,Sname,Tname,Lname,Gender,Address,BDate,HDate,Email) values('BSBB','Heba','Eldesoki','Mohammed','Ali','F','GTBEGTGK','1-3-2038','5-6-1980','Heba.COM');
insert into Doctor(name_bb,Fname,Sname,Tname,Lname,Gender,Address,BDate,HDate,Email) values('BSBB','Yousra','Bahaa','Sayed','Taha','F','GTBEGTGK','1-3-2038','5-6-1980','Yousra.COM');
insert into Doctor(name_bb,Fname,Sname,Tname,Lname,Gender,Address,BDate,HDate,Email) values('BSBB','Hoda','Ahmed','Sayed','Fahmy','F','GTBEGTGK','1-3-2038','5-6-1980','Hoda.COM');
insert into Doctor(name_bb,Fname,Sname,Tname,Lname,Gender,Address,BDate,HDate,Email) values('BSBB','Salma','Amr','Ismael','Mohammed','F','GTBEGTGK','1-3-2038','5-6-1980','Salma.COM');
insert into Doctor(name_bb,Fname,Sname,Tname,Lname,Gender,Address,BDate,HDate,Email) values('BSBB','Saeed','Ahmed','Metwaly','Ragab','M','GTBEGTGK','1-3-2038','5-6-1980','Saeed.COM');

----Insert Into Donor Table----
insert into Donor(Fname,Sname,Tname,Lname,Gender,Address,BDate,Email) values('kareem','Sayed','Mohammed','Ahmed','M','GTBEGTGK','1/3/2038','kareem1.COM');
insert into Donor(Fname,Sname,Tname,Lname,Gender,Address,BDate,Email) values('Sayed','Ali','Othman','Sayed','M','GTBEGTGK','1/3/2038','Sayed1.COM');
insert into Donor(Fname,Sname,Tname,Lname,Gender,Address,BDate,Email) values('Ahmed','Fathy','Sayed','Mahmoud','M','GTBEGTGK','1/3/2038','Ahmed1.COM');
insert into Donor(Fname,Sname,Tname,Lname,Gender,Address,BDate,Email) values('Mahmoud','Khaled','Magdy','Ahmed','M','GTBEGTGK','1/3/2038','Mahmoud1.COM');
insert into Donor(Fname,Sname,Tname,Lname,Gender,Address,BDate,Email) values('Khaled','Fahmy','Ahmed','Sayed','M','GTBEGTGK','1/3/2038','Khaled1.COM');
insert into Donor(Fname,Sname,Tname,Lname,Gender,Address,BDate,Email) values('Mayar','Hamdy','Ahmed','Helmy','M','GTBEGTGK','1/3/2038','Mayar1.COM');
insert into Donor(Fname,Sname,Tname,Lname,Gender,Address,BDate,Email) values('Aya','Mahmoud','Hussein','Ahmed','M','GTBEGTGK','1/3/2038','Aya1.COM');
insert into Donor(Fname,Sname,Tname,Lname,Gender,Address,BDate,Email) values('Eman','Ahmed','Makram','Hassan','M','GTBEGTGK','1/3/2038','Eman1.COM');
insert into Donor(Fname,Sname,Tname,Lname,Gender,Address,BDate,Email) values('Fatma','Mohammed','Ragab','Metwaly','M','GTBEGTGK','1/3/2038','Fatma1.COM');
insert into Donor(Fname,Sname,Tname,Lname,Gender,Address,BDate,Email) values('Hossam','Mahmoud','Ahmed','Sayed','M','GTBEGTGK','1/3/2038','Hossam1.COM');

----Insert Into Employee Table----
insert into Employee(name_bb,Fname,Sname,Tname,Lname,Gender,Address,Position,BDate,HDate) values('LUXBB','Khaled','Moftah','Abd-Allah','Gaber','S','GTBEGTGK','1-3-2038','5-6-198');
insert into Employee(name_bb,Fname,Sname,Tname,Lname,Gender,Address,Position,BDate,HDate) values('LUXBB','Lamar','Hafez','Kareem','Mohsen','S','GTBEGTGK','1-3-2038','5-6-1980');
insert into Employee(name_bb,Fname,Sname,Tname,Lname,Gender,Address,Position,BDate,HDate) values('LUXBB','Mayada','AHMEF','REDA','R','S','GTBEGTGK','1-3-2038','5-6-1980');
insert into Employee(name_bb,Fname,Sname,Tname,Lname,Gender,Address,Position,BDate,HDate) values('LUXBB','Shahd','AHMEF','REDA','R','S','GTBEGTGK','1-3-2038','5-6-1980');
insert into Employee(name_bb,Fname,Sname,Tname,Lname,Gender,Address,Position,BDate,HDate) values('LUXBB','Mai','AHMEF','REDA','R','S','GTBEGTGK','1-3-2038','5-6-1980');
insert into Employee(name_bb,Fname,Sname,Tname,Lname,Gender,Address,Position,BDate,HDate) values('LUXBB','Abd-El-Rahman','Mohammed','Ahmed','Sayed','S','GTBEGTGK','1-3-2038','5-6-1980');
insert into Employee(name_bb,Fname,Sname,Tname,Lname,Gender,Address,Position,BDate,HDate) values('TANBB','Jaafar','Marzouq','Metwaly','Marzouq','S','GTBEGTGK','1-3-2038','5-6-1980');
insert into Employee(name_bb,Fname,Sname,Tname,Lname,Gender,Address,Position,BDate,HDate) values('TANBB','kareem','AHMEF','REDA','R','S','GTBEGTGK','1-3-2038','5-6-1980');
insert into Employee(name_bb,Fname,Sname,Tname,Lname,Gender,Address,Position,BDate,HDate) values('TANBB','kareem','AHMEF','REDA','R','S','GTBEGTGK','1-3-2038','5-6-1980');
insert into Employee(name_bb,Fname,Sname,Tname,Lname,Gender,Address,Position,BDate,HDate) values('TANBB','kareem','AHMEF','REDA','R','S','GTBEGTGK','1-3-2038','5-6-1980');

----Insert Into Nurse Table----
insert into Nurse(Fname,Sname,Tname,Lname,Gender,Address,BDate,HDate,Email)VALUES('AMIRA','MOTWA','CQJV','QGVR'.'F','VWKVWKUV','1-3-2038','5-6-198','amira.com');
insert into Nurse(Fname,Sname,Tname,Lname,Gender,Address,BDate,HDate,Email)VALUES('AMIRA','MOTWA','CQJV','QGVR'.'F','VWKVWKUV','1-3-2038','5-6-198','amira.com');
insert into Nurse(Fname,Sname,Tname,Lname,Gender,Address,BDate,HDate,Email)VALUES('AMIRA','MOTWA','CQJV','QGVR'.'F','VWKVWKUV','1-3-2038','5-6-198','amira.com');
insert into Nurse(Fname,Sname,Tname,Lname,Gender,Address,BDate,HDate,Email)VALUES('AMIRA','MOTWA','CQJV','QGVR'.'F','VWKVWKUV','1-3-2038','5-6-198','amira.com');
insert into Nurse(Fname,Sname,Tname,Lname,Gender,Address,BDate,HDate,Email)VALUES('AMIRA','MOTWA','CQJV','QGVR'.'F','VWKVWKUV','1-3-2038','5-6-198','amira.com');
insert into Nurse(Fname,Sname,Tname,Lname,Gender,Address,BDate,HDate,Email)VALUES('AMIRA','MOTWA','CQJV','QGVR'.'F','VWKVWKUV','1-3-2038','5-6-198','amira.com');
insert into Nurse(Fname,Sname,Tname,Lname,Gender,Address,BDate,HDate,Email)VALUES('AMIRA','MOTWA','CQJV','QGVR'.'F','VWKVWKUV','1-3-2038','5-6-198','amira.com');
insert into Nurse(Fname,Sname,Tname,Lname,Gender,Address,BDate,HDate,Email)VALUES('AMIRA','MOTWA','CQJV','QGVR'.'F','VWKVWKUV','1-3-2038','5-6-198','amira.com');
insert into Nurse(Fname,Sname,Tname,Lname,Gender,Address,BDate,HDate,Email)VALUES('AMIRA','MOTWA','CQJV','QGVR'.'F','VWKVWKUV','1-3-2038','5-6-198','amira.com');

----Delete----
DELETE from Doctor where Address='Sohag';
DELETE top(2) from Donor;
DELETE top(1) percent from Donor;
Delete from Doctor where DATEDIFF(year,BDate,GETDATE())>=60 ;
Delete from Nurse where DATEDIFF(year,BDate,GETDATE())>=60 ;
Delete from Employee where DATEDIFF(year,BDate,GETDATE())>=60 ;

----Set Salary For Doctor----
UPDATE Doctor
SET Salary=5000
where DATEDIFF(year,HDate,GETDATE())<=2 ;
UPDATE Doctor
SET Salary=7000
where DATEDIFF(year,HDate,GETDATE())<=5 and DATEDIFF(year,HDate,GETDATE())>=3 ;
UPDATE Doctor
SET Salary=9000
where DATEDIFF(year,HDate,GETDATE())<=10 and DATEDIFF(year,HDate,GETDATE())>=6 ;
UPDATE Doctor
SET Salary=11000
where DATEDIFF(year,HDate,GETDATE())<=15 and DATEDIFF(year,HDate,GETDATE())>=11 ;
UPDATE Doctor
SET Salary=17000
where DATEDIFF(year,HDate,GETDATE())>=15;

----Set Salary For Employee----
UPDATE Employee
SET Salary=5000
where DATEDIFF(year,HDate,GETDATE())<=2 ;
UPDATE Employee
SET Salary=6000
where DATEDIFF(year,HDate,GETDATE())<=5 and DATEDIFF(year,HDate,GETDATE())>=3 ;
UPDATE Employee
SET Salary=7000
where DATEDIFF(year,HDate,GETDATE())<=10 and DATEDIFF(year,HDate,GETDATE())>=6 ;
UPDATE Employee
SET Salary=8000
where DATEDIFF(year,HDate,GETDATE())<=15 and DATEDIFF(year,HDate,GETDATE())>=11 ;
UPDATE Employee
SET Salary=10000
where DATEDIFF(year,HDate,GETDATE())>=5;

----Set Salary For Nurse----
UPDATE Nurse
SET Salary=5000
where DATEDIFF(year,HDate,GETDATE())<=2 ;
UPDATE Nurse
SET Salary=6500
where DATEDIFF(year,HDate,GETDATE())<=5 and DATEDIFF(year,HDate,GETDATE())>=3 ;
UPDATE Nurse
SET Salary=8000
where DATEDIFF(year,HDate,GETDATE())<=10 and DATEDIFF(year,HDate,GETDATE())>=6 ;
UPDATE Nurse
SET Salary=9500
where DATEDIFF(year,HDate,GETDATE())<=15 and DATEDIFF(year,HDate,GETDATE())>=11 ;
UPDATE Nurse
SET Salary=20000
where DATEDIFF(year,HDate,GETDATE())>=5;

----Select All Data----
SELECT * from BloodBank order by Name asc;
SELECT * from Doctor order by HDate asc;
SELECT * from Blood_Sample order by ID asc;
SELECT * from Donor order by ID asc;
SELECT * from Nurse order by ID asc;
SELECT * from Employee order by ID asc;
SELECT * from Department order by ID asc;

----Select Specific Value----
SELECT Fname from Doctor order by ID desc;
SELECT Salary from Nurse order by Lname desc;

----Select Specific Values----
SELECT ID,Fname,Sname,Tname,Lname from Doctor;
SELECT ID,Sname,Tname,Lname from Nurse;
SELECT Fname,Sname,Tname,Lname from NurseRelative;
SELECT ID,Fname,Sname,Tname,Lname from Employee;
SELECT Sname,Tname,Lname from EmpRelative;
SELECT ID,Fname,Sname,Tname,Lname from Donor;

----Between Like In----
SELECT Fname from Doctor where id between 1 and 5;
SELECT Sname from Nurse where Lname like 'j%';
SELECT Fname from Employee where ID IN (3,5,7);

----Join----
SELECT ID_Don,Nurse.Fname from Nurse_Don inner join Nurse ON ID = ID_Nurse;
SELECT Doctor.* , Phone from Doctor left join DocPhone on ID_Doc = ID;   
SELECT Donor.* , Phone from Donor left join DonPhone on ID_Don = ID; 
SELECT Nurse.* , Phone from NursePhone right join Nurse on ID_Nurse = ID; 
SELECT Employee.* , Phone from EmpPhone right join Employee on ID_Emp = ID;

----Functions----
select ID,Doctor.Fname,Doctor.Lname,COUNT(DocRelative.id_doc) from Doctor left join DocRelative on id_doc=ID group by ID,Doctor.Fname,Doctor.Lname;
select ID,Nurse.Fname,Nurse.Lname,COUNT(NurseRelative.id_nurse) from Nurse left join NurseRelative on id_nurse=ID group by ID,Nurse.Fname,Nurse.Lname;
select ID,Employee.Fname,Employee.Lname,COUNT(EmpRelative.id_emp) from Employee left join EmpRelative on id_emp=ID group by ID,Employee.Fname,Employee.Fname;
select ID, MIN(BDate) from Doctor group by ID;
select ID, MAX(Salary) from Employee group by ID;
select ID, AVG(Salary) from Nurse group by ID;
select sum(Salary) from Employee;

----Having----
select ID,Doctor.Fname,Doctor.Sname,COUNT(DocRelative.id_doc) from Doctor left join DocRelative on ID=id_doc group by ID,Doctor.Fname,Doctor.Sname having count(DocRelative.id_doc)<4;
select ID,Employee.Fname,Employee.Sname,COUNT(EmpRelative.id_emp) from Employee left join EmpRelative on ID=id_emp group by ID,Employee.Fname,Employee.Sname having count(EmpRelative.id_emp)<4;

----Subquery----
create table test(
fname varchar(20),
lname varchar(20),
);
insert into test select Fname,Sname from Doctor;
select * from Doctor where Salary<(select MAX(Salary) from Employee);
delete from Doctor where Salary=(select MAX(Salary) from Doctor);


