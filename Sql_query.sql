CREATE DATABASE sql_project_p2;

-- Create table 
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales_tb (
			    transactions_id	INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(15),
				age	INT,
				category VARCHAR(15),	
				quantiy	INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
            );

SELECT * FROM retail_sales_tb
LIMIT 10;

SELECT COUNT(*) FROM retail_sales_tb;

-- Data Cleaning
SELECT * FROM retail_sales_tb
WHERE transactions_id IS NULL

SELECT * FROM retail_sales_tb
WHERE sale_date IS NULL

SELECT * FROM retail_sales_tb
WHERE 
sale_date IS NULL
 OR transactions_id IS NULL
 OR sale_time IS NULL
 OR gender IS NULL
 OR category IS NULL
 OR quantiy IS NULL
 OR total_sale IS NULL

DELETE FROM  retail_sales_tb
  WHERE 
sale_date IS NULL
 OR transactions_id IS NULL
 OR sale_time IS NULL
 OR gender IS NULL
 OR category IS NULL
 OR quantiy IS NULL
 OR total_sale IS NULL

-- Data Exploration
-- How many sales we have 
SELECT COUNT(*)AS total_sale FROM retail_sales_tb

-- How many unique customers we have 

SELECT COUNT(DISTINCT customer_id) AS total_customer FROM retail_sales_tb
SELECT DISTINCT (category) FROM retail_sales_tb

-- BUSINESS KEY PROBLEMS & data analysis

-- 1. Write a query to retrieve all column for sales made on 11-05-2022 ?
SELECT * FROM retail_sales_tb
WHERE sale_date >= '2022-11-01' AND sale_date <= '2022-11-30';
 
--2. Write query to retrieve all transactions where the category is 'clothing' and the quantity sold is more than 2 in the
--     month of nov-2022

SELECT * FROM retail_sales_tb 
WHERE category = 'Clothing' AND quantiy = 2 AND sale_date >= '2022-11-01' AND sale_date <= '2022-11-30';

--3. Write a query to calculate the total sales for each category ?
SELECT SUM(total_sale) AS net,category FROM retail_sales_tb
GROUP BY category

--4. Write a query to find the average age of customers who purchased items from the 'Beauty'category ?
SELECT ROUND (AVG(age),2),category FROM retail_sales_tb
WHERE category = 'Beauty'
GROUP BY category;

--5.Write a query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales_tb
WHERE total_sale > 1000;

--6. Write a query to find the total number of transactions made by each gender in each category.
SELECT category, gender, COUNT(*)AS total_no FROM retail_sales_tb
GROUP BY category, gender

--7. Calculate the average sale for each month. Find out best selling month in each year
SELECT
      year,
	  month,
	  avg_sale
FROM
(SELECT
EXTRACT (YEAR FROM sale_date)AS year,
EXTRACT (MONTH FROM sale_date) AS month,
AVG(total_sale) as avg_sale,
RANK()OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)ORDER BY AVG(total_sale)DESC) AS Rank
FROM retail_sales_tb 
GROUP BY 1,2
)as t1
WHERE rank = 1

ORDER BY 1,3 DESC;

--8. Find the top 5 customers based on the highest total sales.

SELECT SUM(total_sale)AS total_sale,customer_id FROM retail_sales_tb
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5

--9.Find the number of unique customers who purchased items from each category.
SELECT COUNT(DISTINCT customer_id), category
FROM retail_sales_tb
GROUP BY category;

--10.Write query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening > 17)

WITH hourly_sale
AS
(
SELECT *,
      CASE 
	      WHEN EXTRACT(HOUR FROM sale_time)< 12 THEN 'Morning'
		  WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		  ELSE 'Evening'
	  END as shift	  
FROM retail_sales_tb
)
SELECT shift, COUNT(*) AS total_orders FROM hourly_sale
GROUP BY shift

-- End of Project




























