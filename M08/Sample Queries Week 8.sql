USE CIS275Sandboxx
/* These statements are best run one at a time so you can see what is happening.
IMPORTANT: To prevent other students messing up what you are doing, 
  replace 'GSF' with your initials before executing.
*/
/* Make a basic table.  Define primary key as IDENTITY: */
CREATE TABLE GSF_PARENT
   (PARENTKEY INTEGER PRIMARY KEY IDENTITY(1,1),    -- Seed, Increment
    DESCRIP   VARCHAR(256),
    LASTMOD   DATETIME
   );
 
/* Check the result of the OBJECT_ID function when run with this name and 'U' for table: */
SELECT OBJECT_ID('GSF_PARENT','U');

/* Like most IDs, the number means nothing to you and you do not need to remember it.*/
 
/* If the table exists, drop it: */
IF OBJECT_ID('GSF_PARENT','U') IS NOT NULL
     DROP TABLE GSF_PARENT;
 
GO
 
/* Re-create the table: */
CREATE TABLE GSF_PARENT
   (PARENTKEY INTEGER PRIMARY KEY IDENTITY(1,1),    -- Seed, Increment
    DESCRIP   VARCHAR(256),
    LASTMOD   DATETIME
   );
 
GO
 
/* Add a row.  Omit the PK value; IDENTITY will populate this automatically  */
INSERT INTO GSF_PARENT
   (DESCRIP, LASTMOD)
VALUES
   ('FirstValue', GETDATE() );
 
/* Add another row; we can omit the columns if we have correct values for all, in order: */
INSERT INTO GSF_PARENT
VALUES
   ('SecondValue', GETDATE() );
 
/* But specifying columns allows us to mix up the order and/or omit non-mandatory values:  */
INSERT INTO GSF_PARENT
   (LASTMOD, DESCRIP)
VALUES
   (GETDATE(), 'ThirdValue' );
 
INSERT INTO GSF_PARENT
   (DESCRIP)
VALUES
   ('FourthValue' );
 
GO
 
/* The results: */
SELECT *
FROM   GSF_PARENT
ORDER BY PARENTKEY;
 
 
/* Make another table; link to previous table with a foreign key constraint: */
CREATE TABLE GSF_CHILD
   (CHILDKEY  INTEGER PRIMARY KEY IDENTITY(1,1),    -- Seed, Increment
    PARENTKEY INTEGER FOREIGN KEY REFERENCES GSF_PARENT,    -- Automatically detects PK of this table for the link
    CHDESC    VARCHAR(256),
    LASTMOD   DATETIME
   );
 
GO
 
/* Try dropping the parent table: */
IF OBJECT_ID('GSF_PARENT','U') IS NOT NULL
     DROP TABLE GSF_PARENT;
 
/* The above will work after dropping the child table: */
IF OBJECT_ID('GSF_CHILD','U') IS NOT NULL
     DROP TABLE GSF_CHILD;
 
GO
 
CREATE TABLE GSF_CHILD
   (CHILDKEY  INTEGER PRIMARY KEY IDENTITY(1,1),    -- Seed, Increment
    PARENTKEY INTEGER FOREIGN KEY REFERENCES GSF_PARENT,    -- Automatically detects PK of this table for the link
    CHDESC    VARCHAR(256),
    LASTMOD   DATETIME
   );
 
GO
/* New record.  Use ID of row inserted above to link to parent record: */
INSERT INTO GSF_CHILD
   (PARENTKEY,   CHDESC,    LASTMOD)
VALUES
   (   1,      'ChildValue',  '01/01/2024');
 
/*  Results: */
SELECT *
FROM   GSF_CHILD;
 
GO
/* Attempt to insert a row linked to record #10; conflicts with FK constraint: */
INSERT INTO GSF_CHILD
   (PARENTKEY,   CHDESC,    LASTMOD)
VALUES
   (   10,      'ChildValue2', '01/01/2019');
 
GO

/*  Some more child records: */
INSERT INTO GSF_CHILD
   (PARENTKEY,   CHDESC,    LASTMOD)
VALUES
   (   1,      'ChildValue2',  GETDATE()),
   (   1,      'ChildValue3',  GETDATE()),
   (   1,      'ChildValue4',  GETDATE());
GO

/*  Results: */
SELECT *
FROM   GSF_CHILD;
 
/* Line up data: */
SELECT CHILDKEY AS NUM,
       CHDESC   AS DESCR,
       LASTMOD
FROM   GSF_CHILD;
 
GO
 
/* Use query above to create a view: */
CREATE VIEW GSF_VIEW AS
SELECT CHILDKEY AS NUM,
       CHDESC   AS DESCR,
       LASTMOD  AS MODIFIED
FROM   GSF_CHILD;
 
GO
 
/* Results: */
SELECT *
FROM   GSF_VIEW
ORDER BY NUM;
 
/* Make an index for our table to speed up searching on text field: */
CREATE INDEX GSF_IDX1 ON GSF_CHILD (CHDESC);
 
GO

/* Modify data with an UPDATE statement: */
UPDATE GSF_CHILD
SET    CHDESC = 'NewValue'
WHERE  CHILDKEY = 3;

GO

/* Results: */
SELECT *
FROM   GSF_VIEW
ORDER BY NUM;
 
/* Remove a row: */
DELETE FROM GSF_CHILD
WHERE  CHILDKEY = 4;
 
GO
/* Results: */
SELECT *
FROM   GSF_VIEW
ORDER BY NUM;

/* Note that the table was affected. That is where the data actually is.
A view has no data, it is just a query into a table(s) and gets the current values.*/
SELECT *
FROM GSF_CHILD;

/* Additional examples - table with composite primary key: */
CREATE TABLE GSF_OTHER
   (OTHERKEY  INTEGER,
    OTHERSEQ  INTEGER,
    PARENTKEY INTEGER,
    OTHERDESC VARCHAR(256),
    LASTMOD   DATETIME,
    PRIMARY KEY (OTHERKEY, OTHERSEQ),   -- Separate declaration. Must use this syntax for composite PK
    FOREIGN KEY (PARENTKEY) REFERENCES GSF_PARENT(PARENTKEY)  -- We must specify which column(s). Parent table's PK could be omitted if we wanted
     );

GO

/* See what tables you created: */
SELECT * from INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE 'GSF%';

/* See what columns are in this last table: */
SELECT * from INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'GSF_OTHER';

/* If the table exists, drop it: 
IF OBJECT_ID('GSF_OTHER','U') IS NOT NULL
     DROP TABLE GSF_OTHER;
*/
GO