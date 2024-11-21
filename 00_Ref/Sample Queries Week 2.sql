/* See below for some sample queries for this week. You will benefit by copying and executing them in SSMS to see what you get.

You will find SSMS has more room for the query results if you close the Properties Window on the right. You can also autohide that and/or the Object Window by clicking the pushpins. */

 
USE NAMES;
 
/* Some names have different ways to spell them. How many ways can the name Alan be (mis)spelled? */
SELECT NameID,
       Name
FROM   names
WHERE  Name = 'Alan'
  OR   Name = 'Allan'
  OR   Name = 'Allen'
  OR   Name = 'Alien';
 
/* Another method to get the same results: */
SELECT NameID,
       Name
FROM   names
WHERE  Name IN ('Alan', 'Allan', 'Allen', 'Alien');
 
/* According to Wikipedia, "Metaphone is a phonetic algorithm … for indexing words by their English pronunciation. ... similar-sounding words should share the same keys. "
Notice that these names all have the same Metaphone value: */
SELECT *
FROM   names
WHERE  Name IN ('Alan', 'Allan', 'Allen', 'Alien');
 
/* What other variations are there?  Sort them alphabetically: */
SELECT *
FROM   names
WHERE  Metaphone = 'ALN'
ORDER BY Name;
 
/* Use the LIKE string comparison to match anything beginning with 'A', containing an 'l', and ending in 'n': */
SELECT *
FROM   names
WHERE  Name LIKE 'A%l%n'
ORDER BY Name;
 
/* Limit this to just the Metaphone values.  Lots of duplicates! */
SELECT Metaphone
FROM   names
WHERE  Name LIKE 'A%l%n'
ORDER BY Metaphone;
 
/* Eliminate duplicates with DISTINCT: */
SELECT DISTINCT Metaphone
FROM   names
WHERE  Name LIKE 'A%l%n'ORDER BY Metaphone;

/* Rename column. Always use double quotes when the alias includes spaces or special characters: */
SELECT Name  AS "First Name",
       Metaphone AS Meta
FROM   names
WHERE  Name LIKE  'Gar%'
ORDER BY Name;

/* Switch databases */
USE AdventureWorks2012;

 
/* All available products: */
SELECT *
FROM   Production.Product;
 
/* Limit based on multiple conditions: size, weight, price: */
SELECT ProductID,
       SizeUnitMeasureCode AS "Size Unit",
       Size,
       WeightUnitMeasureCode AS "Weight Unit",
       Weight,
       ListPrice
FROM   Production.Product
WHERE  SizeUnitMeasureCode = 'CM'
  AND  Size > 50
  AND  WeightUnitMeasureCode = 'LB'
  AND  Weight < 20
  AND  ListPrice BETWEEN 100 AND 500
ORDER BY Size, Weight DESC;
 
/* Show all products with no color listed.  Why doesn't this work? */
SELECT *
FROM   Production.Product
WHERE  Color = NULL;
 
/* The correct comparison: */
SELECT *
FROM   Production.Product
WHERE  Color IS NULL;

/* Use the ISNULL function to replace NULLS with a value: */
SELECT ProductID,
       Name,
       Color,
       ISNULL(Color, '(none)') AS HUE
FROM   Production.Product;

/* Concatenate two character strings into one using the + sign: */
SELECT ProductID,
       ISNULL(Color, 'Monachrome') + ' ' + Name AS ProductDesc
FROM   Production.Product
ORDER BY ProductDesc;    -- We can use the label in the ORDER by clause
 
/* All products in descending order by list price: */
SELECT ProductID,
       Name,
       ListPrice AS "List Price"
FROM   Production.Product
ORDER BY ListPrice DESC;
 
/* Limit to just the ten most expensive: */
SELECT TOP 10 ProductID,
       Name,
       ListPrice AS List_Price
FROM   Production.Product
ORDER BY ListPrice DESC;
 
/* Include tie values using WITH TIES.  How many are returned now? */
SELECT TOP 10 WITH TIES ProductID,
       Name,
       ListPrice AS List_Price
FROM   Production.Product
ORDER BY ListPrice DESC;
 
/* Use the OR comparison to show products which are black OR have a price greater than 1,000 */
SELECT Name,
       Color,
       ListPrice AS List_Price
FROM   Production.Product
WHERE  Color = 'Black'
  OR   ListPrice > 1000
ORDER BY ProductID;
 
/* Alternate logic (same results).  Use parentheses! */
SELECT Name,
       Color,
       ListPrice AS List_Price
FROM   Production.Product
WHERE  ( Color <> 'Black' AND ListPrice > 1000)
  OR   ( Color =  'Black' AND NOT ListPrice > 1000)
  OR   ( Color =  'Black' AND ListPrice > 1000)
ORDER BY ProductID;

/* Also show dates with some different conversions. Execute Dates_CONVERT.sql to see all of them. */
SELECT Name,
       Color,
       ListPrice AS List_Price,
       SellStartDate,
       CONVERT(CHAR(10), SellStartDate)      AS "Sell Date Default",
       CONVERT(CHAR(10), SellStartDate, 1)   AS "Sell Date US",
       CONVERT(CHAR(10), SellStartDate, 103) AS "Sell Date EU"
FROM   Production.Product
WHERE  Color = 'Black'
  OR   ListPrice > 1000
ORDER BY ProductID;
 
/* Identify products containing an apostrophe in the name.
   Must use double-apostrophe in the comparison (as an escape character): */
SELECT ProductID,
       Name
FROM   Production.Product
WHERE  Name LIKE '%''%'
ORDER BY ProductID;
 
/* Show the name 20 characters wide: */
SELECT ProductID,
       CAST(Name AS VARCHAR(20)) AS Name
FROM   Production.Product
WHERE  Name LIKE '%''%'
ORDER BY ProductID;

 /* The following five queries will produce almost the same result using five ways to format the output.
   The first three do not show commans, the last two do.
   The formatting differs if you send the results to text or a file instead of the usual grid.
       (Menu : Query - Results To - Results to Text  or CTRL-T)
   Also note the variations used in the alias. Double-quotes are preferred, though no quotes are 
   needed unless spaces or special characters are included. */

USE AP;
SELECT TOP 4 ('$' + CONVERT(varchar(9), InvoiceTotal)) AS "Total"
FROM   Invoices;

-- Second version
USE AP
SELECT TOP 4 CONCAT('$', InvoiceTotal) AS Total
FROM   Invoices;

-- Third version
USE AP
SELECT TOP 4 '$' + CAST(InvoiceTotal AS VARCHAR(15)) "Total"
FROM   Invoices;

-- Fourth version
USE AP;
SELECT TOP 4 FORMAT(InvoiceTotal, 'C') AS "Total"
FROM   Invoices;

-- Fifth version
USE AP;
SELECT TOP 4 FORMAT(InvoiceTotal, '$#,#.00') AS "Total"
FROM   Invoices;


-- All five versions
USE AP;
SELECT	TOP 4 
		'$' + CONVERT(varchar(9), InvoiceTotal) AS "CONVERT",
		CONCAT('$', InvoiceTotal) AS "CONCAT",
		'$' + CAST(InvoiceTotal AS VARCHAR(15)) "CAST",
		FORMAT(InvoiceTotal, 'C') AS "FORMAT C",
		FORMAT(InvoiceTotal, '$#,#.00') AS "FORMAT #"
FROM   Invoices;