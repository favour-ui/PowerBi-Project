SELECT * FROM customer_churn;

ALTER TABLE customer_churn
MODIFY COLUMN Quantity varchar(20);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Customer Churn Analysis2.csv'
INTO TABLE customer_churn
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select *,
count(Quantity) over(partition by country) as count
from customer_churn;

-- EXPLOATION OF DATA-----

SELECT * FROM customer_churn;

SELECT COUNT(*),
COUNT(ï»¿InvoiceNo) AS ï»¿InvoiceNo_NULL,
COUNT(StockCode) AS StockCode_NULL,
COUNT(Description) AS Description_NULL,
COUNT(Quantity) AS Quantity_NULL,
COUNT(InvoiceDate) AS InvoiceDate_NULL,
COUNT(UnitPrice) AS UnitPrice_NULL,
COUNT(CustomerID) AS CustomerID_NULL,
COUNT(Country) AS Country_NULL
FROM customer_churn;


SELECT COUNT(*),
(COUNT(*) - COUNT(ï»¿InvoiceNo)) * 100 / COUNT(*) AS ï»¿InvoiceNo_NULL_PCT,
(COUNT(*) - COUNT(StockCode)) * 100 / COUNT(*) AS StockCode_NULL_PCT,
(COUNT(*) - COUNT(Description)) * 100 / COUNT(*) AS Description_NULL_PCT,
(COUNT(*) - COUNT(Quantity)) * 100 / COUNT(*) AS Quantity_NULL_PCT,
(COUNT(*) - COUNT(InvoiceDate)) * 100 / COUNT(*) AS InvoiceDate_NULL_PCT,
(COUNT(*) - COUNT(UnitPrice)) * 100 / COUNT(*) AS UnitPrice_NULL_PCT,
(COUNT(*) - COUNT(CustomerID)) * 100 / COUNT(*) AS CustomerID_NULL_PCT,
(COUNT(*) - COUNT(Country)) * 100 / COUNT(*) AS Country_NULL_PCT
FROM customer_churn;

ALTER TABLE customer_churn
RENAME COLUMN ï»¿InvoiceNo TO InvoiceNo;


SELECT InvoiceNo FROM customer_churn
WHERE InvoiceNo = '';

SELECT StockCode FROM customer_churn
WHERE StockCode = '';

DESCRIBE customer_churn;

--  WORKING ON NUMERICS VALUES

-- WORKING ON THE InvoiceNo 
SELECT InvoiceNo FROM customer_churn;

SELECT DISTINCT InvoiceNo FROM customer_churn
WHERE InvoiceNo IS NULL
OR InvoiceNo = ''
OR InvoiceNo NOT REGEXP '^[-]?[0-9]+(\.[0-9]+)?$';


ALTER TABLE customer_churn 
ADD COLUMN RAW_InvoiceNo VARCHAR(20);

UPDATE customer_churn  
SET RAW_InvoiceNo = InvoiceNo;

SELECT SUBSTRING(InvoiceNo,2)
FROM customer_churn 
WHERE InvoiceNo LIKE 'C%';

UPDATE customer_churn 
SET InvoiceNo = substring(InvoiceNo,2)
WHERE InvoiceNo LIKE 'C%';

SELECT SUBSTRING(InvoiceNo,2)
FROM customer_churn 
WHERE InvoiceNo LIKE 'A%';

UPDATE customer_churn
SET InvoiceNo = substring(InvoiceNo,2)
WHERE InvoiceNo LIKE 'A%';

ALTER TABLE customer_churn  
MODIFY COLUMN InvoiceNo INT;

-- WORKING ON THE StockCode

SELECT StockCode FROM customer_churn ;

SELECT DISTINCT StockCode FROM customer_churn 
WHERE StockCode IS NULL
OR StockCode = ''
OR StockCode NOT REGEXP '^[-]?[0-9]+(\.[0-9]+)?$';

ALTER TABLE customer_churn  
ADD COLUMN RAW_StockCode VARCHAR(30);

UPDATE customer_churn 
SET RAW_StockCode = StockCode;

SELECT LEFT(StockCode, 5)
FROM customer_churn ;

UPDATE customer_churn 
SET StockCode = LEFT(StockCode, 5);

SELECT *
FROM customer_churn
WHERE StockCode LIKE 'P%'
OR StockCode LIKE 'D%'
OR StockCode LIKE 'B%'
OR StockCode LIKE 'M%'
OR StockCode LIKE 'A%'
OR StockCode LIKE 'G'
OR StockCode LIKE 'C%'
OR StockCode LIKE 'S%';


UPDATE customer_churn
SET StockCode = NULL
WHERE StockCode LIKE 'P%'
OR StockCode LIKE 'D%'
OR StockCode LIKE 'B%'
OR StockCode LIKE 'M%'
OR StockCode LIKE 'A%'
OR StockCode LIKE 'G%'
OR StockCode LIKE 'C%'
OR StockCode LIKE 'S%';


ALTER TABLE customer_churn
MODIFY COLUMN StockCode INT;

-- WORKING ON Quantity

SELECT Quantity FROM customer_churn;

SELECT Quantity FROM customer_churn
WHERE Quantity IS NULL
OR Quantity = ''
OR Quantity NOT REGEXP '^[-]?[0-9]+(\.[0-9]+)?$';

ALTER TABLE customer_churn
MODIFY COLUMN Quantity INT;

-- WORKING ON UnitPrice

SELECT UnitPrice FROM customer_churn;

SELECT UnitPrice FROM customer_churn
WHERE UnitPrice IS NULL
OR UnitPrice = ''
OR UnitPrice NOT REGEXP '^[-]?[0-9]+(\.[0-9]+)?$';

ALTER TABLE customer_churn
MODIFY COLUMN UnitPrice FLOAT;

-- WORKING ON CustomerID

SELECT CustomerID FROM customer_churn;

SELECT DISTINCT CustomerID FROM customer_churn
WHERE CustomerID IS NULL
OR CustomerID = ''
OR CustomerID NOT REGEXP '^[-]?[0-9]+(\.[0-9]+)?$';

UPDATE customer_churn
SET CustomerID = NULLIF(CustomerID,'');

-- STANDARDIZING THE DATE COLUMN (InvoiceDate)

SELECT DISTINCT InvoiceDate FROM customer_churn
WHERE InvoiceDate IS NULL
OR InvoiceDate = ''
OR InvoiceDate NOT REGEXP '^[-]?[0-9]+(\.[0-9]+)?$';


SELECT InvoiceDate, LENGTH(InvoiceDate) AS Length
FROM customer_churn
GROUP BY InvoiceDate
ORDER BY Length DESC;


ALTER TABLE customer_churn
MODIFY COLUMN InvoiceDate varchar(40);


SELECT InvoiceDate FROM customer_churn;

  -- CLEANING THE DATE COLUMN 
SELECT InvoiceDate,
      str_to_date(InvoiceDate, '%m/%d/%Y %H:%i:%s')
FROM customer_churn;

UPDATE customer_churn 
SET InvoiceDate = str_to_date(InvoiceDate, '%m/%d/%Y %H:%i:%s');

DESCRIBE customer_churn;

ALTER TABLE customer_churn
MODIFY COLUMN InvoiceDate DATETIME;

SELECT * FROM customer_churn;

-- WORKING ON ALL DUPLICATES

SELECT 
    InvoiceNo, StockCode, CustomerID, InvoiceDate, Quantity,
    COUNT(*) AS DuplicateCount
FROM customer_churn
GROUP BY 
    InvoiceNo, StockCode, CustomerID, InvoiceDate, Quantity
HAVING COUNT(*) > 1
ORDER BY DuplicateCount DESC;


CREATE INDEX idx_dup_check 
ON customer_churn (InvoiceNo, StockCode,InvoiceDate, Quantity,CustomerID(100));


-- SINCE I DON HAVW A UNIQUE COLUMN I CREATED  A ROWID

ALTER TABLE customer_churn
ADD COLUMN RowID INT AUTO_INCREMENT PRIMARY KEY FIRST;

SELECT * FROM customer_churn;

WITH CTE AS ( 
SELECT InvoiceNo,StockCode,CustomerID,InvoiceDate,Quantity, 
ROW_NUMBER() OVER(PARTITION BY InvoiceNo,StockCode,CustomerID,
InvoiceDate,Quantity ORDER BY InvoiceDate
) AS RN
FROM customer_churn 
) 
DELETE FROM customer_churn
WHERE InvoiceNo IN 
( 
SELECT InvoiceNo FROM CTE WHERE RN > 1 
);


  -- HOURS OF THE DAY -- DATE COLUMN ANALYSIS
SELECT InvoiceDate,
 CASE
     WHEN HOUR(str_to_date(InvoiceDate, '%Y-%m-%d %H:%i:%s')) BETWEEN 5 AND 11 THEN 'Morning'
     WHEN HOUR(str_to_date(InvoiceDate, '%Y-%m-%d %H:%i:%s')) BETWEEN 12 AND 17 THEN 'Afternoon'
     WHEN HOUR(str_to_date(InvoiceDate, '%Y-%m-%d %H:%i:%s')) BETWEEN 18 AND 21 THEN 'Evening'
     ELSE 'Night'
END AS TimeOfDay
FROM customer_churn;

ALTER TABLE customer_churn
ADD COLUMN TimeOfDay VARCHAR(20);

UPDATE customer_churn
SET TimeOfDay =  CASE
     WHEN HOUR(str_to_date(InvoiceDate, '%Y-%m-%d %H:%i:%s')) BETWEEN 5 AND 11 THEN 'Morning'
     WHEN HOUR(str_to_date(InvoiceDate, '%Y-%m-%d %H:%i:%s')) BETWEEN 12 AND 17 THEN 'Afternoon'
     WHEN HOUR(str_to_date(InvoiceDate, '%Y-%m-%d %H:%i:%s')) BETWEEN 18 AND 21 THEN 'Evening'
     ELSE 'Night'
END;


SELECT DISTINCT TimeOfDay FROM customer_churn;

SHOW PROCESSLIST; 
KILL 12;

-- MONTH OF THE DATE

SELECT InvoiceDate,
MONTHNAME(str_to_date(InvoiceDate, '%Y-%m-%d %H:%i:%s'))
FROM customer_churn;

ALTER TABLE customer_churn
ADD COLUMN MONTH VARCHAR(30);

UPDATE customer_churn
SET MONTH = MONTHNAME(str_to_date(InvoiceDate, '%Y-%m-%d %H:%i:%s'));

SELECT DISTINCT MONTH FROM customer_churn;

-- QUARTER OF THE DATE

SELECT InvoiceDate,
QUARTER(str_to_date(InvoiceDate, '%Y-%m-%d %H:%i:%s'))
FROM customer_churn;

ALTER TABLE customer_churn
ADD COLUMN MONTHQUARTER TINYINT;

UPDATE customer_churn
SET MONTHQUARTER = QUARTER(str_to_date(InvoiceDate, '%Y-%m-%d %H:%i:%s'));

SELECT InvoiceDate,
YEAR(str_to_date(InvoiceDate, '%Y-%m-%d %H:%i:%s'))
FROM customer_churn;

ALTER TABLE customer_churn
ADD COLUMN YEAR DATE;

UPDATE customer_churn
SET YEAR = YEAR(str_to_date(InvoiceDate, '%Y-%m-%d %H:%i:%s'));

ALTER TABLE customer_churn
MODIFY COLUMN YEAR VARCHAR(10);

SELECT YEAR FROM customer_churn;

ALTER TABLE customer_churn
MODIFY COLUMN YEAR DATETIME;

SELECT DISTINCT MONTHQUARTER FROM customer_churn ORDER BY MONTHQUARTER;

SELECT 
    CASE QUARTER(InvoiceDate)
        WHEN 1 THEN 'Q1 (Jan - Mar)'
        WHEN 2 THEN 'Q2 (Apr - Jun)'
        WHEN 3 THEN 'Q3 (Jul - Sep)'
        WHEN 4 THEN 'Q4 (Oct - Dec)'
    END AS Quarter_Name
FROM customer_churn;

ALTER TABLE customer_churn
ADD COLUMN Quarter_Name VARCHAR(20);

SELECT Quarter_Name FROM customer_churn;

UPDATE customer_churn
SET Quarter_Name = CASE QUARTER(InvoiceDate)
        WHEN 1 THEN 'Q1 (Jan - Mar)'
        WHEN 2 THEN 'Q2 (Apr - Jun)'
        WHEN 3 THEN 'Q3 (Jul - Sep)'
        WHEN 4 THEN 'Q4 (Oct - Dec)'
    END
;
-- STANDARDIZING THE TEXT COLUMN (CountrY)


SELECT * FROM customer_churn;

SELECT distinct Description FROM customer_churn;

SELECT DISTINCT Country FROM customer_churn;

SELECT DISTINCT Country FROM customer_churn
WHERE Country IS NULL
OR Country = ''
OR Country NOT REGEXP '^[-]?[0-9]+(\.[0-9]+)?$';

UPDATE customer_churn
SET Country = TRIM(REPLACE(Country, '\r', ''));



-- ------------------------- EDA EXPOSITORY DATA ANALYSIS-------------------------------------------------

SELECT InvoiceNo,Quantity,UnitPrice,
ROUND((Quantity * UnitPrice),2)  AS Total_sales
FROM customer_churn;

ALTER TABLE customer_churn
ADD COLUMN Total_sales FLOAT;


SELECT QUANTITY
FROM customer_churn
WHERE Quantity = 0;

UPDATE customer_churn
SET Quantity = 0 
WHERE Quantity < 0;

UPDATE customer_churn
SET Total_sales = (Quantity * UnitPrice);

SELECT * FROM customer_churn;

SELECT
SUM(Total_sales) FROM customer_churn;

SELECT * FROM customer_churn;

-- QUESTION 1

-- revenue BY each month FOR 2011 ONLY

 SELECT MONTH, QUANTITY,UNITPRICE,TOTAL_SALES
 FROM customer_churn
 WHERE YEAR = 2011
 AND Country <> 'United Kingdom';

SELECT 
    MONTH,
    ROUND(SUM(TOTAL_SALES),2) AS revenue
FROM customer_churn
WHERE YEAR = 2011
AND Country <> 'United Kingdom'
GROUP BY MONTH
ORDER BY revenue DESC;

-- SALES BY SEASONAL TRENDS

SELECT 
Quarter_Name,
ROUND(SUM(TOTAL_SALES),2) AS Revenue
FROM customer_churn
WHERE YEAR = 2011
AND Country <> 'United Kingdom'
GROUP BY Quarter_Name
ORDER BY Quarter_Name;


SELECT 
TimeOfDay,
ROUND(SUM(TOTAL_SALES),2) AS Revenue
FROM customer_churn
WHERE YEAR = 2011
AND Country <> 'United Kingdom'
GROUP BY TimeOfDay
ORDER BY TimeOfDay;

-- ------------- TO USE THIS TO FORCAST NEXT YEAR WE SHOULD CHECK A YEAR BEFORE NOW 
SELECT 
TimeOfDay,
ROUND(SUM(TOTAL_SALES),2) AS Revenue
FROM customer_churn
WHERE YEAR = 2010
AND Country <> 'United Kingdom'
GROUP BY TimeOfDay
ORDER BY TimeOfDay;

-- QUESTION 2

-- TOP 10 COUNTRY WITH HIGHEST REVENUE INCLUDING THE QUANTITY SOLD

SELECT Country,
ROUND(SUM(TOTAL_SALES),2) AS Revenue
FROM customer_churn
WHERE YEAR = 2011 
AND Country <> 'United Kingdom'
GROUP BY Country
ORDER BY Revenue desc
LIMIT 10;

SELECT Country,
SUM(Quantity) AS Total_Quantity,
ROUND(SUM(TOTAL_SALES),2) AS Revenue
FROM customer_churn
WHERE YEAR = 2011 
AND Country <> 'United Kingdom'
GROUP BY Country
ORDER BY Revenue desc
LIMIT 10;

SELECT 
Country,
ROUND(SUM(TOTAL_SALES), 2) AS Revenue,
ROUND(SUM(SUM(TOTAL_SALES)) OVER(), 2) AS Full_Total
FROM customer_churn
WHERE YEAR = 2011 
  AND Country <> 'United Kingdom'
GROUP BY Country
ORDER BY Revenue DESC
LIMIT 10;




SELECT Country,
SUM(Quantity) AS Total_Quantity,
ROUND(AVG(UnitPrice), 2) AS Avg_UnitPrice,
ROUND(SUM(TOTAL_SALES),2) AS Revenue
FROM customer_churn
WHERE YEAR = 2011
AND Country <> 'United Kingdom'
GROUP BY Country
ORDER BY Revenue desc
LIMIT 10;

-- QUESTION 3

-- Top 10 Customers by Revenue

SELECT CustomerID,
ROUND(SUM(Total_sales), 2) AS Revenue
FROM customer_churn
WHERE CustomerID IS NOT NULL
AND YEAR = 2011 
AND Country <> 'United Kingdom'
GROUP BY CustomerID
ORDER BY Revenue DESC
LIMIT 10;


SELECT CustomerID,
ROUND(SUM(Total_sales), 2) AS Revenue,
RANK() OVER(ORDER BY SUM(Total_sales) DESC) AS CUSTOMER_RANK
FROM customer_churn
WHERE CustomerID IS NOT NULL
AND YEAR = 2011 
AND Country <> 'United Kingdom'
GROUP BY CustomerID
ORDER BY Revenue DESC
LIMIT 10;

-- QUESTION 4

SELECT Country,
SUM(Quantity) AS Total_Demand,
ROUND(SUM(Total_sales), 2) AS Revenue,
RANK() OVER(ORDER BY SUM(Quantity) DESC) AS DEMAND_RANK
FROM customer_churn
WHERE Country IS NOT NULL
AND YEAR = 2011 
AND Country <> 'United Kingdom' 
GROUP BY Country
ORDER BY Total_Demand DESC
LIMIT 10;

SELECT CUSTOMERID,QUANTITY,UNITPRICE,Total_sales,INVOICEDATE,COUNTRY,MONTH, MONTHQUARTER,
TimeOfDay,YEAR,Quarter_Name
FROM customer_churn;

SELECT DISTINCT YEAR FROM customer_churn;
