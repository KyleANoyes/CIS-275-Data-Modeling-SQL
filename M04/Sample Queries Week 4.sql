
USE TV

-- Show only the Genre column, for all rows
SELECT Genre
FROM   SHOW
ORDER BY ShowID;

/*
-- Uncomment to try to eliminate duplicates. Why the error?
SELECT DISTINCT Genre
FROM   SHOW
ORDER BY ShowID;
*/


-- Change the ORDER BY and we're good:
SELECT DISTINCT Genre
FROM   SHOW
ORDER BY Genre;

-- Another way to eliminate duplicates: GROUP BY
SELECT Genre
FROM   SHOW
GROUP BY Genre
ORDER BY Genre;


-- Use the aggregate function COUNT on different values:
SELECT COUNT(*) AS ROW_TOTAL,
       COUNT( Genre ) AS GENRE_TOTAL,
       COUNT( DISTINCT Genre ) UNIQUE_GENRES
FROM   SHOW;


/* Total number of SHOW entries, broken down by genre: */
SELECT Genre,
       COUNT(*) AS GENRE_COUNTS
FROM   SHOW
GROUP BY Genre
ORDER BY Genre;


/* Subdivided by classification: */
SELECT Genre,
       Classification,
       COUNT(*)
FROM   SHOW
GROUP BY Genre, Classification
ORDER BY Genre, Classification;


SELECT *
FROM   SHOW;

/* Determine average rating for each genre: */
SELECT Genre,
       COUNT(*) AS Records,
       AVG( StarRating ) AS "AVG Rating"
FROM   SHOW
GROUP BY Genre
ORDER BY Genre;


/* If you assume that NULLS are zero ratings, look what happens: */
SELECT Genre,
       COUNT(*) AS RECORDS,
       COUNT( StarRating ) AS NON_NULL_RECS,
       AVG(StarRating) AS AVG_RATING,
       AVG( ISNULL(StarRating, 0) ) AS AVG_RATE_ZERONULL
FROM   SHOW
GROUP BY Genre
ORDER BY Genre;


/* Divide SUM of ratings by COUNT.  Same result as AVG: */
SELECT Genre,
       COUNT(StarRating) AS COUNT_RATINGS,
       SUM(StarRating) AS SUM_RATINGS,
       SUM(StarRating) / COUNT(StarRating) AS CALC_AVG_RATINGS,
       AVG(StarRating) AS AVG_RATINGS
FROM   SHOW
GROUP BY Genre
ORDER BY Genre;


/* Consider rows in SCHEDULE: each has start & end times */
SELECT *
FROM   SCHEDULE;

/* Use DATEDIFF function to subtract one from the other
   (output in minutes "mi" or hours "hh"): */
SELECT ScheduleID,
       StartTime,
       EndTime,
       DATEDIFF(mi, StartTime, EndTime) AS "DD Minutes",
       DATEDIFF(hh, StartTime, EndTime) AS "DD Hours"
FROM   SCHEDULE
ORDER BY ScheduleID;

/* Using this method, show the ten longest shows: */
SELECT TOP 10 ScheduleID,
       StartTime,
       EndTime,
       DATEDIFF(mi, StartTime, EndTime) AS "DD Minutes"
FROM   SCHEDULE
ORDER BY "DD Minutes" DESC, ScheduleID;


/* Now show a breakdown of shows by calculated length: */
SELECT DATEDIFF(mi, StartTime, EndTime) AS "DD Minutes",
       COUNT(*) AS "NUM hows"
FROM   SCHEDULE
GROUP BY  DATEDIFF(mi, StartTime, EndTime)
ORDER BY "DD Minutes" DESC;


/* Use HAVING clause to get only shows of certain lengths: */
SELECT  DATEDIFF(mi, StartTime, EndTime) AS DD_MINUTES,
        COUNT(*) AS NUM_SHOWS
FROM    SCHEDULE
GROUP BY  DATEDIFF(mi, StartTime, EndTime)
HAVING  DATEDIFF(mi, StartTime, EndTime) BETWEEN 60 AND 90
ORDER BY DD_MINUTES;


SELECT  DATEDIFF(mi, StartTime, EndTime) AS DDMINUTES,
        COUNT(*) AS NUMSHOWS
FROM    SCHEDULE
WHERE   DATEDIFF(mi, StartTime, EndTime) BETWEEN 60 AND 90
GROUP BY  DATEDIFF(mi, StartTime, EndTime)
ORDER BY DDMINUTES;


/* For every show ID, display total number of shows and total length: */
SELECT FK_ShowID,
       COUNT(*) TOTAL_SHOWS,
       SUM( DATEDIFF(mi, StartTime, EndTime) ) AS TOTAL_LENGTH
FROM   SCHEDULE
GROUP BY FK_ShowID
ORDER BY FK_ShowID;


/* Looking at genres again: */
SELECT Genre,
       Classification
FROM   SHOW
ORDER BY Genre, Classification;


/* Note difference between COUNT and COUNT(DISTINCT): */
SELECT Genre,
       COUNT(*) AS TOTAL_ROWS,
       COUNT( Classification ) AS TOTAL_CLASS,
       COUNT( Classification ) AS WHAT,
       COUNT(DISTINCT Classification) AS TOTAL_DIST_CLASS
FROM   SHOW
GROUP BY Genre
ORDER BY Genre;

---------------------------------------

USE IMDB

/* Reminder of all the SQL clauses, in order:
     SELECT
     FROM
     WHERE
     GROUP BY
     HAVING
     ORDER BY
*/

/* Some of the 4 million plus rows */
SELECT TOP 10000 *
FROM   title_basics;


/* Calculate total number of rows */
SELECT COUNT(*) AS "ALL Rows"
FROM   title_basics;

/* Include a COUNT of a column containing NULLs */
SELECT COUNT(*) AS ALL_ROWS,
       COUNT( endYear ) AS YEAR_ROWS,
       COUNT( DISTINCT endYear ) AS YEAR_VALUES
FROM   title_basics;

/* All five of our aggregate functions, on this numeric column */
SELECT COUNT(runtimeMinutes) AS COUNT,
       AVG(runtimeMinutes) AS AVG,
       SUM(runtimeMinutes) AS SUM,
       MIN(runtimeMinutes) AS MIN,
       MAX(runtimeMinutes) AS MAX
FROM   title_basics;


/* The same on a non-numeric column */
SELECT COUNT(primaryTitle) AS COUNT,
       -- AVG(primaryTitle) AS AVG,
       -- SUM(primaryTitle) AS SUM,
       MIN(primaryTitle) AS MIN,
       MAX(primaryTitle) AS MAX
FROM   title_basics;


/* Type values for some rows */
SELECT TOP 10000 titleType
FROM   title_basics;


/* All unique Type values */
SELECT DISTINCT titleType
FROM   title_basics;


/* Another method */
SELECT titleType
FROM   title_basics
GROUP BY titleType;


/* Now with breakdown */
SELECT titleType,
       COUNT(*) AS GRP_TOTAL
FROM   title_basics
GROUP BY titleType;


/* ...and grand total */
SELECT titleType,
       COUNT(*) AS GRP_TOTAL
FROM   title_basics
GROUP BY titleType WITH ROLLUP;


/* Same total, now calculated in each row */
SELECT titleType,
       COUNT(*) AS GRP_TOTAL,
       SUM( COUNT(*) ) OVER () AS GRAND_TOTAL
FROM   title_basics
GROUP BY titleType;


/* Group total calculated with another method */
SELECT titleType,
       COUNT(*) AS GRP_TOTAL,
       SUM( COUNT(*) ) OVER () AS GRAND_TOTAL,
       SUM( COUNT(*) ) OVER (PARTITION BY titleType) AS PARTIONED
FROM   title_basics
GROUP BY titleType;


/* Limit rows based on calculated value */
SELECT titleType,
       COUNT(*)
FROM   title_basics
GROUP BY titleType
HAVING COUNT(*) > 100000;

/*
-- Uncomment to try this in the WHERE clause. Why will it not work?
SELECT titleType,
       COUNT(*)
FROM   title_basics
WHERE  COUNT(*) > 100000
GROUP BY titleType;
*/

