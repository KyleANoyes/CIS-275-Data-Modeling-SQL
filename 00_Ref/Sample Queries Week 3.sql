/* NOTE: Some of the queries take a very long time to run. 
         Do not worry if this takes more than 5 minutes to finish if you run them all at once.
*/
USE FiredUp

-- Look at the contents of CUSTOMER: 33 rows
SELECT *
FROM   CUSTOMER
ORDER BY CustomerID;

-- Now look at INVOICE: 35 rows
SELECT *
FROM   INVOICE
ORDER BY InvoiceNbr;

/* Notice that INVOICE has a column FK_CustomerID which tells us
   which customer each individual invoice belongs to.
*/


/* What if we want to see fields from each of these tables,
   e.g. customer name and invoice number?  Let's try using
   both tables together (this is called a JOIN):
*/
SELECT *
FROM   CUSTOMER,
       INVOICE
ORDER BY CustomerID, InvoiceNbr;

/* We now see all columns from both tables in every row.  However,
   notice that the results include 1,155 rows(!)  If you look closely,
   you will see that the results include every combination of customer
   ID (33 values) with every invoice number (35 values):

                 33 x 35 = 1155

   This result is called a "Cartesian product" and it does not give us
   any meaningful information.

   Again, notice that INVOICE contains a column called FK_CustomerID.
   What we would really like to see is the combination of every customer
   with the invoices *for that customer* rather than every invoice in the table.

   To restrict the rows in our results, we use selection (a condition in the
   WHERE clause); let's add a stipulation that the invoice's foreign key value
   must match the primary key in CUSTOMER:
*/
SELECT *
FROM   CUSTOMER,
       INVOICE
WHERE  CustomerID = FK_CustomerID
ORDER BY CustomerID, InvoiceNbr;

/* The results are now only 35 rows (one row for every invoice).  Notice that
   the INVOICE foreign key value is the same as the primary key of CUSTOMER.
*/


/* Lastly, we perform projection and limit the columns of the output to only
   the ones we want to display:
*/
SELECT Name,
       InvoiceNbr
FROM   CUSTOMER,
       INVOICE
WHERE  CustomerID = FK_CustomerID
ORDER BY CustomerID, InvoiceNbr;

/* The above example of a join uses something called "implicit join syntax";
   i.e. we're implying that we want to join these two tables by including
   both of them in the FROM clause.  There is another method called "explicit
   join syntax" which does exactly the same thing, but uses different language:
*/
SELECT Name,
       InvoiceNbr
FROM   CUSTOMER JOIN INVOICE ON CustomerID = FK_CustomerID
ORDER BY CustomerID, InvoiceNbr;

/* Note that these are functionally identical; they will always give the same
   results, and neither is more efficient that the other.  You are free to use
   either explicit or implicit join syntax in your queries; I just want you to
   understand how to use both methods, and how to read them when looking at
   queries written by others.
*/

/* Notice that certain names repeat in the results; this is because some
   customers have more than one invoice.  If you look carefully, you will see
   that these repetitions give us less than 33 distinct values...  There were
   33 entries in CUSTOMER, so it looks as if some of the customers have no
   invoices at all.  You will not see their names here, because the join only
   shows customer records which have at least one matching value in the
   FK_CustomerID column of the INVOICE table (as the WHERE clause dictates).

   This is called an "inner join".  There is another type of query called
   (approprately enough) an "outer join", which will show us every value from
   the CUSTOMER table even if it has no matching value in INVOICE:
*/
SELECT Name,
       InvoiceNbr
FROM   CUSTOMER LEFT OUTER JOIN INVOICE ON CustomerID = FK_CustomerID
ORDER BY CustomerID, InvoiceNbr;


/* Notice that this is declared as a LEFT OUTER JOIN because the table on the
   left side (CUSTOMER) is the one for which we want to see all rows regardless
   of matches.  You can also use RIGHT OUTER JOIN and FULL OUTER JOIN (for
   both sides).  In this case it is not necessary, since we should never find any
   INVOICE entries with no customer (right?).

   In the results you will see five names which have a NULL value in the InvoiceNbr
   column; none of these customers has any correponding entries in the INVOICE table.
*/

USE NAMES
/* NOTE: These are the queries that might take a very long time to run since they return
         several million rows. Be patient.*/

/* Simple join of two tables: primary key of names to foreign key on counts: */
SELECT *
FROM   names JOIN name_counts ON names.NameID = name_counts.FK_NameID;

/*  The same join, in implicit syntax: */
SELECT *
FROM   names, name_counts
WHERE  names.NameID = name_counts.FK_NameID;

/* Use CONVERT to format the NameCount: */
SELECT names.NameID,
       names.Name,
        'Total: ' + CONVERT(VARCHAR, name_counts.NameCount) AS COUNTCONV
FROM   names, name_counts
WHERE  names.NameID = name_counts.FK_NameID;

/*  Self join: two copies of the same table.  Must distinguish between them with alias! 
    This shows all names that sound like the given name */
SELECT N1.Name,
       N2.Name
FROM   names AS N1 JOIN names AS N2 ON N1.Metaphone = N2.Metaphone
WHERE  N1.Name <> N2.Name
ORDER BY N1.Name;

/*  For this version, one name must be contained within the other: */
SELECT N1.Name,
       N2.Name
FROM   names AS N1 JOIN names AS N2 ON N1.Metaphone = N2.Metaphone
WHERE  N1.Name <> N2.Name
AND    N1.Name LIKE '%'+N2.Name+'%'
ORDER BY N1.Name;

/* Consider a subset of name_counts: 15 rows */
SELECT *
FROM   name_counts
WHERE  Rank = 17043;

/* ...and a few names records: 10 rows */
SELECT *
FROM   names
WHERE  Metaphone = 'MNTRL'

/*  Now perform a CROSS JOIN with these conditions.  How many rows? */
SELECT *
FROM   name_counts CROSS JOIN names
WHERE  Rank = 17043
AND    Metaphone = 'MNTRL'
ORDER BY name_counts.ID, names.NameID;

/* Try that cross join without the WHERE clause (see how long it takes!).
It returns every combination of rows from one table with the other... */


/* Some examples of string functions: */
SELECT Name,
       LEN(Name) AS CHAR_COUNT,
        LEFT(Name, 3) AS FIRST_THREE,
        SUBSTRING(Name, 4, 3) AS MIDDLE_THREE,
        RIGHT(Name, 3) AS LAST_THREE,
        REPLACE(Name, 'a', 'X') AS SWAP_A_WITH_X
FROM   names;

/* Two queries: different results, but the same number/type of columns: */

SELECT Name,
       Metaphone
FROM   names
WHERE  Metaphone = 'TYLR'
ORDER BY Name;

SELECT Name,
       Metaphone
FROM   names
WHERE  Metaphone = 'OSTN'
ORDER BY Name;

/* Results can be combined with UNION.  Note the single ORDER BY at the end: */

SELECT Name,
       Metaphone
FROM   names
WHERE  Metaphone = 'TYLR'
   UNION
SELECT Name,
       Metaphone
FROM   names
WHERE  Metaphone = 'OSTN'
ORDER BY Name;


/* Switch to IMDB now */
USE IMDB

/* A left outer join of two tables.  Note some records have NULL values: */
SELECT *
FROM   name_basics LEFT JOIN title_directors ON name_basics.nconst = title_directors.nconst;


/* Limit results to non-matching rows (the ones with a NULL nconst): */
SELECT *
FROM   name_basics LEFT JOIN title_directors ON name_basics.nconst = title_directors.nconst
WHERE  title_directors.nconst IS NULL;


USE NAMES

/* Join of three tables: three tables, two join conditions */
SELECT *
FROM   names JOIN name_counts ON names.NameID = name_counts.FK_NameID
             JOIN year_gender_totals ON year_gender_totals.YearGenderTotalID = name_counts.FK_YearGenderTotalID
ORDER BY names.NameID;


/*  The same join, in implicit syntax: */
SELECT *
FROM   names,
       name_counts,
        year_gender_totals
WHERE  names.NameID = name_counts.FK_NameID
AND    year_gender_totals.YearGenderTotalID = name_counts.FK_YearGenderTotalID
ORDER BY names.NameID;

/* Limit results with WHERE clause conditions: */
SELECT CONVERT(CHAR(15), Name) AS CHARNAME,
       Year,
       'Total:' + CAST(NameCount AS CHAR) AS NAMETOTAL
FROM   names JOIN name_counts ON names.NameID = name_counts.FK_NameID
             JOIN year_gender_totals ON year_gender_totals.YearGenderTotalID = name_counts.FK_YearGenderTotalID
WHERE  Rank > 300
AND    Year BETWEEN 1900 AND 1936
ORDER BY names.NameID;

/* As before: two separate queries: */
SELECT Name,
       NameID,
       Metaphone
FROM   names
WHERE  NameID BETWEEN 50000 AND 50025
ORDER BY Name;

SELECT Name,
       NameID,
       Metaphone
FROM   names
WHERE  Name LIKE 'R%'
ORDER BY Name;

/* Combine with INTERSECT to get overlapping rows.  Same rules as UNION apply: */
SELECT Name,
       NameID,
       Metaphone
FROM   names
WHERE  NameID BETWEEN 50000 AND 50025
   INTERSECT
SELECT Name,
       NameID,
       Metaphone
FROM   names
WHERE  Name LIKE 'R%'
ORDER BY Name;
