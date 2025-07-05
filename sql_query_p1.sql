-- SQL Retail Sales Analysis

-- Create Table
DROP TABLE IF EXISTS retails_sales_tb;
CREATE TABLE retails_sales_tb
(
		transactions_id	INT PRIMARY KEY,
		sale_date DATE,	
		sale_time TIME,	
		customer_id	INT,
		gender VARCHAR(15),	
		age INT,
		category VARCHAR(15),
		quantity INT,
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sale Float
); 

SELECT * FROM retails_sales_tb
LIMIT 10;

SELECT COUNT(*) FROM retails_sales_tb;
-- DATA CLEANING
SELECT * FROM retails_sales_tb
WHERE transactions_id IS NULL
OR
 sale_date IS NULL
OR
 sale_time IS NULL
OR
 customer_id IS NULL
OR
 gender IS NULL
OR
 category IS NULL
OR
 price_per_unit IS NULL
OR
 cogs IS NULL
OR
 total_sale IS NULL;

DELETE FROM retails_sales_tb
WHERE transactions_id IS NULL
OR
 sale_date IS NULL
OR
 sale_time IS NULL
OR
 customer_id IS NULL
OR
 gender IS NULL
OR
 category IS NULL
OR
 price_per_unit IS NULL
OR
 cogs IS NULL
OR
 total_sale IS NULL;
 -- DATA EXPLORATION
 
 -- HOW MANY SALES WE HAVE?
SELECT COUNT(*) AS total_sale FROM retails_sales_tb;

-- HOW MANY UNIUQUE CUSTOMERS DO WE HAVE?
SELECT COUNT(DISTINCT customer_id) FROM retails_sales_tb;

SELECT DISTINCT category FROM retails_sales_tb;


-- Data Analysis & Business Key Problems & Answers

--My Analysis & Findings

-- Q1. Write a SQL query to retrive all columns for sales amde on '2022-11-05'

SELECT * FROM retails_sales_tb
WHERE sale_date = '2022-11-05';

--Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
--and the quantity sold is equal or more than 4 in the month of Nov-2022 

SELECT *
FROM retails_sales_tb 
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date,'mm-yyyy') = '11-2022'
  AND quantity >= 4

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category, SUM(total_sale) AS net_sale,
COUNT(*) AS total_orders
FROM retails_sales_tb
GROUP BY category
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT category, ROUND(AVG(age),2) AS avg_age
FROM retails_sales_tb
WHERE category = 'Beauty'
GROUP BY 1

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retails_sales_tb
WHERE total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
	category,
	gender,
	COUNT(*) AS total_trans
FROM retails_sales_tb
GROUP BY 
	gender,
	category
ORDER BY 1
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
	Year,
	Month_num,
	avg_sale_per_month,
	rank
FROM
(
SELECT 
	EXTRACT(YEAR FROM sale_date) AS Year,
	EXTRACT(MONTH FROM sale_date) AS Month_num,
	ROUND(AVG(total_sale):: numeric, 2) AS avg_sale_per_month,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)  ORDER BY ROUND(AVG(total_sale):: numeric, 2) DESC) AS rank
FROM retails_sales_tb
GROUP BY 
	1,2
) AS t1
WHERE rank = 1


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
SELECT  customer_id, SUM(total_sale)
FROM retails_sales_tb
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT COUNT(*)
FROM
(
SELECT DISTINCT customer_id,
STRING_AGG(DISTINCT category, ', ')
FROM retails_sales_tb
WHERE category IN ('Beauty', 'Clothing', 'Electronics')
GROUP BY 1
HAVING COUNT(DISTINCT category) = 3
ORDER BY 1
) AS sub

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)|
--op1
-- SELECT
-- COUNT(CASE WHEN EXTRACT(HOUR FROM sale_time) <= 12 THEN transactions_id END) AS Morning_Shift,
-- COUNT(CASE WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN transactions_id END) AS Afternoon_Shift,
-- COUNT(CASE WHEN EXTRACT(HOUR FROM sale_time) > 17 THEN transactions_id END) AS Evening_Shift
-- FROM retails_sales_tb
--op2
WITH hour_shift AS
(
SELECT *,
	CASE 
	WHEN EXTRACT(HOUR FROM sale_time) <= 12 THEN 'Morning_Shift'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon_Shift'
	ELSE 'Evening_Shift'
 END AS shift
FROM retails_sales_tb
)
SELECT 
shift,
COUNT(*) AS total_order
FROM hour_shift
GROUP BY shift

-- END OF PROJECT