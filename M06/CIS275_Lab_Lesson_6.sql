/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 6: using SQL SERVER and various databases
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance, such as seeing answers to  versions of specific 
questions or using AI to get answers. I agree to abide by class restrictions and understand 
that if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   Kyle Noyes
                DATE:      7/28/2024

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



PRINT 'CIS2275, Lab Week 6, Question 1  [3 pts possible]:
Display the list of orders that only have one item. 
The ProductOrders database will be used for this problem. 
Format your columns accordingly. 
There should 29 records. 

Order ID    Item ID     Quantity
----------- ----------- --------
19          5           1
32          7           1
70          1           1
89          4           1
...
703         4           1
773         10          1
827         6           1
' + CHAR(10)
--

USE		ProductOrders
SELECT	innerQuery.OrderID AS 'Order ID',
	(SELECT	ItemID
	FROM	OrderDetails
	WHERE	OrderID = innerQuery.OrderID AND
			Quantity = 1
	) AS 'Item ID',
	(SELECT	Quantity
	FROM	OrderDetails
	WHERE	OrderID = innerQuery.OrderID AND
			Quantity = 1
	) AS 'Quantity'
FROM	
	(SELECT	Orders.OrderID
	FROM	Orders JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
	WHERE	Quantity = 1
	GROUP BY Orders.OrderID
	HAVING	COUNT(Orders.OrderID) = 1
	) AS innerQuery
ORDER BY OrderID;

--


GO
PRINT 'CIS2275, Lab Week 6, Question 2  [3 pts possible]:
Display the total quantity and number of products sold for each order between 2015-02-12 AND 2015-11-22.
USE JOIN for this problem.
The ProductOrders database will be used for this problem.
The correct result will have 14 records.

Date         OrderID     # Items     Quantity Sold
------------ ----------- ----------- -------------
Feb 14, 2015 231         1           1
Feb 24, 2015 242         2           2
Mar 15, 2015 264         3           3
Apr 18, 2015 298         1           1
...
Sep 30, 2015 479         2           3
Oct 08, 2015 491         1           1
Oct 10, 2015 494         1           1
Nov 07, 2015 523         1           1
Nov 22, 2015 548         1           1
' + CHAR(10)

GO
--

USE		ProductOrders
SELECT	CONVERT(CHAR(12), innerQuery.OrderDate, 107),
	(SELECT Orders.OrderID
	FROM	Orders, OrderDetails
	WHERE	OrderDate = innerQuery.OrderDate
	GROUP BY Orders.OrderID
	) AS 'Order ID',
	ItemCount AS '# Items',
	(SELECT SUM(Quantity)
	FROM	OrderDetails
	) AS 'Quantity'
FROM		
	(SELECT	OrderDate,
			COUNT(*) AS 'ItemCount'
	FROM	Orders JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
	WHERE	Quantity = 1
	GROUP BY OrderDate
	) AS innerQuery
WHERE	OrderDate BETWEEN '2015-02-12' AND '2015-11-22'
ORDER BY innerQuery.OrderDate;

--


GO
PRINT 'CIS2275, Lab Week 6, Question 3  [3 pts possible]:
Write a common table expression to identify Vendors whose Total Credit was greater than 300. 
Display the number of their invoices as well. 
The AP database will be used for this problem. 
There will be 1 record for this query.

Vendor ID   Vendor Name                    NBR_Invoices Total Credit
----------- ------------------------------ ------------ ---------------
110         Malloy Lithographing Inc       5            $3,495.95      
'+ CHAR(10)

GO

--

USE		AP
SELECT	VendorID AS 'Vendor ID',
	(SELECT VendorName
	FROM	Vendors
	WHERE	VendorID = innerQuery.VendorID
	) AS 'Vendor Name',
		NBR_Invoices,
		FORMAT(SumCredit, 'c', 'en-US') AS 'Total Credit'
FROM		
	(SELECT	VendorID,
			COUNT(*) AS 'NBR_Invoices',
			SUM(CreditTotal) AS 'SumCredit'
	FROM	Invoices
	GROUP BY VendorID
	HAVING	SUM(CreditTotal) > 300
	) AS innerQuery
ORDER BY VendorID;

--


GO
PRINT 'CIS2275, Lab Week 6, Question 4  [3 pts possible]:
Your manager wants you to provide the number of orders which were placed between 
  Dec 1, 2015 and April 1, 2016 each day any orders were placed. 
Show the full names of each customer in date order.
ProductOrders database will be used for this problem.
Hint: Use the DATENAME Function (Ch 9 Murach) to format the dates.

Date                           Customer Name             # Orders
------------------------------ ------------------------- -----------
Monday, December 21, 2015      Dakota Baylee             1
Friday, December 25, 2015      Erick Kaleigh             1
Friday, December 25, 2015      Kaitlin Hostlery          1
Monday, January 4, 2016        Yash Randall              1
Tuesday, January 5, 2016       Samuel Jacobsen           1
...
Saturday, March 19, 2016       Samuel Jacobsen           1
Monday, March 21, 2016         Kyle Marissa              1
Monday, March 21, 2016         Yash Randall              1
Friday, April 1, 2016          Korah Blanca              1
'+ CHAR(10)

--

/* 
Feels like quite a bit of spaghetti going on here, but it works!
*/

USE		ProductOrders
SELECT	DATENAME(DW, OrderDate) + ', ' + 
		DATENAME(MM, OrderDate) + ' ' + 
		DATENAME(DD, OrderDate) + ', ' +
		DATENAME(YEAR, OrderDate) AS 'Date',
		(CustFirstName + ' ' + CustLastName) AS 'Customer Name',
		COUNT(*) AS '# Orders'
FROM	
	(SELECT	DISTINCT Orders.OrderID, OrderDate, CustFirstName, CustLastName
	FROM	Orders JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
		JOIN Customers ON Orders.CustID = Customers.CustID
	) AS innerQuery
WHERE	OrderDate BETWEEN '2015-12-01' AND '2016-04-01'
GROUP BY OrderDate, (CustFirstName + ' ' + CustLastName)
ORDER BY innerQuery.OrderDate;

--
GO


GO
PRINT 'CIS2275, Lab Week 6, Question 5  [3 pts possible]:
Your marketing director is interested in finding the customers who placed orders in 2014 but did not place orders in 2016.
There are several good ways to solve this. Choose one.
The ProductOrders database will be used for this problem.
There will be 7 valid records.

CustID      Customer First Name Customer Last Name City
----------- ------------------- ------------------ ---------------
3           Johnathon           Millerton          New York
8           Deborah             Damien             Fresno
10          Kurt                Nickalus           Valencia
11          Kelsey              Eulalia            Sacramento
14          Gonzalo             Keeton             Fairfield
22          Rashad              Holbrooke          Fresno
24          Julian              Carson             San Francisco
.' + CHAR(10)
--

USE		ProductOrders
SELECT	Customers.CustID AS 'CustID',
		CustFirstName AS 'Customer First Name',
		CustLastName AS 'Customer Last Name',
		CustCity AS 'City'
FROM	Orders JOIN Customers ON Orders.CustID = Customers.CustID
WHERE	OrderDate LIKE '%2014%' AND
		Customers.CustID NOT IN 
			(SELECT	Customers.CustID
			FROM	Orders JOIN Customers ON Orders.CustID = Customers.CustID
			WHERE	OrderDate LIKE '%2016%'
			)
ORDER BY CustID;

--
GO


GO

PRINT 'CIS2275, Lab Week 6, Question 6  [3 pts possible]:
We want to know the quarters the customers have placed orders, the number of orders, 
   and the total quantity each placed for each quarter in 2015.
Display them in customer and quarter order.
The ProductOrders database will be used for this problem.
Hint: Use DATEPART Function (Ch 9 Murach)

Customer Name             Year        Quarter     # Orders    Total Quantity
------------------------- ----------- ----------- ----------- --------------
Ania Irvin                2015        1           1           1
Dakota Baylee             2015        4           2           3
Derek Chaddick            2015        3           1           1
Erick Kaleigh             2015        4           1           2
...
Trisha Anum               2015        1           1           2
Yash Randall              2015        2           1           1
Yash Randall              2015        4           1           1
.' + CHAR(10)
--

/*
TODO: Find how to group together
- This answer is a mess.... I've spent too much time on it with no progress and
	need to move on. SQL is wildly confusing, and the lack of good debuging tools
	is driving me insane. Why is there no step through or method to see each
	subquerys results?????
*/

USE		ProductOrders
SELECT	DISTINCT (CustFirstName + ' ' + CustLastName) AS 'Customer Name',
		OrderDate AS 'Year',
		DATEPART(QUARTER, OrderDate) AS 'Quarter',
		COUNT((CustFirstName + ' ' + CustLastName)) AS '# Orders',
		Quantity AS 'Total Quantity'
FROM	Orders JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
		JOIN Customers ON Orders.CustID = Customers.CustID
WHERE	OrderDate LIKE '%2015%'
GROUP BY (CustFirstName + ' ' + CustLastName), Orders.OrderDate, Quantity
ORDER BY [Customer Name], [Quarter];

/* 
This retuns customer name + correct order quantity

USE		ProductOrders
SELECT	DISTINCT (CustFirstName + ' ' + CustLastName) AS 'Customer Name',
		COUNT((CustFirstName + ' ' + CustLastName)) AS 'Quantity'
FROM	Orders JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
		JOIN Customers ON Orders.CustID = Customers.CustID
WHERE	OrderDate LIKE '%2015%'
GROUP BY (CustFirstName + ' ' + CustLastName)

*/

/* 
This retuns customer name + SUM of orders  + correct order quantity
- I am so confused.... how do I get a count of the orders for each ID??

USE		ProductOrders
SELECT	DISTINCT (CustFirstName + ' ' + CustLastName) AS 'Customer Name',
	(SELECT	COUNT(CustID) AS 'debug'
	FROM	Orders
	WHERE	OrderDate LIKE '%2015%'
	) AS 'test',
		COUNT((CustFirstName + ' ' + CustLastName)) AS 'Quantity'
FROM	Orders JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
		JOIN Customers ON Orders.CustID = Customers.CustID
WHERE	OrderDate LIKE '%2015%'
GROUP BY (CustFirstName + ' ' + CustLastName)

*/

/*
This returns 15 results matching the 15 expected, but it won't fit into the query???
It returns an error that the rows are not equal when the output is 15 rows.

USE		ProductOrders
SELECT	COUNT(CustID) AS 'debug'
FROM	Orders
WHERE	OrderDate LIKE '%2015%'
GROUP BY CustID

*/

--
GO


GO
PRINT 'CIS2275, Lab Week 6, Question 7  [3 pts possible]:
We want to find the products whose list price is less than or equal to the 
  average list price of the products that are in category 3. 
The database for this problem is MyGuitarShop.
There will 6 valid records in product order.

ProductID   Product Name                             List Price CategoryID
----------- ---------------------------------------- ---------- -----------
1           Fender Stratocaster                      699.00     1
8           Hofner Icon                              499.99     2
9           Ludwig 5-piece Drum Set with Cymbals     699.99     3
6           Rodriguez Caballero 11                   415.00     1
5           Washburn D10S                            299.00     1
4           Yamaha FG700S                            489.99     1
'+ CHAR(10)
--

/* For once, things just worked :) */

USE		MyGuitarShop
SELECT	ProductID,
		ProductName AS 'Product Name',
		ListPrice AS 'List Price',
		CategoryID
FROM	Products
WHERE	ListPrice <= 
	(SELECT	AVG(ListPrice)
	FROM	Products
	WHERE	CategoryID = 3
	)
ORDER BY ProductName;

--
GO


GO
PRINT 'CIS2275, Lab Week 6, Question 8  [3 pts possible]:
Find the difference between when the order was placed and when the order was shipped.
If it was never shipped, display 9999.
You need to use DATEDIFF and CASE (Ch 9 in Murach). 
Display the TOP 10 days late only.
ProductOrders is the database for this problem.
Display the results as follows.

OrderID     CustID      Date Ordered Date Shipped Days Late
----------- ----------- ------------ ------------ -----------
824         1           04-01-2016                9999
827         18          04-02-2016                9999
829         9           04-02-2016                9999
413         17          08-05-2015   09-11-2015   37
180         24          12-25-2014   01-30-2015   36
...
548         2           11-22-2015   12-18-2015   26
158         9           12-04-2014   12-20-2014   16
'+ CHAR(10)
--

/*
I am really proud of this solution. OMG I finally feel like I understand
SQL to some extent!!!! I am quite excited tof or next week to apply my
new found understanding of how these statements work together
*/

USE		ProductOrders
SELECT	TOP 10 innerQuery.OrderID AS 'OrderID',
		innerQuery.CustID AS 'CustID',
		CONVERT(CHAR(12), innerQuery.OrderDate, 110) AS 'Date Ordered',
		ISNULL(CONVERT(CHAR(12), innerQuery.ShippedDate, 110), '') AS 'Date Shipped',
		CASE
			WHEN DATEDIFF(DAY, innerQuery.OrderDate, innerQuery.ShippedDate) IS NULL THEN 9999
			WHEN DATEDIFF(DAY, innerQuery.OrderDate, innerQuery.ShippedDate) IS NOT NULL THEN DATEDIFF(DAY, innerQuery.OrderDate, innerQuery.ShippedDate) 
		END AS 'Days Late'
FROM	
	(SELECT	Orders.OrderID, 
	Orders.CustID,
	Orders.OrderDate,
	Orders.ShippedDate
	FROM	Orders JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
	GROUP BY Orders.OrderID, Orders.CustID, Orders.OrderDate, Orders.ShippedDate
	) AS innerQuery
ORDER BY [Days Late] DESC;

--
GO


GO
PRINT 'CIS2275, Lab Week 6, Question 9  [3 pts possible]:
What orders were placed by each customer on their last order date? 
For example, Customer ID 1 has placed one orders on 6/23/15, 9/30/15 and 4/01/16.
We want the order number for the one that was placed on 4/01/16.
Use Subquery to produce the output. 
Display the first 5 customers.
The ProductOrders database will be used for this problem.

CustID      OrderID     Date Ordered
----------- ----------- ------------
1           824         04/01/16    
2           802         03/21/16    
3           523         11/07/15    
4           494         10/10/15    
5           442         08/28/15   
' + CHAR(10)
--

/*
After all the pain and suffering of the earlier questions, I feel like
I just found out where all my frustrations were stemming from. I have
been using joins wrong the whole time!

I am not sure that I have enough time to revise the statements before
this, but I just made a major breakthrough in my SQL understanding!!!
I am not even bothered by losing points on the previous statements,
honestly just finally grasping this has made me so happy!
*/

USE		ProductOrders
SELECT	TOP 5 CustID,
		OrderID,
		OrderDate
FROM
	(SELECT	MAX(OrderID) AS 'LastOrder'
	FROM	Orders
	GROUP BY CustID
	) AS innerQuerry LEFT JOIN Orders ON Orders.OrderID = innerQuerry.LastOrder
ORDER BY CustID;

--
GO



GO
PRINT 'CIS2275, Lab Week 6, Question 10  [3 pts possible]:
Calculate the percent of total sales of each sales rep in 2014. 
The calculation will show the percentage of the total sales for each 
  rep compared to the company overall total sales for all years.
For example, if the overall sales for all years was $10,000 and
  rep''s total sales for 2014 was $1000, the percentage would be 10%.
Use Subquery and JOIN. 
The Examples database will be used for this problem.
Sort the results by the highest sales.

Rep ID Last Name  2014 Totals   % of Company Sales
------ ---------- ------------- ------------------
1      Thomas     $1,274,856.38 13.56%
3      Markasian  $1,032,875.48 10.99%
2      Martinez   $978,465.99   10.41%

' + CHAR(10)
--

USE		Examples
SELECT	SalesTotals.RepID AS 'Rep ID',
		SalesReps.RepLastName AS 'Last Name',
		SalesTotal AS '2014 Totals', 
		(SalesTotal / 
		(SELECT	SUM(SalesTotal) AS 'SalesSum'
		FROM	SalesTotals 
		) * 100) AS '% of Company Sales'
FROM	SalesTotals LEFT JOIN SalesReps ON SalesTotals.RepID = SalesReps.RepID
WHERE	SalesYear = 2014
ORDER BY SalesTotal DESC;

--
GO



GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 6' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


