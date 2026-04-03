--1
CREATE TABLE Department
(
	DeptNo int PRIMARY KEY,
	DeptName VARCHAR(20),
	Location nchar(2) 
)

sp_addtype loc, 'nchar(2)'

create rule r_loc
as @x in ('NY','DS','KW')

create default def_loc as 'NY'

sp_bindrule r_loc, loc
sp_bindefault def_loc, loc


create table Department
(
    DeptNo   int primary key,
    DeptName varchar(20),
    Location loc
)
insert into Department (DeptNo,DeptName) values (1,'HR') 
insert into Department values (2,'IT','CA')
insert into Department values (2,'IT','KW')


--3
CREATE TABLE Employee
(
	EmpNo INT PRIMARY KEY,
	Fname VARCHAR(20) NOT NULL,
	Lname VARCHAR(20) NOT NULL,
	DeptnNo INT ,
	Salary INT UNIQUE,

	CONSTRAINT C1 FOREIGN KEY(DeptnNo) references Department(DeptNo),
)

CREATE rule l_sal as @x < 6000;
sp_bindrule l_sal, 'Employee.Salary';

INSERT INTO Employee VALUES (1,'Test','User',10,7000); 
INSERT INTO Employee VALUES (1,'Ahmed','Sayed',1,5999) 
INSERT INTO Employee VALUES (2,'Mohamed','Hamdy',50,5000);


INSERT INTO Project VALUES (1,'DbEngine',150000) , (2,'FrontPage',10000)

INSERT INTO Works_For (EmpNo, ProjectNo, Job) VALUES (1, 1, 'Manager');
INSERT INTO Works_For (EmpNo, ProjectNo, Job) VALUES (2, 2, 'Employee');
INSERT INTO Works_For (EmpNo, ProjectNo, Job) VALUES (11111, 2, 'Employee'); 

ALTER TABLE Employee ADD TelephoneNumber varchar(15);
ALTER TABLE Employee DROP COLUMN TelephoneNumber

--2
CREATE SCHEMA Company

ALTER SCHEMA Company TRANSFER dbo.Department

CREATE SCHEMA HumanResouces
ALTER SCHEMA HumanResouces TRANSFER dbo.Employee

--4
CREATE SYNONYM emp FOR [MyDB].[HumanResouces].Employee

SELECT * FROM Employee
Select * from [HumanResouces].Employee
SELECT * FROM emp
SELECT * FROM [HumanResouces].emp


--5
UPDATE Company.Project
SET p.Budget = p.Budget * 1.10
FROM Company.Project p , Works_on w
WHERE p.ProjectNo = w.ProjectNo AND w.EmpNo = 10102 AND w.Job = 'Manager';


--6
UPDATE D SET D.DeptName = 'Sales'
from [Company].Department D
JOIN emp E
	on D.DeptNo = E.DeptNo
WHERE E.Fname = 'James'

--7
UPDATE W
SET W.Enter_Date = '2007-12-12'
FROM Works_For W
JOIN emp E
    ON W.EmpNo = E.EmpNo
JOIN [Company].Department D
    ON E.DeptnNo = D.DeptNo
WHERE W.ProjectNo = 1
  AND D.DeptName = 'Sales';

--8
DELETE W
FROM Works_For W
JOIN emp E
    ON W.EmpNo = E.EmpNo
JOIN [Company].Department D
    ON E.DeptnNo = D.DeptNo
WHERE D.Location = 'KW';


--9
SELECT SYSTEM_USER AS CurrentLogin;
ALTER AUTHORIZATION 
ON DATABASE::MyDB 
TO sa;
