USE IMDB
 
/* SUBQUERY usage - including multiple subqueries  */
 
/* Titles with a rating greater than five: */
SELECT TOP 10000 *
FROM   title_ratings
WHERE  averageRating > 5;
 
/* Shows belonging to this group: */
SELECT tconst,
       primaryTitle,
       startYear
FROM   title_basics
WHERE  tconst IN
   (SELECT TOP 10000 tconst
    FROM   title_ratings
    WHERE  averageRating > 5);
 
/* Shows which are musicals or romances: */
SELECT *
FROM   title_genre
WHERE  genre IN ('Musical', 'Romance');
 
/* Data for shows belonging to the previous group but not this one: */
SELECT tconst,
       primaryTitle,
       startYear
FROM   title_basics
WHERE  tconst IN
   (SELECT TOP 10000 tconst
    FROM   title_ratings
    WHERE  averageRating > 5
   )
AND tconst NOT IN
   (SELECT tconst
    FROM   title_genre
    WHERE  genre IN ('Musical', 'Romance')
   );
 
/*  Nested subquery version - functional, but unnecessary (and confusing):  */
SELECT tconst,
       primaryTitle,
       startYear
FROM   title_basics
WHERE  tconst IN
   (SELECT tconst
    FROM   title_ratings
    WHERE  averageRating > 5
     AND tconst NOT IN
      (SELECT tconst
       FROM   title_genre
       WHERE  genre IN ('Musical', 'Romance')
      )
   );
 
/*  More logical nested subquery: names of directors who have worked on titles with rankings greater than five: */
SELECT DISTINCT name_basics.primaryName
FROM   title_directors,
       name_basics
WHERE  name_basics.nconst = title_directors.nconst
AND    title_directors.tconst IN
   (SELECT tconst
     FROM   title_basics
     WHERE  tconst IN
        (SELECT tconst
          FROM   title_ratings
          WHERE  averageRating > 5)
   );
 
/* Subquery in the FROM clause - acts as a "virtual table".
   Note: must include "AS" label, or you get an error!  */
SELECT *
FROM
     (SELECT primaryTitle AS MOVIE_NAME,
             runtimeMinutes AS LENGTH
      FROM   title_basics
      WHERE  titleType = 'movie'
      AND    startYear = 1984
     ) AS FILMS_FROM_1984
ORDER BY MOVIE_NAME;
 
 
 
/* Common Table Expressions (aka CTE's).
Note: there must be a semicolon or the word GO as the last statement before the WITH.*/
 
/* Create a "virtual table" which calculates final age (questionable results!): */
WITH my_cte AS
   (SELECT nconst,
           primaryName,
           deathYear,
           birthYear,
           ISNULL(deathYear - birthYear, 0) AS finalAge
    FROM   name_basics
	WHERE primaryName LIKE 'V%' )
SELECT *
FROM   my_cte
ORDER BY finalAge DESC;
 
/* Why can't we include an ORDER BY clause in the CTE? 
Note the error which might appear in the Messages tab. */
WITH my_cte AS
   (SELECT nconst,
           primaryName,
           deathYear,
           birthYear,
           ISNULL(deathYear - birthYear, 0) AS finalAge
    FROM   name_basics
	WHERE primaryName LIKE 'V%'
     ORDER BY finalAge)
SELECT *
FROM   my_cte
ORDER BY finalAge DESC;

GO

/* Use CTE to calculate how many times each person has performed a role;
   In outer query, limit results to more than one occurrence: */
WITH profession_cte AS
   (SELECT NB.primaryName,
           TP.category,
           COUNT(*) AS TOTAL
    FROM   title_principals TP JOIN name_basics NB ON TP.nconst = NB.nconst
    GROUP BY NB.primaryName, TP.category)
SELECT *
FROM   profession_cte
WHERE  TOTAL > 1
ORDER BY primaryName, category;
 
/* In the NAMES database calculate breakdown of all names with genders, and totals: */
USE NAMES

SELECT CAST( N.Name AS CHAR(20) ) AS Name,
       YGT.Gender,
       YGT.Year,
       NC.NameCount
FROM   names AS N JOIN name_counts AS NC ON N.NameID = NC.FK_NameID
                  JOIN year_gender_totals AS YGT
                     ON NC.FK_YearGenderTotalID = YGT.YearGenderTotalID
ORDER BY N.NameID, YGT.Year, YGT.Gender;
 
/*  Use this query in a Common Table Expression (CTE).  Omit ORDER BY clause in the CTE: */
WITH MyNameQuery AS
   (  
     SELECT CAST( N.Name AS CHAR(20) ) AS Name,
             YGT.Gender,
             YGT.Year,
             NC.NameCount
     FROM   names AS N JOIN name_counts AS NC ON N.NameID = NC.FK_NameID
                       JOIN year_gender_totals AS YGT
                         ON NC.FK_YearGenderTotalID = YGT.YearGenderTotalID
   )
SELECT *
FROM   MyNameQuery
WHERE  MyNameQuery.Year = 1967
ORDER BY Name, Year, Gender;
 
/* Join two versions of this CTE together */
WITH MyNameQuery AS
   (  
     SELECT  CAST( N.Name AS CHAR(20) ) AS Name,
             YGT.Gender,
             YGT.Year,
             NC.NameCount
     FROM   names AS N JOIN name_counts AS NC ON N.NameID = NC.FK_NameID
                       JOIN year_gender_totals AS YGT
                         ON NC.FK_YearGenderTotalID = YGT.YearGenderTotalID
   )
SELECT A.Name,
       A.Year,
       A.Gender AS MALE,
       A.NameCount,
       B.Gender AS FEMALE,
       B.NameCount
FROM   MyNameQuery AS A JOIN MyNameQuery AS B ON A.Name = B.Name
                                             AND A.Year = B.Year
WHERE  A.Gender = 'M'
AND    B.Gender = 'F'
ORDER BY A.Year, A.Name;
 
/* HAVING clause usage */
 
/* Back to IMDB. ID's of directors who have worked on more than one film: */
USE IMDB

SELECT TD.nconst,
       COUNT(*) AS TOTALS
FROM   title_directors TD JOIN title_basics TB ON TD.tconst = TB.tconst
GROUP BY TD.nconst
HAVING COUNT(*) > 1
ORDER BY TD.nconst;
 
/* Names of these directors, along with the names of their films: */
SELECT TD.nconst,
       NB.primaryName,
       TB.primaryTitle
FROM   title_directors TD JOIN title_basics TB ON TD.tconst = TB.tconst
                          JOIN name_basics NB  ON NB.nconst = TD.nconst
WHERE  NB.nconst IN
   (
     SELECT TD.nconst
     FROM   title_directors TD JOIN title_basics TB ON TD.tconst = TB.tconst
     GROUP BY TD.nconst
     HAVING COUNT(*) > 1
   )
ORDER BY TD.nconst,
         NB.primaryName,
         TB.primaryTitle;
 
/* All genres, along with the total number of titles for each: */
SELECT TG.genre,
       COUNT(*)
FROM   title_genre AS TG
GROUP BY TG.genre
ORDER BY COUNT(*);
 
/* Genres whose total number of titles is in a specified range: */
SELECT TG.genre,
       COUNT(*)
FROM   title_genre TG
GROUP BY TG.genre
HAVING  COUNT(*) BETWEEN 50000 AND 100000
ORDER BY COUNT(*);
 
/* Titles in these genres: */
SELECT TB.primaryTitle,
       TG.genre
FROM   title_basics TB,
       title_genre TG
WHERE  TB.tconst = TG.tconst
AND    TG.genre IN
   (SELECT genre
     FROM   title_genre TG
     GROUP BY TG.genre
     HAVING  COUNT(*) BETWEEN 50000 AND 100000
   )
ORDER BY TB.primaryTitle;
 
/* Writers born after 1950, and their total number of titles: */
SELECT NB.primaryName,
       NB.birthYear,
       COUNT(*) AS TITLES
FROM   name_basics NB JOIN title_writers TW ON NB.nconst = TW.nconst
WHERE  NB.birthYear > 1950
GROUP BY NB.primaryName,
         NB.birthYear
ORDER BY NB.primaryName,
         NB.birthYear;
 
/* The same list, limited to totals in a given range: */
SELECT NB.primaryName,
       NB.birthYear,
       COUNT(*) AS TITLES
FROM   name_basics NB JOIN title_writers TW ON NB.nconst = TW.nconst
WHERE  NB.birthYear > 1950
GROUP BY NB.primaryName,
         NB.birthYear
HAVING COUNT(*) BETWEEN 10 AND 100
ORDER BY NB.primaryName,
         NB.birthYear;
 
/* Directors born after 1950, and their total number of titles: */
SELECT NB.primaryName,
       NB.birthYear,
       COUNT(*) AS TITLES
FROM   name_basics NB JOIN title_directors TD ON NB.nconst = TD.nconst
WHERE  NB.birthYear > 1950
GROUP BY NB.primaryName,
         NB.birthYear
ORDER BY NB.primaryName,
         NB.birthYear;
 
/* The same - but limit to directors who have written between 10 and 100 titles: */
SELECT NB.primaryName,
       NB.birthYear,
       COUNT(*) AS TITLES
FROM   name_basics NB JOIN title_directors TD ON NB.nconst = TD.nconst
WHERE  NB.birthYear > 1950
AND NB.nconst IN
   (SELECT NB2.nconst
    FROM   name_basics NB2 JOIN title_writers TW ON NB2.nconst = TW.nconst
    WHERE  NB2.birthYear > 1950
    GROUP BY NB2.nconst
    HAVING COUNT(*) BETWEEN 10 AND 100
   )
GROUP BY NB.primaryName,
         NB.birthYear
ORDER BY NB.primaryName,
         NB.birthYear;
 
/* How could we display the number of titles written?  It's calculated in the
   subquery, and not available in the outer SELECT clause...
   Join all three tables in the outer query, and calculate totals on
   DISTINCT values: */
SELECT NB.primaryName,
       NB.birthYear,
       COUNT(DISTINCT TD.tconst) AS TITLESDIRECTED,
       COUNT(DISTINCT TW.tconst) AS TITLESWRITTEN
FROM   name_basics NB JOIN title_directors TD ON NB.nconst = TD.nconst
                      JOIN title_writers TW   ON NB.nconst = TW.nconst
WHERE  NB.birthYear > 1950
AND NB.nconst IN
   (SELECT TW.nconst
    FROM   title_writers TW 
    WHERE  NB.nconst = TW.nconst
    GROUP BY TW.nconst
    HAVING COUNT(*) BETWEEN 10 AND 100
   )
GROUP BY NB.primaryName,
         NB.birthYear
ORDER BY NB.primaryName,
         NB.birthYear;
 
/* Re-write to eliminate the need for the subquery (title_writers is
   already available in the FROM clause): */
SELECT NB.primaryName,
       NB.birthYear,
       COUNT(DISTINCT TD.tconst) AS TITLESDIRECTED,
       COUNT(DISTINCT TW.tconst) AS TITLESWRITTEN
FROM   name_basics NB JOIN title_directors TD ON NB.nconst = TD.nconst
                      JOIN title_writers TW   ON NB.nconst = TW.nconst
WHERE  NB.birthYear > 1950
GROUP BY NB.primaryName,
         NB.birthYear
HAVING COUNT(DISTINCT TW.tconst)  BETWEEN 10 AND 100
ORDER BY NB.primaryName,
         NB.birthYear;
 
 
 
/* ISNULL and COALESCE */
 
/* Consider titles with no value in the "originalTitle" column: */
SELECT TB.primaryTitle,
       TB.originalTitle
FROM   title_basics TB
WHERE  originalTitle IS NULL;
 
 
/*  Replace this empty value with a default: */
SELECT TB.primaryTitle,
       ISNULL(TB.originalTitle,'[NONE]') AS ISNULLoriginal
FROM   title_basics TB
WHERE  originalTitle IS NULL;
 
/*  The same effect, using COALESCE: */
SELECT TB.primaryTitle,
       COALESCE(TB.originalTitle,'[NONE]') AS COALESCEoriginal
FROM   title_basics TB
WHERE  originalTitle IS NULL;
 
/*  COALESCE allows you to list multiple values; the first non-null one gets returned: */
SELECT TB.primaryTitle,
       TB.originalTitle,
       TB.startYear,
       TB.endYear,
       COALESCE(TB.originalTitle, STR(TB.startYear), STR(TB.endYear), '[NONE]') AS FirstValue
FROM   title_basics TB
WHERE  originalTitle IS NULL;
 
 
 
/* Ranking functions */
 
/* Consider a subset of people: */
SELECT NB.primaryName,
       NB.birthYear,
       NB.deathYear
FROM   name_basics NB
WHERE  NB.birthYear = 1935
AND    NB.deathYear IS NOT NULL;
 
/* Calculate rank based on several criteria.  Note that display order does
   not change their ranking: */
SELECT NB.primaryName,
       NB.birthYear,
       NB.deathYear,
       ROW_NUMBER() OVER (ORDER BY NB.deathYear) AS DeathOrder,
       ROW_NUMBER() OVER (ORDER BY NB.primaryName) AS NameOrder
FROM   name_basics NB
WHERE  NB.birthYear = 1935
AND    NB.deathYear IS NOT NULL
ORDER BY 3;
 
/* The same query using RANK.  Notice tie values (and gaps in the sequence): */
SELECT NB.primaryName,
       NB.birthYear,
       NB.deathYear,
       RANK() OVER (ORDER BY NB.deathYear) AS DeathOrder,
       RANK() OVER (ORDER BY NB.primaryName) AS NameOrder
FROM   name_basics NB
WHERE  NB.birthYear = 1935
AND    NB.deathYear IS NOT NULL
ORDER BY 3;
 
/* DENSE_RANK gets rid of the gaps: */
SELECT NB.primaryName,
       NB.birthYear,
       NB.deathYear,
       DENSE_RANK() OVER (ORDER BY NB.deathYear) AS DeathOrder,
       DENSE_RANK() OVER (ORDER BY NB.primaryName) AS NameOrder
FROM   name_basics NB
WHERE  NB.birthYear = 1935
AND    NB.deathYear IS NOT NULL
ORDER BY 3;
 
