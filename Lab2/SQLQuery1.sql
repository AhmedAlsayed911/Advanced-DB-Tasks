-- Task 1: Return month name from date
CREATE FUNCTION getMonth(@date DATE)
	RETURNS NVARCHAR(20)
AS
BEGIN
	RETURN FORMAT(@date,'MMMM')
END

GO
SELECT dbo.getMonth('2003-07-10')

-- Task 2: Return values between two numbers
CREATE FUNCTION numbersBetween(@x INT , @y INT)
	RETURNS @t TABLE (col1 INT)
AS
BEGIN
	WHILE(@x < @y)
	BEGIN
	SET @x += 1;
	if(@x < @y)
		INSERT INTO @t VALUES (@x);
	else
		BREAK;
	END
	RETURN;
END
DROP FUNCTION numbersBetween
GO
SELECT * FROM numbersBetween(1,5);

-- Task 3: Get department and full student name by student id
CREATE FUNCTION getDeptName(@sNo INT)
	RETURNS TABLE
AS
	RETURN
	(
		SELECT Dept_Name , CONCAT(St_Fname , ' ' , St_Lname) as Fullname
			FROM Department JOIN Student
			ON Department.Dept_Id = Student.Dept_Id
			WHERE Student.St_Id = @sNo
	)

GO
SELECT * FROM getDeptName(1)

-- Task 4: Return null-state log for student names
CREATE FUNCTION getLog(@sId INT)
	RETURNS VARCHAR(50)
AS
BEGIN

	DECLARE @fname VARCHAR(10), @lname VARCHAR(10)

	SELECT @fname = St_Fname , @lname = St_Lname FROM Student WHERE St_Id = @sId

	 IF (@fname IS NULL AND @lname IS NULL)
        RETURN'First name & last name are null';
    ELSE IF (@fname IS NULL)
        RETURN 'first name is null';
    ELSE IF (@lname IS NULL)
        RETURN'last name is null';
    ELSE
        RETURN 'First name & last name are not null';
	RETURN '';
END

GO
SELECT dbo.getLog(1)

-- Task 5: Return department manager information
CREATE FUNCTION dbo.getInfo(@mgrId INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        d.Dept_Name,
        i.Ins_Name,
        d.Manager_hiredate
    FROM Department d
    JOIN Instructor i
        ON d.Dept_Manager = i.Ins_Id
    WHERE i.Ins_Id = @mgrId
);


GO
SELECT * FROM dbo.getInfo(1)

-- Task 6: Return requested student name format
CREATE FUNCTION dbo.GetStudentName(@type NVARCHAR(20))

RETURNS @t TABLE(StudentName NVARCHAR(100))
AS
BEGIN
    IF (@type = 'first name')
    BEGIN
        INSERT INTO @t
        SELECT ISNULL(St_Fname, ' ')
        FROM Student;
    END

    ELSE IF (@type = 'last name')
    BEGIN
        INSERT INTO @t
        SELECT ISNULL(St_Lname, ' ')
        FROM Student;
    END
    ELSE IF (@type = 'full name')
    BEGIN
        INSERT INTO @t
        SELECT 
            ISNULL(St_Fname, '') + ' ' + ISNULL(St_Lname, '')
        FROM Student;
    END
    RETURN;
END;

GO
SELECT * FROM dbo.GetStudentName('first name');


-- Task 7: Show first name without final character
SELECT  St_Id AS StudentNo,SUBSTRING(St_Fname, 1, LEN(St_Fname) - 1) 
FROM Student;

-- Task 8: Delete student course rows by department
DELETE c
FROM Stud_Course c
JOIN Student s
    ON c.St_Id = s.St_Id
JOIN Department d
    ON s.Dept_Id = d.Dept_Id
WHERE d.Dept_Name = 'SD';

--Bonus.1
CREATE TABLE Hierachy
(
    Id INT PRIMARY KEY,
    Name NVARCHAR(50),
    Node hierarchyid
);

INSERT INTO Hierachy
VALUES (1, 'Root', hierarchyid::GetRoot());


INSERT INTO Hierachy
VALUES (2, 'Child1', hierarchyid::Parse('/1/'));

INSERT INTO Hierachy
VALUES (3, 'Child2', hierarchyid::Parse('/2/'));

SELECT Name, Node.GetLevel() AS Level
FROM Hierachy;

--Bonus.2
DECLARE @id INT = 3000;
WHILE @id < 6000
BEGIN
    INSERT INTO Student (st_id, st_fname, st_lname)
    VALUES (@id, 'Jane', 'Smith');

    SET @id = @id + 1;
END;
GO

SELECT COUNT(*) FROM Student


SELECT* FROM Department
SELECT * FROM Student
SELECT * FROM Instructor
SELECT * FROM Course
SELECT * FROM Stud_Course