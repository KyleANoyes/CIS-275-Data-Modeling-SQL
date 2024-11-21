/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 4: using SQL SERVER  and various databases
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance, such as seeing answers to  versions of specific 
questions or using AI to get answers. I agree to abide by class restrictions and understand 
that if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   Kyle Noyes
                DATE:      July 14th, 2024

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
   WHERE  CustomerID < 106;            -- All SQL stetments should end with a semicolon

Whatever format you choose for your queries, make sure that it is readable and consistent.

Place the name of the database on the top of each query. 
Format all queries with the column names in the sample.

There are several ways to solve many problems. 
  Unless specified to use a particular one, pick one that works for you.

Be sure to remove the double-dash comment indicator when you insert your code!';
PRINT '|---' + REPLICATE('+----',15) + '|' + CHAR(10) + CHAR(10)
GO

PRINT 'CIS 275, Lab Week 4, Question 1  [3 pts possible]:
Customer in each state
-----------------------------------
For this query, you will count the customers in each state.
Use Examples database for this query.

Correct results will have 17 rows and look like this:

States          # of Customers
--------------- ---------------
AK				1
AR				1
CA				1
GA				1
...
NM				1
OR				3
RI				1
TX				1
WA				4
WY				1
' + CHAR(10)
GO

--

USE		Examples
SELECT	CONVERT(CHAR(15), CustState) AS States,
		CONVERT(CHAR(15), COUNT(CustState)) AS '# of Customers'
FROM	Customers
GROUP BY CustState
ORDER BY CustState;

--

GO

PRINT 'CIS 275, Lab Week 4, Question 2  [3 pts possible]:
Discount
-------
Your manager wants you to extract/calculate the following data:
Number of invoices submitted by a vendor.
Calculating Total Invoice for all invoices.
Average invoice amount.
Calculating a 10% discount on Total Invoice.
Calculating the balance after applying discounts.
You need to use AP database.
Format columns with names and formats as below.

The correct output should have 34 rows

Vendor ID   # Invoices  Avg Invoice Amnt    Total Invoice  10% Discount  Balance
--------------------------------------------------------------------------------------
34	        2           $600.06             $1,200.12      $120.01       $1,080.11
37	        3           $188.00             $564.00        $56.40        $507.60
48          1           $856.92             $856.92        $85.69        $771.23
72          2           $10,963.66          $21,927.31     $2,192.73     $19,734.58
...
122	        9           $2,575.33           $23,177.96     $2,317.80     $20,860.16
123         47          $93.15              $4,378.02      $437.80       $3,940.22
' + CHAR(10)
GO

--

USE		AP
SELECT	CONVERT(CHAR(12), VendorID) AS 'Vendor ID',
		CONVERT(CHAR(12), COUNT(VendorID)) AS '# Invoices',
		CONVERT(CHAR(20), FORMAT(AVG(InvoiceTotal), 'c', 'en-US')) AS 'Avg Invoice Amnt',
		CONVERT(CHAR(15), FORMAT(SUM(InvoiceTotal), 'c', 'en-US')) AS 'Total Invoice',
		CONVERT(CHAR(12), FORMAT(SUM(InvoiceTotal * 0.1), 'c', 'en-US')) AS '10% Discount',
		CONVERT(CHAR(13), FORMAT(SUM(InvoiceTotal * 0.9), 'c', 'en-US')) AS 'Balance'
FROM	Invoices
GROUP BY VendorID
ORDER BY VendorID;

--

GO

PRINT 'CIS 275, Lab Week 4, Question 3 [3 pts possible]:
Selecting Vendors
--------------
Your manager wants to know the number of invoices that vendors submitted. 
He wants to see the list of vendors whose vendor ID is between 110 to 140 
and whose total sales are greater than $1000.
Format columns as needed.
You need to use AP database.

Correct results will look like this:

Vendor ID   Number of Invoices
----------- ------------------
110         5
113         1
119         1
121         8
122         9
123         47
' + CHAR(10)
GO

--

USE		AP
SELECT	CONVERT(CHAR(11), VendorID) AS 'Vendor ID',
		CONVERT(CHAR(19), COUNT(InvoiceNumber)) AS 'Number of Invoices'
FROM	Invoices
GROUP BY VendorID
HAVING	VendorID BETWEEN 110 AND 140 AND
		SUM(InvoiceTotal) > 1000
ORDER BY VendorID;

--

GO

PRINT 'CIS 275, Lab Week 4, Question 4  [3 pts possible]:
MIN & MAX
---------
Use AP database for this query.
Calculate the number of invoices each vendor has submitted. 
Calculate the first 5 lowest and highest payment amounts.
Format the columns with proper names. Insert a dollar sign.

Vendor ID   # Invoices  Min Payment Max Payment
----------- ----------- ----------- -----------
34          2           $116.54     $1083.58
37          3           $0.00       $224.00
48          1           $856.92     $856.92
72          2           $0.00       $21842.00
80          2           $0.00       $175.00
' + CHAR(10)

GO

--

USE		AP
SELECT	TOP 5 CONVERT(CHAR(12), VendorID) AS 'Vendor ID',
		CONVERT(CHAR(11), COUNT(VendorID)) AS '# Invoices',
		CONVERT(CHAR(11), FORMAT(MIN(PaymentTotal), 'c', 'en-US')) AS 'Min Payment',
		CONVERT(CHAR(11), FORMAT(MAX(PaymentTotal), 'c', 'en-US')) AS 'Max Payment'
FROM	Invoices
GROUP BY VendorID
ORDER BY VendorID, MIN(PaymentTotal), MAX(PaymentTotal);

--

GO



PRINT 'CIS 275, Lab Week 4, Question 5 [3 pts possible]:
Sales Report
------------
Produce a report showing sales reps'' ID, their last names, and the amount of sales for 2015.

You need to use JOIN for this problem.
Use Examples database for this query.
Correct results will look like this:

Rep ID      Rep Last Name Year Total Sales
----------- ------------- ---- ---------------
5           Kramer        2015 $422,847.86
4           Winters       2015 $655,786.92
3           Markasian     2015 $1,132,744.56
2           Martinez      2015 $974,853.81
1           Thomas        2015 $923,746.85
' + CHAR(10)

GO


--

USE		Examples
SELECT	CONVERT(CHAR(11), SalesReps.RepID) AS 'Rep ID',
		CONVERT(CHAR(13), RepLastName) AS 'Rep Last Name',
		CONVERT(CHAR(04), SalesYear) AS 'Year',
		CONVERT(CHAR(15), FORMAT(SUM(SalesTotal), 'c', 'en-US')) AS 'Total Sales'
FROM	SalesReps JOIN SalesTotals ON SalesReps.RepID = SalesTotals.RepID
GROUP BY SalesReps.RepID, RepLastName, SalesYear, SalesTotal
HAVING	SalesYear = 2015
ORDER BY SalesReps.RepID DESC;

--

GO

PRINT 'CIS 275, Lab Week 4, Question 6  [3 pts possible]:
Price of items ordered
----------------------
Calculate the sum of the price of items ordered for each product.
In order to achieve this, make sure you subtract the price of
  the item by the discount amount, and then multiply that by the
  quantity of the items. Make sure your order of operations is
  correct in this calculation because it will matter!
Use the OrderItems table in the MyGuitarShop database.
Format your report as below.

Product ID  Item Price Total
----------- --------------------
1           $8,457.12
2           $10,071.60
3           $5,039.91
4           $2,039.97
5           $1,469.97
6           $6,850.20
7           $749.98
8           $911.37
9           $506.30
10          $1,196.00
' + CHAR(10)
GO


--

/* 
	This is a horrendous looking statement... but it works. Need to research later 
	how to make this spaghetti mess into something more readable.

	-----

	NOTES: In order for the list to actually group values on product ID, I need to keep
	all calulations contained within SUM. 
	
	If I attempt something like: SUM(ItemPrice - DiscountAmount) * Quantity
	This will result in 14 returned result as the sumnation is calculated for each entry
	index and will not allow grouping. 
	
	Use this instead: SUM((ItemPrice - DiscountAmount) * Quantity)
	This will ensure that the sumnation result is contained within the same statement.

	I'm guessing that SQL is rather strict in how commands are allowed to interperate data
	outside of a command? It feels wrong that SQL needs to be treated in this manner coming 
	from my programming background, but it explains some of the odd behaviors I am seeing.
*/

--

USE		MyGuitarShop
SELECT	CONVERT(CHAR(11), ProductID) AS 'Product ID',
		CONVERT(CHAR(21), FORMAT((SUM((ItemPrice - DiscountAmount) * Quantity)), 'c', 'en-US')) AS 'Item Price Total'
FROM	OrderItems 
GROUP BY ProductID, ItemPrice
ORDER BY ProductID;

--


GO

PRINT 'CIS 275, Lab Week 4, Question 7  [3 pts possible]:
Total Price Using Rollup
------------------------
Modify problem 6 to also show the total for all products combined.
Use the ROLLUP Operator (Murach page 172 (2019) or 149 (2022)) to do so.
There will be 10 records. Correct results will be like this:

Product ID  Item Price Total
----------- --------------------
1           $8,457.12
2           $10,071.60
3           $5,039.91
4           $2,039.97
5           $1,469.97
6           $6,850.20
7           $749.98
8           $911.37
9           $506.30
10          $1,196.00
NULL        $37,292.42 
' + CHAR(10)
GO


--

USE		MyGuitarShop
SELECT	CONVERT(CHAR(11), ProductID) AS 'Product ID',
		CONVERT(CHAR(21), FORMAT((SUM((ItemPrice - DiscountAmount) * Quantity)), 'c', 'en-US')) AS 'Item Price Total'
FROM	OrderItems 
GROUP BY ProductID WITH ROLLUP
ORDER BY ProductID DESC;

--
GO


PRINT 'CIS 275, Lab Week 4, Question 8  [3 pts possible]:
Total Using ROLLUP
------------------------------
Using ROLLUP Operator (Page 172 or 149 Murach), calculate the complete total for vendor number 122.
Use AP database for this query.
There will be 10 records.
Format your report as below. A label for the bottom total is optional.

Invoice Date                   Invoice Total
------------------------------ --------------------
2015-12-08 00:00:00            $3,813.33           
2016-02-01 00:00:00            $2,765.36           
2016-02-08 00:00:00            $2,184.11           
2016-02-12 00:00:00            $2,312.20           
2016-02-16 00:00:00            $2,115.81           
2016-02-20 00:00:00            $1,927.54           
2016-03-01 00:00:00            $2,318.03           
2016-03-23 00:00:00            $2,051.59           
2016-03-24 00:00:00            $3,689.99           
Total                          $23,177.96  
' + CHAR(10)

GO

--

USE		AP
SELECT	CONVERT(CHAR(31), InvoiceDate, 020) AS 'Invoice Date',
		CONVERT(CHAR(20), FORMAT(SUM(InvoiceTotal), 'c', 'en-US')) AS 'Invoice total'
FROM	Invoices
WHERE	VendorID = 122
GROUP BY ROLLUP(InvoiceDate)
ORDER BY InvoiceDate DESC;

--

GO

PRINT 'CIS 275, Lab Week 4, Question 9  [3 pts possible]:
Customer Orders
--------------------
Using JOIN find customers who have placed orders that have 2 or more different items in them.
Format your report with approriate spacing and column numbers. 
You will be using the MyGuitarShop database.
Correct results will have 5 rows that look like this:

CustomerID  Customer Last Name Order ID    Items in Order
----------- ------------------ ----------- --------------
1           Sherwood           3           2
6           Wilson             7           3
14          Morasca            16          2
27          Whobrey            31          2
35          Caudy              41          2

' + CHAR(10)



GO


--

/* 
	I am confused here. Why does group need all 4 select clauses
	listed in the Group By? Why can't I just tell it to group by
	Customer ID and let the aggregate in Orders.OrderID do its thing?

	Oh well, I'm sure there is a good reason for it but I'll figure it
	out later. At any rate, note to myself that I need to include the
	select clauses in the group to avoid whacky behaviors
*/

USE		MyGuitarShop
SELECT	CONVERT(CHAR(11), Customers.CustomerID) AS 'Customer ID',
		CONVERT(CHAR(19), LastName) AS 'Customer Last Name',
		CONVERT(CHAR(11), COUNT(Orders.OrderID)) AS 'Order ID',
		CONVERT(CHAR(14), SUM(Quantity)) AS 'Items in Order'
FROM	Customers JOIN Orders ON Customers.CustomerID = Orders.CustomerID
		JOIN OrderItems ON Orders.OrderID = OrderItems.OrderID
GROUP BY Customers.CustomerID, LastName, Orders.OrderID, Quantity
HAVING	Count(Orders.OrderID) > 1
ORDER BY Customers.CustomerID;

--


GO

PRINT 'CIS 275, Lab Week 4, Question 10  [3 pts possible]:
Finally, an easy one:-)
---------------------
Calculate the total sales for the SalesTotal.
Use Examples database.

Total Sales
--------------------
$9,399,836.87  
' + CHAR(10)

GO

--

/* I like the easy ones 😁 - Also cool that SSMS uses unicode */

USE		Examples
SELECT	CONVERT(CHAR(21), FORMAT(SUM(SalesTotal), 'c', 'en-US')) AS 'Total Sales'
FROM	SalesTotals;

--

GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 4' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


