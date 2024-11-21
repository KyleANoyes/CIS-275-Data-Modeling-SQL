/********************************************************************************************
CIS275 at PCC
CIS275 Lab Week 3: using SQL SERVER and different databases
Let your instructor know about any issues you many find in the instructions
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance, such as seeing answers to versions of specific 
questions or using AI to get answers. I agree to abide by class restrictions and understand 
that if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   [your name here]
                DATE:      [date]

*******************************************************************************************
*/
--(I did a bit of minor editing because
--of apostrophes which were part of the results):

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


PRINT 'CIS 275, Lab Week 3, Question 1  [3 pts possible]:
Vendor-Customer City
--------------------
Write a query to find Customers and vendors who are located in the same city. 
You will be using the Examples database
Consider the following requirements:
1-Use ORDER BY to order the result by the customer''s city and last name
2 Use CONVERT to format the columns with proper spacing
3-Make sure all columns have appropriate names (using AS where needed)
4-You must use JOIN

The Correct results will have 7 rows, and should look like this:
Customer Name  Customer City        Vendor Name                    Vendor City
-------------- -------------------- ------------------------------ --------------------
Lebihan        Chicago              Mcgraw Hill Companies          Chicago             
Lebihan        Chicago              Quality Education Data         Chicago             
Chelan         Dallas               Ingram                         Dallas              
Yorres         San Francisco        Computerworld                  San Francisco       
Yorres         San Francisco        Kent H Landsberg Co            San Francisco       
Yorres         San Francisco        Pacific Gas & Electric         San Francisco       
Yorres         San Francisco        IBM                            San Francisco          
' + CHAR(10)


GO

--
-- [Insert your code here]


	
  
--


GO

PRINT 'CIS 275, Lab Week 3, Question 2  [3 pts possible]:
Vendor State
-----------
Similar to the above query, this time, find Customers and vendors who are located in the same State.
You will be using the Examples database.
Consider the following requirements:
1-Exclude vendors who reside in IL and MA
2-You must use JOIN and IN
3-Order results by the Vendor''s state and name

The correct result will have 79 rows and will look like this:

Customer Name  Customer State Vendor Name                        Vendor State
-------------- -------------- ---------------------------------- ------------
Yorres         CA             Abbey Office Furnishings           CA   
Yorres         CA             American Express                   CA   
Yorres         CA             ASC Signs                          CA   
Yorres         CA             Aztek Label                        CA   
Yorres         CA             Bertelsmann Industry Svcs. Inc     CA   
...
Berglund       IA             Open Horizons Publishing           IA   
Chelan         TX             Ingram                             TX     
' + CHAR(10)

GO

--
-- [Insert your code here]



--


GO




------------------
PRINT 'CIS 275, Lab Week 3, Question 3  [3 pts possible]:
Extract
------------------
Write a query to find a transaction Tim Brown has made on 2002-04-12.
Consider the following:
1- You will be using CISDB database (F_EMPLOYEE and F_INVOICE tables)
2- You will be using INNER JOIN
3- Name columns appropriately
4- Insert $ using FORMAT method only
5- There will be only one record
Note: There are ways to do this that don''t require an INNER JOIN, but use an INNER
JOIN anyway.

The desired output should look like the following

Invoice #   Date         Total Price Employee ID Employee Name        Employee Title
----------- ------------ ----------- ----------- -------------------- --------------------
210         2002-04-12   $125.00     5           Tim Brown            Sales Associate					
' + CHAR(10)



--


GO


PRINT 'CIS 275, Lab Week 3, Question 4  [3 pts possible]:
UNION
------------------
Review the following UNION query. Correct the error to produce the following 
   result while still using UNION:

USE Examples
SELECT  InvoiceID AS "Invoice ID", 
        InvoiceNumber AS "Invoice Number",
		InvoiceTotal AS "Invoice Total"
FROM    Invoices
WHERE   InvoiceTotal > 50
   UNION
SELECT  InvoiceID  AS "Invoice ID", 
        InvoiceNumber AS "Invoice Number",
		InvoiceTotal AS "Invoice Total" 
FROM    PaidInvoices
WHERE   InvoiceTotal < 10
ORDER BY "Invoice Total";

Invoice ID  Invoice Number  Invoice Total
----------- --------------- ---------------------
14          25022117        6.00
20          24863706        6.00
70          24780512        6.00
16          21-4748363      9.95
23          21-4923721      9.95
2           3662            100.00
4           4553            250.00
'+ CHAR(10)

GO

--
-- [Insert your code here]


--
GO


PRINT 'CIS 275, Lab Week 3, Question 5  [3 pts possible]:
You will be using the IMDB database
Review the following tables:
  title_basics
  title_episode
  title_ratings
Consider the following:
1-Using JOIN write a query to display the Primary Title, Season Number, and Number of Votes
2-The Primary Title should include the word "Queen" in it
3-The season number should not be null
4-The number of votes should be between 5 and 7
5-Sort by the Title
6-There are 85 records

Here is how the result will look like:
Primary Title                                      Season#  Number of Votes
-------------------------------------------------- -------- ---------------
A Pair of Queens                                   4        7
A Word-For-Word Re-enactment of This Afternoon''s Q 3        7
Bandit Queen                                       1        6
Beauty Queen                                       1        5
Beauty Queen Killer/The Fingerprint                4        6
...
Weight Loss Queen                                  1        6
What Happened to the Beauty Queen?                 21       5
'+ CHAR(10)
GO

--
-- [Insert your code here]


--
GO


GO

PRINT 'CIS 275, Lab Week 3, Question 6  [3 pts possible]:
Akira Kurosawa
-----------------
For the following query, you need the IMDB database
Consider the following:
1-Write a query to find all Drama "Movies" that Akira Kurosawa has directed
2-You must use JOIN
3-Format your report accordingly
4-Order the result by Year
5-The result includes 31 records

Hint: title_directors has information about which people directed which shows. 
      title_genre has information about what genres a particular show belongs to.
Title                          Type         Year        Primary Name         Genre
------------------------------ ------------ ----------- -------------------- ----------
Uma                            movie        1941        Akira Kurosawa       Drama
Sanshiro Sugata                movie        1943        Akira Kurosawa       Drama
Ichiban utsukushiku            movie        1944        Akira Kurosawa       Drama
The Men Who Tread on the Tiger movie        1945        Akira Kurosawa       Drama
...
Ran                            movie        1985        Akira Kurosawa       Drama
Dreams                         movie        1990        Akira Kurosawa       Drama
Rhapsody in August             movie        1991        Akira Kurosawa       Drama
Maadadayo                      movie        1993        Akira Kurosawa       Drama 
' + CHAR(10)


GO

--
-- [Insert your code here]


GO

PRINT 'CIS 275, Lab Week 3, Question 7  [3 pts possible]:
Al Pacino
-----------------
Consider the following:
1.Write a query to show the movies where Al Pacino was both the director and writer. 
2-Use IMDB database.
3-Produce the title, type, year, and Run Time.
4-Format Title as 30 characters wide and Director/Writer as 15 characters wide. Order by Year.
5-You must use JOIN.

Correct results will have 2 rows formatted as:
Title                          Type         Run Time    Year        Director/Writer
------------------------------ ------------ ----------- ----------- --------------------
Looking for Richard            movie        112         1996        Al Pacino
Wilde Salomé                   movie        95          2011        Al Pacino
' + CHAR(10)

GO

--
-- [Insert your code here]




--



GO

PRINT 'CIS 275, Lab Week 3, Question 8  [3 pts possible]:
Wes Craven''s TVSeries
---------------------------------------------------------
For the following query, you need IMDB.
Consider the following:
1-Wes Craven has directed many movies and TV series
2-Create a list of his TV series in descending order by rating
3-Format the title as 30 characters wide
4-You must use JOIN
5-Your results should appear as below (I escaped the apostrophe in one result)
6-Title_ratings contains the number of votes and the average rating for each show
7-These 3 records are produced by this query

Primary Name         Series Name                    Type         Rating Year
-------------------- ------------------------------ ------------ ------ -----------
Wes Craven           Walt Disney''s Wonderful World tvSeries     8.6    1954
Wes Craven           The Twilight Zone              tvSeries     7.8    1985
Wes Craven           Nightmare Cafe                 tvSeries     7.4    1992
' + CHAR(10)

GO

--
-- [Insert your code here]


--



GO


PRINT 'CIS 275, Lab Week 3, Question 9  [3 pts possible]:
Top 10 Unit Price
----------------
For the following, you will be using the MyGuitarShop database
Consider the following:
1-Find the 10 most highly priced items that have been ordered
2-Use JOIN with two related tables to produce the list
3-Order by Item Price in descending order 
4-Format all fields accordingly

OrderID     Item Price   Order Date
----------- ------------ --------------------
3           2517.00      Mar 29 2016  9:44AM
12          2517.00      Apr  4 2016  8:15AM
22          2517.00      Apr 12 2016 12:26PM
27          2517.00      Apr 20 2016  9:17AM
31          2517.00      Apr 29 2016  6:47AM
32          2517.00      May  1 2016  1:23AM
37          2517.00      May  6 2016  2:15PM
38          1199.00      May  8 2016 11:41AM
34          1199.00      May  2 2016 11:36AM
25          1199.00      Apr 20 2016  8:23AM
' + CHAR(10)

GO

--
-- [Insert your code here]



--
GO


GO
PRINT 'CIS 275, Lab Week 3, Question 10  [3 pts possible]:
Write a simple problem statement similar to the ones you have seen above 
then write a simple query, which uses INTERSECT to produce the result for the problem statement you wrote.
Use two tables from the TV or AP databases, such as Vendors and invoice tables.
Use the WHERE clause to set conditions, such as selected vendor numbers.

For an example, see near the end of the "UNION/INTERSECT/EXCEPT" video in 
"Tutorial Videos on JOINs and on UNION/INTERSECT/EXCEPT".
' + CHAR(10)

GO

--
-- [Insert your code here]


--
GO



GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 3' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


