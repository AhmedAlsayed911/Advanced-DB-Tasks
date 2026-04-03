--1
ALTER PROC NumberOfStudentsPerDept
AS
BEGIN
	SELECT d.Dept_Name , COUNT(s.St_Id) as CountOfStudents
	FROM Department d JOIN Student s
	ON s.Dept_Id = d.Dept_Id
	GROUP BY d.Dept_Name
END
NumberOfStudentsPerDept


--2
CREATE PROC CheckNumberOfEmloyees @p1 VARCHAR(50)
AS
BEGIN
	DECLARE @empCount INT;
	SELECT @empCount = COUNT(e.SSN)
	FROM Employee e JOIN Works_for w
	ON e.SSN = w.ESSn
	JOIN
	Project p
	ON w.Pno = p.Pnumber
	WHERE Pname = @p1
	IF(@empCount > 3)
		SELECT 'The number of employees in the project p1 is 3 or more'
	ELSE
	BEGIN
		SELECT 'The following employees work for the project p1'
		SELECT CONCAT(e.Fname , ' ' , e.Lname)
		FROM Employee e JOIN Works_for w
		ON e.SSN = w.ESSn
		JOIN
		Project p
		ON w.Pno = p.Pnumber
		WHERE Pname = @p1
	END
END
CheckNumberOfEmloyees @p1 = 'AL Solimaniah'


--3
CREATE PROC ReplaceEmployeeInProject  @OldEmpNo INT, @NewEmpNo INT, @ProjectNo INT
AS
BEGIN
    UPDATE Works_for
    SET ESSn = @NewEmpNo
    WHERE ESSn = @OldEmpNo
    AND Pno = @ProjectNo;
END
ReplaceEmployeeInProject @OldEmpNo = 112233 , @NewEmpNo = 102660 , @ProjectNo = 100


--4
ALTER TABLE Project ADD Budget INT 
UPDATE Project SET Budget = 1000
WHERE Budget is NULL

CREATE TABLE Audit
(
	ProjectNo INT,
	UserName VARCHAR(50),
	ModifiedDate DATETIME,
	Budget_Old INT,
	Budget_New INT
)

CREATE TRIGGER trg_UpdateBudgetEvent
ON Project
AFTER UPDATE
AS
BEGIN
	IF UPDATE(Budget)
	BEGIN
		INSERT INTO Audit(ProjectNo ,UserName ,ModifiedDate ,Budget_Old ,Budget_New ) 
			SELECT d.Pnumber , SUSER_NAME() , GETDATE() , d.Budget , i.Budget
		FROM deleted d
        JOIN inserted i
		ON d.Pnumber = i.Pnumber
	END
END

UPDATE Project SET Budget = 2000 WHERE Pname = 'AL Solimaniah'
SELECT * FROM Audit


--5
CREATE TRIGGER PreventInserting 
ON Department
INSTEAD OF INSERT
AS
	 SELECT 'Cannott insert a new Record in this table'

--6
ALTER TRIGGER PreventInsertionInMarch
ON Employee
INSTEAD OF INSERT 
AS
	BEGIN
		IF MONTH(GETDATE()) = 3
			SELECT 'cannot insert a new record in employees in march'
		else
			BEGIN
				INSERT INTO Employee
				SELECT * FROM inserted
			END
	END


--7
CREATE TABLE StudentAudit
(
	UserName VARCHAR(50),
	AuditDate DATETIME,
	NOTE VARCHAR (50)
)

CREATE TRIGGER trg_Student_Insert
ON Student
AFTER INSERT
AS
BEGIN
    INSERT INTO StudentAudit (UserName, AuditDate, Note)
    SELECT 
        SUSER_SNAME(),
        GETDATE(),
        SUSER_SNAME() + 
        ' Insert New Row with Key=' + CAST(i.St_Id AS VARCHAR(20))
    FROM INSERTED i;
END;

--8
CREATE TRIGGER StudentLogger
ON Student
INSTEAD OF DELETE 
AS
	BEGIN
		INSERT INTO StudentAudit(UserName , AuditDate , NOTE) 
		SELECT SUSER_NAME() , GETDATE() , 'User tried to delete row with Key '+ CAST(d.St_Id AS VARCHAR(20))
		FROM DELETED d
	END
	


SELECT * FROM Student
SELECT * FROM Department
SELECT * FROM Works_for
SELECT * FROM Employee
SELECT * FROM Project
