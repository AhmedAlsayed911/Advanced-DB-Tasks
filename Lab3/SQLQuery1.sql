use ITI
--1--
create view vstudent
as
select s.St_Fname+' '+s.St_Lname as FullName , c.Crs_Name , sc.Grade
from Student s join Stud_Course  sc
on s.St_Id=sc.St_Id
join Course c
on c.Crs_Id=sc.Crs_Id where sc.Grade>=50

select * from vstudent



--2-Create an Encrypted view that displays manager names and the topics they teach

create view vmgr_topic
with encryption
as
select i.Ins_Name,t.Top_Name
from Instructor i join Ins_course isc
on i.Ins_id=isc.Ins_id
join course c
on c.Crs_id=isc.Crs_id
join topic t
on t.Top_id=c.Top_id
where i.Ins_id in (select Dept_manager from Department)



--3-Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department.
create view vinstructor 
as
select Ins_Name,Dept_Name
from Instructor i join Department d
on i.Dept_Id=d.Dept_Id
where Dept_Name in('SD','Java')

select * from vinstructor





--4Create a view “V1” that displays student data for student who lives in Alex or Cairo
use ITI
create view cairo_or_alex
as 
select * from Student where St_Address='Cairo'
or St_Address='Alex' with check option;


--
Use Company_SD
--5Create a view that will display the project name and the number of employees who work on it. “Use SD database”
create view vproject
as
select p.ProjectName, sum(EmpNo) as NumOfEmps
from Company.Project p join dbo.Works_for w
on p.ProjectNo=w.ProjectNo
group by p.ProjectName

select * from vproject


--6 --
use ITI
create clustered index hd_idx on Department(Manager_hiredate)
--error

--7

create unique nonclustered index age_idx on Student(St_age)
--error

--8  Using MERGE statement between the following two tables [User ID, Transaction Amount]
create database New_DB
use New_DB

create table lasttransaction(
UserID int Primary key,
Amount money
)
go
create table dailytransaction(
UserID int Primary key,
Amount money
)
insert into lasttransaction values
(1,4000),(4,2000),(2,10000)

insert into dailytransaction values
(1,1000),(2,2000),(3,1000)

merge into lasttransaction as t using dailytransaction as s on T.UserID=s.UserID
when matched then  update set t.Amount=s.Amount
when not matched then
insert values(s.UserID,s.Amount);

select * from lasttransaction
-----------------------------------------------




use Company_SD
--1
create view v_clerk
as
select e.EmpNo,p.ProjectNo,Enter_Date
from [HumanResource].[Employee] e
join
dbo.Works_on w
on e.EmpNo=w.EmpNo
join
Company.Project p
on p.ProjectNo=w.ProjectNo
where job='clerk'

select * from v_clerk

--2---
create view v_without_budget
as
select * from company.Project
where Budget is null

select * from v_without_budget



--3--
create view v_count
as
select ProjectName, count(Job) jobscount
from [Company].[Project] p join Works_on w
on p.ProjectNo=w.ProjectNo
group by ProjectName

select * from v_count

--4--
create view v_project_p2
as
select * from v_clerk v
where v.ProjectNo='p2'

select * from v_project_p2


--5--
alter view v_without_budget
as
select * from Company.Project
where Budget is null
and ProjectNo in('p1','p2')

select * from v_without_budget


--6 --
drop view v_clerk
drop view v_count

--7----
create view vEmp_D2
as
select EmpNo, EmpLname
from [HumanResource].[Employee]
where DeptNo = 'd2';

select * from vEmp_D2

--8--
select EmpLname
from vEmp_D2
where EmpLname like '%j%';
--

--9
create view v_dept
as
select deptno, deptname
from company.department;

select * from v_dept

--10
insert into v_dept
values ('d4', 'development');
--

--11
create view v_2006_check
as
select empno, projectno, enter_date
from works_on
where enter_date between '2006-01-01' and '2006-12-31';
select * from v_2006_check