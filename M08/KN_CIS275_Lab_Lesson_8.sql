/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 8: using SQL SERVER and CIS275Sandboxx
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance, such as seeing answers to  versions of specific 
questions or using AI to get answers. I agree to abide by class restrictions and understand 
that if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   Kyle Noyes
                DATE:      August 11 2024

*******************************************************************************************
*/

GO
PRINT '|---' + REPLICATE('+----',15) + '|'
PRINT 'Read the questions below and insert your code where prompted. When you are finished,
you should be able to run the file as a script to execute all answers sequentially (without errors!).

This week, there are seven questions worth 30 points total. The point totals for each 
question depend on the difficulty of the question. 
Please be sure to answer each part of each question for full credit.

All SQL should be properly formatted as in previous weeks.';
PRINT '|---' + REPLICATE('+----',15) + '|' + CHAR(10) + CHAR(10)
GO

PRINT 'CIS 275, Lab Week 8, Question 1  [5 pts possible]:
Create tables
-------------
Review your project 7. If you never finished it, email your instructor.
Pick three related tables you identified for the hospital system. 
Create those tables within the CIS275Sandboxx database. Here are things you need to follow:
1- All table names must start with your initials, such as GSF_Nurses. If they exist (another 
   student has the same initials), add a number to the end of your initials to make it unique.
2- Add all your columns. The columns must be identical to the columns you proposed 
   in your lab 7, with any corrections based on the feedback.
3- All your primary and foreign keys must be identified.

You have the permissions required to create tables in the CIS275Sandboxx database.
You cannot create Databases.
' + CHAR(10)

GO



--

/* [DEBUG]

Remove any exisiting data 
USE		CIS275Sandboxx
IF OBJECT_ID('KN_Doctors', 'U') IS NOT NULL
	DROP TABLE KN_Doctors
IF OBJECT_ID('KN_Patients', 'U') IS NOT NULL
	DROP TABLE KN_Patients
IF OBJECT_ID('KN_Nurses', 'U') IS NOT NULL
	DROP TABLE KN_Nurses
IF OBJECT_ID('KN_Rooms', 'U') IS NOT NULL
	DROP TABLE KN_Rooms
IF OBJECT_ID('KN_Departments', 'U') IS NOT NULL
	DROP TABLE KN_Departments;
IF OBJECT_ID('KN_Department_Overview', 'V') IS NOT NULL
	DROP VIEW KN_Department_Overview;

Open created view
USE		CIS275Sandboxx
SELECT	*
FROM	KN_Department_Overview

*/

USE		CIS275Sandboxx
CREATE TABLE	KN_Departments
	(DepartmentID	NUMERIC(5,0) PRIMARY KEY IDENTITY (1,1),
	NetworkID		NUMERIC	NOT NULL,
	RegionID		INTEGER NOT NULL,
	PrimaryUnit		VARCHAR(256),
	Speciality		VARCHAR(256) NOT NULL,
	CareLevel		INTEGER,
	TraumaLevel		NUMERIC,
	PrimaryStaffLevel INTEGER NOT NULL,
	StaffNum		INTEGER NOT NULL,
	DeptLocation	VARCHAR(256),
	)

CREATE TABLE	KN_Patients
	(PatientID		INTEGER PRIMARY KEY IDENTITY (1,1),
	PatientName		VARCHAR(256),
	DateAdmitted	DATETIME,
	DOB				DATETIME,
	AddressHome		VARCHAR(256),
	PhoneNum		INTEGER,
	FK_DepartmentID NUMERIC(5,0) FOREIGN KEY REFERENCES KN_Departments (DepartmentID),
	TraumaLevel		INTEGER
	)

CREATE TABLE	KN_Doctors
	(DoctorID		INTEGER PRIMARY KEY IDENTITY (1,1),
	DoctorName		VARCHAR(256),
	AddressHome		VARCHAR(256),
	HomePhone		INTEGER,
	OnCallPhone		INTEGER,
	DoctorSpecialty	VARCHAR(256),
	FK_PrimaryDeptID NUMERIC(5,0) FOREIGN KEY REFERENCES KN_Departments (DepartmentID)
	);

/*
CREATE TABLE	KN_Rooms
	(RoomNum		INTEGER PRIMARY KEY IDENTITY (1,1),
	FloorNum		INTEGER,
	FK_DepartmentID	INTEGER FOREIGN KEY REFERENCES KN_Departments,
	FK_CareLevel	INTEGER FOREIGN KEY REFERENCES KN_Departments,
	MobilityRating	INTEGER,
	SpecialEquip	VARCHAR(256)
	);
*/
--

GO
PRINT 'CIS 275, Lab Week 8, Question 2  [3 pts possible]:
Adding columns
-----------
Add two more columns to each of two of the tables you created.

' + CHAR(10)

GO

--

USE		CIS275Sandboxx
ALTER TABLE	KN_Patients
ADD			NamePref VARCHAR(256);
ALTER TABLE KN_Patients
ADD			Gender VARCHAR(256);

ALTER TABLE	KN_Departments
ADD			DeptManager VARCHAR(256);
ALTER TABLE KN_Departments
ADD			DeptCreated DATETIME;

ALTER TABLE	KN_Doctors
ADD			DoctorAge INTEGER;
ALTER TABLE KN_Doctors
ADD			DateHired DATETIME;

--

GO
PRINT 'CIS 275, Lab Week 8, Question 3  [3 pts possible]:
Adding data
-----------
Use INSERT INTO to add four records to each of the tables you created in Question 1.
You need meaningful data (not things like MMMMM!).

' + CHAR(10)

GO

--

USE		CIS275Sandboxx
INSERT INTO	KN_Departments
	(NetworkID, RegionID, PrimaryUnit, Speciality, CareLevel, TraumaLevel, PrimaryStaffLevel, StaffNum, DeptLocation, DeptManager, DeptCreated) VALUES 
	(145, 0056, 'Longterm Care', 'Rehabilitation', 2, 1, 3, 125, 'West Wing', 'Jarrod Sorchaff', '1995-01-01'),
	(050, 0049, 'Intensive Care', 'Trauma Emergency', 5, 5, 4, 57, 'Center Rotunda', 'Liu Park', '2004-05-01'),
	(105, 1803, 'Strength Building', 'Physical Therapy', 2, 1, 2, 12, 'East Wing', 'Jennifer Parce', '2012-05-01'),
	(094, 1005, 'Childrens Ward', 'Pediatric Medicine', 3, 2, 3, 27, 'Jones Wing', 'Hailey Knaff', '2004-05-01')


INSERT INTO	KN_Patients
	(PatientName, DateAdmitted, DOB, AddressHome, PhoneNum, TraumaLevel, FK_DepartmentID, NamePref, Gender) VALUES 
	('Rebecca Jones', '2024-08-05', '1998-12-05', '5071 Oak Dr', 1557831960, 2, 1, 'Becca', 'Female'),
	('Jefery Willis', '2024-08-02', '1967-09-12', '6837 Ellis Pkwy', 2092348512, 4, 2, NULL, 'Male'),
	('Zakkary Smith', '2024-08-06', '2001-05-29', '74 Sidewick St', 1017693684, 1, 4,  NULL, 'Male'),
	('Jefery Willis', '2024-08-02', '1978-02-14', '6837 Ellis Pkwy', 2092348512, 2, 1, 'Tiff', 'Female');


INSERT INTO	KN_Doctors
	(DoctorName, AddressHome, HomePhone, OnCallPhone, DoctorSpecialty, FK_PrimaryDeptID, DoctorAge, DateHired) VALUES 
	('Liu Park', '5023 Edmond St', 1009437432, 1028005437, 'Pediatric', 1, 57, '1999-12-15'),
	('Stevens William', '12 Outreach Dr', 1078219921, 1028001667, 'GeneralPractice', 4, 37, '2018-05-01'),
	('Harold Zynorsky', '9954 Newfound Pkwy', 1967834467, 1028007702, 'Oncology', 3, 43, '2005-07-18'),
	('Susan Gillford', '12 Grahams St', 2119571143, 1028008846, 'Trauma', 2, 51, '2000-09-04');

--

GO
PRINT 'CIS 275, Lab Week 8, Question 4  [3 pts possible]:
Drop a column
---------------------
Drop one column from one of the tables.
' + CHAR(10)

GO

--

USE		CIS275Sandboxx
ALTER TABLE	KN_Doctors
DROP COLUMN	OnCallPhone;

--

GO
PRINT 'CIS 275, Lab Week 8, Question 5  [4 pts possible]:
Add a new table
-------------
Pick another table from your last project and add it to the database with all its columns. 
Once again, all tables must start with your initials. Add three records to this table.
' + CHAR(10)

GO

--

USE		CIS275Sandboxx
CREATE TABLE	KN_Nurses
	(NurseID		INTEGER PRIMARY KEY IDENTITY (1,1),
	NurseName		VARCHAR(256),
	AddressHome		VARCHAR(256),
	HomePhone		INTEGER,
	FK_PrimaryUnit	NUMERIC(5,0) FOREIGN KEY REFERENCES KN_Departments (DepartmentID),
	Speciality		VARCHAR(256),
	FK_StaffLevel	NUMERIC(5,0) FOREIGN KEY REFERENCES KN_Departments (DepartmentID),
	FK_PrimaryDoctorID	INTEGER FOREIGN KEY REFERENCES KN_Doctors (DoctorID),
	FK_TraumaLevel	NUMERIC(5,0) FOREIGN KEY REFERENCES KN_Departments (DepartmentID),
	CareLevel		INTEGER
	);

--

GO
PRINT 'CIS 275, Lab Week 8, Question 6  [3 pts possible]:
Changing values
---------------
Use UPDATE commands to change the values of three columns of each table
' + CHAR(10)

GO

--

USE		CIS275Sandboxx
UPDATE	KN_Doctors
SET		DoctorName = CONCAT('Dr. ', DoctorName)
WHERE	DoctorName NOT IN ('%Dr. %')

UPDATE	KN_Doctors
SET		DoctorSpecialty = 'Board Member'
WHERE	DoctorName LIKE 'Dr. Liu Park'

UPDATE	KN_Doctors
SET		HomePhone = 1058841759
WHERE	DoctorName LIKE 'Dr. Susan Gillford'

UPDATE	KN_Patients
SET		TraumaLevel = 1
WHERE	PatientName LIKE 'Rebecca Jones'

UPDATE	KN_Patients
SET		NamePref = 'N/A'
WHERE	NamePref IS NULL

UPDATE	KN_Patients
SET		PatientName = 'Jessica Lu'
WHERE	PatientName LIKE 'Jefery Willis' AND
		DOB	= '1978-02-14'

UPDATE	KN_Departments
SET		PrimaryUnit = 'Strenghtening'
WHERE	PrimaryUnit = 'Strength Building'

UPDATE	KN_Departments
SET		StaffNum = StaffNum + 18
WHERE	StaffNum < 100

UPDATE	KN_Departments
SET		DeptManager = CONCAT('Dr. ', DeptManager)
WHERE	DeptManager LIKE 'Jennifer Parce';

--

GO
PRINT 'CIS 275, Lab Week 8, Question 7  [9 pts possible]:
Creating views
--------------
Create a VIEW that uses a JOIN query to display the content of three related tables. 
Include all the columns from all three tables in your query. Do not forget to add 
your initials at the beginning of the name. 

Display all rows and columns from your view.
' + CHAR(10)

GO

--

CREATE VIEW KN_Department_Overview AS
SELECT	KN_Departments.DepartmentID AS 'Department ID',
		KN_Departments.NetworkID AS 'Netowrk ID',
		KN_Departments.RegionID AS 'Region ID',
		KN_Departments.PrimaryUnit AS 'Primary Unit',
		KN_Departments.Speciality,
		KN_Departments.CareLevel AS 'Care Level',
		KN_Departments.TraumaLevel AS 'Trauma Level',
		KN_Departments.PrimaryStaffLevel AS 'Priamry Staff Level',
		KN_Departments.StaffNum AS 'Staff Number',
		KN_Departments.DeptLocation AS 'Dept. Location',
		KN_Departments.DeptManager AS 'Dept. Manager',
		KN_Departments.DeptCreated AS 'Dept. Date Created',
		KN_Doctors.DoctorName AS 'Doctor Name',
		KN_Doctors.AddressHome AS 'Dr. Address Home',
		KN_Doctors.HomePhone AS 'Dr. Phone Home',
		KN_Doctors.DoctorSpecialty AS 'Doctor Specialty',
		KN_Doctors.FK_PrimaryDeptID AS 'Primary Dept.',
		KN_Doctors.DoctorAge AS 'Dcotor Age',
		KN_Doctors.DateHired AS 'Hire Date',
		KN_Patients.PatientID AS 'Patient ID',
		KN_Patients.DateAdmitted AS 'Admitted Date',
		KN_Patients.DOB AS 'Date of Birth',
		KN_Patients.AddressHome AS 'Patient Address Home',
		KN_Patients.PhoneNum AS 'Patient Phone Home',
		KN_Patients.FK_DepartmentID AS 'Patient Dept.',
		KN_Patients.TraumaLevel AS 'Patient Trauma Level',
		KN_Patients.NamePref AS 'Patient Name Preference',
		KN_Patients.Gender
FROM	KN_Departments JOIN KN_Doctors ON KN_Departments.DepartmentID = KN_Doctors.FK_PrimaryDeptID
		JOIN KN_Patients ON KN_Departments.DepartmentID = KN_Patients.PatientID

--

GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 8' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;

