--1
DECLARE cur1 CURSOR
FOR SELECT Fname , Salary FROM Employee
FOR UPDATE

DECLARE @name VARCHAR(50), @salary INT
OPEN cur1
FETCH cur1 INTO @name , @salary
BEGIN
	WHILE @@FETCH_STATUS = 0
		BEGIN
			IF(@salary < 3000)
				BEGIN
				UPDATE Employee SET salary *= 1.1
				WHERE CURRENT OF cur1
				END
			ELSE
				BEGIN
					UPDATE EMPLOYEE SET salary *= 1.2
					WHERE CURRENT OF cur1
				END
	FETCH cur1 INTO @name , @salary
		END
END
CLOSE cur1
DEALLOCATE cur1


--2
DECLARE cur2 CURSOR
FOR SELECT Dname , Fname FROM Employee e JOIN Departments d ON e.SSN = d.MGRSSN
FOR READ ONLY

DECLARE @dname VARCHAR(50) , @fname VARCHAR(50)
OPEN cur2
FETCH cur2 INTO @dname , @fname
BEGIN
	WHILE (@@FETCH_STATUS = 0)
		BEGIN
			SELECT @dname  , @fname
			FETCH cur2 INTO @dname , @fname
		END
END
CLOSE cur2
DEALLOCATE cur2


--3
DECLARE cur3 CURSOR
FOR SELECT Fname FROM Employee
FOR READ ONLY

DECLARE @fnamee VARCHAR(50) , @names VARCHAR(300)=''
OPEN cur3
FETCH cur3 INTO @fnamee
	BEGIN
		WHILE (@@FETCH_STATUS = 0)
			BEGIN
				SET @names = CONCAT(ISNULL(@names,'') , ' , ' , @fnamee)
				FETCH cur3 INTO @fnamee
			END
	SELECT @names
	END
CLOSE cur3
DEALLOCATE cur3


--4
CREATE SEQUENCE s1
START WITH 1
INCREMENT BY 1
minValue 1
maxValue 10
NO CYCLE

INSERT INTO Project VALUES ('DB' , NEXT VALUE FOR s1 , 'ZAG' , 'ZAG' , 30 , 1500)

--5 
/*SELECT name, physical_name
FROM sys.database_files
WHERE type_desc = 'ROWS';*/

CREATE DATABASE Company_SD_Snap
ON
(
    NAME = Company_SD,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Company_SD_Snap.ss'
)
AS SNAPSHOT OF Company_SD;

USE Company_SD_Snap
SELECT * FROM Employee


--6.1
CREATE PROC getMonth @date DATE
AS
	SELECT MONTH(@date)

getMonth @date = '2003-07-10'


--6.2
ALTER PROC numbersBetween  @n1 INT , @n2 INT
AS
BEGIN
    DECLARE @result TABLE (Number INT);
    WHILE (@n1 < @n2 - 1)
    BEGIN
        SET @n1 = @n1 + 1;
        INSERT INTO @result VALUES (@n1);
    END
    SELECT * FROM @result;
END

numbersBetween 1, 5 


--6.3
CREATE PROC getDeptName @sId INT
AS
BEGIN
	DECLARE @result1 TABLE (col1 VARCHAR(50) , col2 VARCHAR(60))
	INSERT INTO @result1 
			SELECT Dept_Name , CONCAT(St_Fname , ' ' , St_Lname) as Fullname
			FROM Department JOIN Student
			ON Department.Dept_Id = Student.Dept_Id
			WHERE Student.St_Id = @sId

	SELECT * FROM @result1
END


--6.4
CREATE PROC getLog @Id INT
AS
BEGIN
	DECLARE @fname VARCHAR(10), @lname VARCHAR(10)

	SELECT @fname = St_Fname , @lname = St_Lname FROM Student WHERE St_Id = @Id

	 IF (@fname IS NULL AND @lname IS NULL)
        SELECT'First name & last name are null';
    ELSE IF (@fname IS NULL)
        SELECT 'first name is null';
    ELSE IF (@lname IS NULL)
        SELECT'last name is null';
    ELSE
        SELECT 'First name & last name are not null';
	SELECT '';

END


--6.5
CREATE PROC getInfo @mgrId INT
AS
BEGIN
	DECLARE @t1 TABLE (c1 VARCHAR(50),c2 VARCHAR(50),c3 INT)
	
	INSERT INTO @t1
		SELECT 
	        d.Dept_Name,
	        i.Ins_Name,
	        d.Manager_hiredate
	    FROM Department d
	    JOIN Instructor i
	        ON d.Dept_Manager = i.Ins_Id
	    WHERE i.Ins_Id = @mgrId

	SELECT * FROM @t1
END

--6.6
CREATE PROC getStudentName @type VARCHAR(50)
AS
BEGIN
	DECLARE @t2 TABLE (c1 VARCHAR(50))
	IF (@type = 'first name')
    BEGIN
        INSERT INTO @t2
        SELECT ISNULL(St_Fname, ' ')
        FROM Student;
    END

    ELSE IF (@type = 'last name')
    BEGIN
        INSERT INTO @t2
        SELECT ISNULL(St_Lname, ' ')
        FROM Student;
    END
    ELSE IF (@type = 'full name')
    BEGIN
        INSERT INTO @t2
        SELECT 
            ISNULL(St_Fname, '') + ' ' + ISNULL(St_Lname, '')
        FROM Student;
    END

    SELECT * from @t2;
END


--7.1  Full Backup
BACKUP DATABASE Company_SD
TO DISK = 'D:\DBs\Company_SD.bak'
--WITH INIT;

--7.2 Differential Backup
BACKUP DATABASE Company_SD
TO DISK = 'D:\DBs\Company_SD_Diff.bak'
WITH DIFFERENTIAL--, INIT;

SELECT * FROM Departments 
SELECT * FROM Employee
SELECT * FROM Dependent
SELECT * FROM Project