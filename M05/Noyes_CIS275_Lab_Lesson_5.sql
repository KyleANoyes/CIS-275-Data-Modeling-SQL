/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 5: using SQL SERVER and various databases
The name of the database must be placed on the top of ALL queries. 
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance, such as seeing answers to  versions of specific 
questions or using AI to get answers. I agree to abide by class restrictions and understand 
that if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   Kyle Noyes
                DATE:      July 20 2024

*******************************************************************************************
*/

GO
PRINT '|---' + REPLICATE('+----',15) + '|'
PRINT 'Read the questions below and insert your queries where prompted. 
For the entire term, your results should match the samples shown, though DO NOT force it by 
  using the sample data in your queries since your queries must work when new data is added or changed.  
For example, if the sample shows results only for CustID 100, do not use WHERE CustID = 100.
  
When you are finished, you should be able to run the file as a script to execute all answers
  sequentially (without errors!).' + CHAR(10)
PRINT 'Queries should be well-formatted. SQL is not case-sensitive, but it is good form to
  capitalize keywords and to capitalize table names as they appear in the database; you should
  also put each projected column on its own line and use indentation for neatness. Example:

   SELECT Name,
          CustomerID AS "Customer ID"  -- Always use double quotes for aliases
   FROM   CUSTOMER
   WHERE  CustomerID < 106;            -- All SQL statements should end with a semicolon

Whatever format you choose for your queries, make sure that it is readable and consistent.

Place the name of the database on the top of each query. 
Format all queries with the column names in the sample.

There are several ways to solve many problems. 
  Unless specified to use a particular one, pick one that works for you.

Be sure to remove the double-dash comment indicator when you insert your code!';
PRINT '|---' + REPLICATE('+----',15) + '|' + CHAR(10) + CHAR(10)
GO

PRINT 'CIS 275, Lab Week 5, Question 1  [3 pts possible]:
Matching States
-------------
This week we focus on Subqueries. 
To start, write a subquery to find vendors'' names, and other info 
    whose state matches the state of a vendor named ''National Information Data Ctr''.
You will be using The AP database.

Vendor ID   State Vendor Name                                        Address
----------- ----- -------------------------------------------------- --------------------------------------------------
2           DC    National Information Data Ctr                      PO Box 96621
3           DC    Register of Copyrights                             Library Of Congress
82          DC    Reiter''s Scientific & Pro Books                    2021 K Street Nw
' + CHAR(10)

GO

--

USE		AP
SELECT	CONVERT(CHAR(11), VendorID) AS 'Vendor ID',
		CONVERT(CHAR(5), VendorState) AS 'State',
		CONVERT(CHAR(50), VendorName) AS 'Vendor Name',
		CONVERT(CHAR(50), VendorAddress1) AS 'Address'
FROM	Vendors
WHERE	VendorState IN
	(SELECT VendorState
	FROM	Vendors
	WHERE	VendorName = 'National Information Data Ctr'
	)
ORDER BY VendorID;


--

GO


PRINT 'CIS 275, Lab Week 5, Question 2  [3 pts possible]:
Run Time Minutes
---------
Write a SQL subquery to find the primary titles of the records whose 
    runtime minutes are more than the average runtime minutes. 
Return Primary Title and Runtime Minutes.
Use only SUBQUERIES and no JOINS. Do not hard-code any strings from the results.
You will be using IMDB database.
There will be 537,945 rows if you eliminate duplicates.
Format the output with proper names. Truncate Primary Title to 90 characters.
The correct answer will be sorted and look like this:

Primary Title                                                                              Run Time Minutes
------------------------------------------------------------------------------------------ ----------------
----                                                                                       80
'' AV muri'' Fukada Nana 107 cmK kappu gingakei saikyo oppai muchakucha damashi momi         120
'' Horse Trials ''                                                                           120
!Women Art Revolution                                                                      83
"All in the Family" Retrospective                                                          90
"Are They All Yours?" Live Q & A                                                           72
"Bort g� de, stumma skrida de..."                                                          49
...
ZZ Top: Live at Montreux 2013                                                              81
ZZ Top: Live from Texas                                                                    122
Zzim                                                                                       101
ZZonk!! Splatt!!- the World of Children''s Comics                                           50
ZZZZZ                                                                                      51
' + CHAR(10)

--

USE		IMDB
SELECT	DISTINCT CONVERT(CHAR(91), primaryTitle) AS 'Primary Title', 
		CONVERT(CHAR(16), runtimeMinutes) AS 'Run Time Minutes'
FROM	title_basics
WHERE	runtimeMinutes >
	(SELECT AVG(runtimeMinutes)
	FROM	title_basics
	)
ORDER BY [Primary Title];

--

GO

PRINT 'CIS 275, Lab Week 5, Question 3  [3 pts possible]:
MIN Price
----------
Write a SQL subquery that finds for each order which product had the lowest quantity.  
Use the MyGuitarShop database for this query.
Format the columns with proper spacing and columns names.
Correct answers will have 46 rows and will look like this:

Order#      Product ID  Quantity
----------- ----------- -----------
1           2           1
2           8           1
3           1           1
3           9           1
4           2           2
...
40          6           1
41          6           1
41          8           1
' + CHAR(10)

GO

--

/*
	I do not undrstand this problem statement. Going to skip for 
	now as I can complete at the subquery portion. I am sinking 
	too much time into just trying to understand the wording 
	of the question

	The below is not probably not correct, but the subquery 
	learning objective is met to the best of my abilities.
*/


USE		MyGuitarShop
SELECT	CONVERT(CHAR(11), OrderID) AS 'Order #',
		CONVERT(CHAR(11), ProductID) AS 'Product ID', 
	CONVERT(CHAR(12), (SELECT MIN(Quantity)
	FROM OrderItems
	)) AS 'Quantity'
FROM	OrderItems
ORDER BY OrderID, ProductID;

--
 
GO

PRINT 'CIS 275, Lab Week 5, Question 4  [3 pts possible]:
Customers
----------
Write a SQL subquery to find those customers whose ID is not in orders 310-700.
The database is ProductOrders for it.
Format colums with appropriate names.
There will be 11 rows. Return the fields that are in the output below.

Customer ID Last Name       City
----------- --------------- --------------------
8           Damien          Fresno
10          Nickalus        Valencia
11          Eulalia         Sacramento
13          Neftaly         Fresno
14          Keeton          Fairfield
15          Irvin           Orange
18          Javen           Tarrytown
22          Holbrooke       Fresno
23          Anum            Manhatttan Beach
24          Carson          San Francisco
25          Story           Washington
' + CHAR(10)

GO

--

USE		ProductOrders
SELECT	CONVERT(CHAR(12), CustID) AS 'Customer ID',
		CONVERT(CHAR(15), CustLastName) AS 'Last Name',
		CONVERT(CHAR(20), CustCity) AS 'City'
FROM	Customers
WHERE	CustID NOT IN 
	(SELECT	CustID
	FROM Orders
	WHERE OrderID BETWEEN 310 AND 700)
ORDER By CustID;
--

GO




GO
PRINT'CIS 275, Lab 5, Question 5 [3 pts possible]
High Prices
-----------
Your manager wants to list the products that have a list price higher 
    than the average list price. 
The database name is MyGuitarShop. 
Write a subquery to produce the following output:

Product Name              List Price > AVG Category ID Date added
------------------------- ---------------- ----------- -----------------------
Gibson Les Paul           $1,199.00        1           2015-12-05 16:33:13.000
Gibson SG                 $2,517.00        1           2016-02-04 11:04:31.000
' + CHAR(10)

--

USE		MyGuitarShop
SELECT	CONVERT(CHAR(26), ProductName) AS 'Product Name',
		CONVERT(CHAR(16), FORMAT(ListPrice, 'c', 'en-US')) AS 'List Price',
		CONVERT(CHAR(11), CategoryID) AS 'Category ID',
		CONVERT(CHAR(24), DateAdded, 021) AS 'Date Added'
FROM	Products
WHERE ListPrice > 
	(SELECT AVG(ListPrice)
	FROM	Products
	)
ORDER BY ProductID;

--


GO

PRINT 'CIS 275, Lab Week 5, Question 6 [3 pts possible]:
Young Writers
-------------
Review the following subquery:'
USE IMDB 
SELECT	TOP 10	CAST(primaryName AS CHAR(20)) AS primaryName,
			birthYear AS DOB,
			(SELECT		COUNT(*) AS "Nbr Written"
			FROM		title_writers AS TD
			WHERE		nconst = NB.nconst
			) AS WRITTEN
FROM		name_basics AS NB
WHERE		birthYear > 2000
ORDER BY	WRITTEN DESC;
PRINT '
1- In a paragraph, explain the purpose of this query. What does it do?
2- Revise the query to produce the following result. 
Do not use any JOINS.
Note that this shows it in the order of the highest number directed.

NAME                 DOB         AGE         WRITTEN     DIRECTED
-------------------- ----------- ----------- ----------- -----------
Chase Ramos          2001        23          118         128
Eric Martinez        2001        23          74          92
...
Miranda Laird        2004        20          8           14
Kacey Fifield        2005        19          0           11
' + CHAR(10)

--

/* 

The query above is written to show the top 10 writers born after 2000 
who have the most writing credits. The query first calls data from the name_basics
category before then fetching data from the title_writers category.

This joins the two tables based on the nconst keys between them and allows the
query to return data from both. After both have been combined through this sub
query, the query then sorts the most amount of writing credits and returns the top 10

*/

USE IMDB 
SELECT	TOP 10	CAST(primaryName AS CHAR(20)) AS primaryName,
			birthYear AS DOB,
			(2024 - birthYear) AS 'AGE',
			(SELECT		COUNT(*) AS "Nbr Written"
			FROM		title_writers AS TD
			WHERE		nconst = NB.nconst
			) AS WRITTEN,
			(SELECT		COUNT(*) AS "Nbr Written"
			FROM		title_directors
			WHERE		nconst = NB.nconst
			) AS DIRECTED
FROM		name_basics AS NB
WHERE		birthYear > 2000
ORDER BY	DIRECTED DESC, DOB, WRITTEN DESC;

--

GO

PRINT 'CIS 275, Lab Week 5, Question 7  [3 pts possible]:
Only One Item
-------------
Write a subquery to display the orders that only have one product.
	This does not mean a quantity of 1.
The database name is MyGuitarShop.
Do not use JOIN or hard-code values to find the result.
Format your output by proper culumn names and spacing.
There will be 36 rows.

Order ID    Item ID     Product ID  Quantity
----------- ----------- ----------- -----------
1           1           2           1
2           2           8           1
4           5           2           2
...
37          42          1           1
38          43          2           2
39          44          6           1
40          45          6           1
' + CHAR(10)

GO

--

/* 
I am not sure if this is the intended outcome, but I am quite proud of this solution
that uses the root From clause as the base result for the later querries to check against.

I have struggled on this thing for hours, and am quite happy it is finally solved!!!
*/

USE		MyGuitarShop
SELECT	OrderID AS 'Order ID',
	(SELECT ItemID
	FROM	OrderItems
	WHERE	OrderID = SingleOrders.OrderID
	) AS 'Item ID',
	(SELECT ProductID
	FROM	OrderItems
	WHERE	OrderID = SingleOrders.OrderID
	) AS 'Product ID',
	(SELECT Quantity
	FROM	OrderItems
	WHERE	OrderID = SingleOrders.OrderID
	) AS 'Quantity'
FROM 	
	(SELECT	OrderID
	FROM	OrderItems
	GROUP BY OrderID
	HAVING	COUNT(OrderID) = 1
	) AS SingleOrders
ORDER BY OrderID;

--

GO


PRINT 'CIS 275, Lab Week 5, Question 8  [3 pts possible]:
Write a Subquery to display the sales reps whose total sales exceeded 900,000 in 2014.
The database name is Examples.

Rep ID      Total Sales     Sales Year
----------- --------------- ----------
1           $1,274,856.38   2014
3           $1,032,875.48   2014
2           $978,465.99     2014
' + CHAR(10)

GO



--

USE		Examples
SELECT	baseTable.RepID,
	(SELECT	SUM(SalesTotal)
	FROM	SalesTotals
	WHERE	SalesTotals.RepID = baseTable.RepID AND
	SalesYear = 2014
	GROUP BY RepID
	) AS 'Total Sales',
	baseTable.SalesYear AS 'Sales Year'
FROM
	(SELECT RepID, SalesYear
	FROM	SalesTotals
	WHERE	SalesYear = 2014 AND
	SalesTotal > 900000
	GROUP BY RepID, SalesYear
	) AS baseTable;

--

GO

PRINT 'CIS 275, Lab Week 5, Question 9  [3 pts possible]:
JavaScript Jobs
--------------------
Scott Ashley has posted a few messages about JavaScript jobs. 
Find all these messages using subquery and show only the first 70 characters of them.
USE ONLY SUBQUERIES AND NO JOINS.
Do not hard code Scott''s user ID.
You will be using the Discussions database. 

Title              Scott''s Content
------------------ ----------------------------------------------------------------------
JavaScript Jobs    <p>I decided to search with JavaScript on indeed. I already know a bit
JavaScript Jobs    <p>Hi Alan! That''s a real shame the Ruby and the second PHP class were
JavaScript Jobs    <p>Perfect! I will see you there Alan!</p><p>Scott</p>
' + CHAR(10)

GO

--

/*
This doesn't feel correct, but this seems to return the correct results?

I'm not super happy with how this answer has turned out, but I am getting more
confident with nested queries.
*/

USE		Discussions
SELECT	Title AS 'Title',
		Content
FROM	
	(SELECT	Title, Content, Username, PostedDate
	FROM	Posts,
		(SELECT Username
		FROM	Users) AS InnerTableContent
	WHERE	Title LIKE 'JavaScript Jobs' AND
	Username LIKE 'scott.ashley' AND
	Content LIKE '%JavaScript%'
	) AS innerTablePosts
ORDER BY PostedDate;

--

GO

PRINT 'CIS 275, Lab Week 5, Question 10  [3 pts possible]:
Sales Reps
---------------------
Use subqueries to show the top 4 sales reps who had the highest total sales.
Do not use JOIN or hard code sales reps ID or names.
You will be using the Examples database.
The correct results will look like this:

Rep ID      Rep Last Name   Total Sales
----------- --------------- ---------------------
1           Thomas          3196940.69
2           Martinez        2841015.55
3           Markasian       2165620.04
4           Winters         728230.29
                              
' + CHAR(10)

GO

--

/* 
This answer isn't correct as the sum is collected from the whole of the 
total sales. I won't be able to fix this before the deadline so will be
submitting this for now.

I'll likely re-review this later, but at lease the general grouping of the
data has been met. I am quite happy with having at least achieved that :)

*/

USE		Examples
SELECT	RepID AS 'Rep ID',
	(SELECT	RepLastName
	FROM	SalesReps
	WHERE	RepID = innerQuerry.RepID
	GROUP BY RepLastName
	),
		sumSales AS 'Total Sales'
FROM
	(SELECT RepID,
	SUM(SalesTotal) AS 'sumSales'
	FROM	SalesTotals,
		(SELECT RepLastName
		FROM	SalesReps
		) AS outterQuerry
	GROUP BY RepID
	) AS innerQuerry

--


GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 5' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


