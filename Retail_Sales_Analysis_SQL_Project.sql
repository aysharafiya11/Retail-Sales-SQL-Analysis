-- Retail Sales Analysis Using MySQL
CREATE DATABASE SQL_Project;

DROP TABLE IF EXISTS retail_sales_table;
CREATE TABLE retail_sales_table
(
	transactions_id	INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,	
    customer_id	INT,
    gender VARCHAR(20),
    age	INT,
    category VARCHAR(20),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

SELECT * FROM retail_sales_table;

-- Data Cleaning 

-- Check for any null values in the dataset and delete records with missing data.
SELECT * FROM retail_sales_table
WHERE 
    sale_date IS NULL 
    OR 
    sale_time IS NULL 
    OR 
    customer_id IS NULL 
    OR 
    gender IS NULL 
    OR 
    age IS NULL 
    OR 
    category IS NULL 
    OR 
    quantity IS NULL 
    OR 
    price_per_unit IS NULL 
    OR 
    cogs IS NULL
    OR 
    total_sale IS NULL;

-- Data Exploration

-- Determine the total number of records in the dataset.
SELECT COUNT(*) FROM retail_sales_table;

-- Find out how many unique customers are in the dataset.
SELECT COUNT(DISTINCT customer_id) FROM retail_sales_table;

-- Identify all unique product categories in the dataset.
SELECT DISTINCT category FROM retail_sales_table;

-- Data Analysis & Findings

-- Write a SQL query to retrieve all columns for sales made on '2022-11-01:
 SELECT *
 FROM retail_sales_table
 WHERE sale_date = '2022-11-01';

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' 
-- and the quantity sold is greater than or equal to 4 in the month of Nov-2022:
SELECT *
FROM retail_sales_table
WHERE 
category = 'Clothing' 
AND 
quantity >= 4 
AND 
MONTH(sale_date) = 11 
AND 
YEAR(sale_date) = 2022;
 
 -- OR 
 
SELECT *
FROM retail_sales_table
WHERE 
category = 'Clothing'
  AND 
  quantity >= 4
  AND 
  sale_date >= '2022-11-01'
  AND 
  sale_date < '2022-12-01';

-- Write a SQL query to calculate the total sales (total_sale) for each category:
SELECT 
	category, 
    SUM(total_sale) AS Total_Sales, 
    COUNT(*) AS Total_Orders
FROM retail_sales_table
GROUP BY category;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category:
SELECT 
	ROUND(AVG(age),2) AS Average_Age
FROM retail_sales_table
WHERE category = 'Beauty';

-- Write a SQL query to find all transactions where the total_sale is greater than 1000:
SELECT *
FROM retail_sales_table
WHERE total_sale > 1000;

-- Write a SQL query to find the total number of 
-- transactions (transaction_id) made by each gender in each category:

SELECT 
    category,
    gender,
    COUNT(*) AS Total_Transactions
FROM retail_sales_table
GROUP BY 
    category,
    gender
ORDER BY 
	category,
    gender;
    
-- Write a SQL query to calculate the average sale for each month. 
-- Find out best selling month in each year:
SELECT
    sale_year,
    sale_month,
    ROUND(avg_sale, 2) AS average_sale
FROM
(
    SELECT
        YEAR(sale_date) AS sale_year,
        MONTH(sale_date) AS sale_month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER 
        (
			PARTITION BY YEAR(sale_date) 
			ORDER BY AVG(total_sale) DESC
		) AS ranking
    FROM retail_sales_table
    GROUP BY
        YEAR(sale_date),
        MONTH(sale_date)
) AS ranked_sales
WHERE ranking = 1;

-- Write a SQL query to find the top 5 customers based on the highest total sales:
SELECT 
	customer_id, 
    SUM(total_sale) AS Total_Sales
FROM retail_sales_table
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category:
SELECT 
	category, 
    COUNT(DISTINCT customer_id) AS No_of_Unique_Customers
FROM retail_sales_table
GROUP BY category;

-- Write a SQL query to create each shift and number of orders 
-- (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
SELECT
    CASE
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS total_orders
FROM retail_sales_table
GROUP BY shift
ORDER BY total_orders DESC;

-- Write a SQL Query to find which category generated the highest total revenue:
SELECT 
	category, 
    SUM(total_sale) AS Total_Revenue, 
    COUNT(*) AS Total_Orders
FROM retail_sales_table
GROUP BY category
ORDER BY SUM(total_sale) DESC
LIMIT 1;

-- Write a SQL Query to find who are the Top 10 customers by spending:
SELECT
    customer_id,
    SUM(total_sale) AS total_spent
FROM retail_sales_table
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;

-- Write a SQL Query to find which day recorded the highest sales:
SELECT
    sale_date,
    SUM(total_sale) AS total_sales
FROM retail_sales_table
GROUP BY sale_date
ORDER BY total_sales DESC
LIMIT 1;

-- Write a SQL Query to find the sales generated for each weekday:
SELECT
    DAYNAME(sale_date) AS Weekday,
    SUM(total_sale) AS total_sales
FROM retail_sales_table
GROUP BY DAYNAME(sale_date)
ORDER BY total_sales DESC;

-- Write a SQL Query to find the revenue generated for every hour of the day:
SELECT
    HOUR(sale_time) AS sale_hour,
    SUM(total_sale) AS total_revenue
FROM retail_sales_table
GROUP BY HOUR(sale_time)
ORDER BY total_revenue DESC;

-- Write a SQL Query to find the average customer age by category:
SELECT
    category,
    ROUND(AVG(age),2) AS Average_Customer_Age
FROM retail_sales_table
GROUP BY category
ORDER BY Average_Customer_Age;

-- Write a SQL Query to find the spendings of each gender:
SELECT
    gender,
    SUM(total_sale) AS Total_Spends
FROM retail_sales_table
GROUP BY gender
ORDER BY Total_Spends DESC
LIMIT 1;

-- Write a SQL Query to find the highest-selling product category each month
SELECT
    sale_year,
    sale_month,
    category,
    total_sales
FROM
(
    SELECT
        YEAR(sale_date) AS sale_year,
        MONTH(sale_date) AS sale_month,
        category,
        SUM(total_sale) AS total_sales,
        RANK() OVER 
        (
			PARTITION BY YEAR(sale_date), MONTH(sale_date)
			ORDER BY SUM(total_sale) DESC
		) AS ranking
    FROM retail_sales_table
    GROUP BY
        YEAR(sale_date),
        MONTH(sale_date), 
        category
) AS ranked_sales
WHERE ranking = 1
ORDER BY 
	sale_year,
    sale_month;

-- Write a SQL Query to find different age groups and their revenue:
SELECT
		CASE 
			WHEN age < 20 THEN 'Below 20'
			WHEN age BETWEEN 20 AND 29 THEN '20-29'
			WHEN age BETWEEN 30 AND 39 THEN '30-39'
			WHEN age BETWEEN 40 AND 49 THEN '40-49'
			ELSE '50+'
		END AS age_group,
    SUM(total_sale) AS total_revenue
    FROM retail_sales_table
    GROUP BY age_group
    ORDER BY total_revenue DESC;
        
-- Write a SQL Query to find the top 5 busiest shopping hours:
SELECT
    HOUR(sale_time) AS sale_hour,
    COUNT(*) AS total_orders
FROM retail_sales_table
GROUP BY HOUR(sale_time)
ORDER BY total_orders DESC
LIMIT 5;

-- Write a SQL Query to find the monthly revenue trend:
SELECT
    YEAR(sale_date) AS sale_year,
    MONTHNAME(sale_date) AS sale_month,
    SUM(total_sale) AS total_revenue
FROM retail_sales_table
GROUP BY
    YEAR(sale_date),
    MONTH(sale_date),
	MONTHNAME(sale_date)
ORDER BY
    YEAR(sale_date),
    MONTH(sale_date);
    
-- Write a SQL Query to find average quantity purchased for each category:
SELECT
	category,
    ROUND(AVG(quantity),2) AS average_quantity_purchased
FROM retail_sales_table
GROUP BY category
ORDER BY average_quantity_purchased DESC;

-- Write a SQL Query to find the repeat customers(customers with multiple purchases):
SELECT
    customer_id,
    COUNT(*) AS total_orders
FROM retail_sales_table
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY total_orders DESC;

-- Write a SQL Query to find the revenue contribution (%) by category:
SELECT 
	category,
    ROUND
		(
			SUM(total_sale) * 100 / (SELECT SUM(total_sale) FROM retail_sales_table), 2
		) AS revenue_percentage
FROM retail_sales_table
GROUP BY category
ORDER BY revenue_percentage DESC;

-- Write a SQL Query to find the top 3 customers in each category using DENSE_RANK():
SELECT
    customer_id,
    category,
    total_sales,
    ranking
FROM
(
    SELECT
        customer_id,
        category,
        SUM(total_sale) AS total_sales,
        DENSE_RANK() OVER (
            PARTITION BY category
            ORDER BY SUM(total_sale) DESC
        ) AS ranking
    FROM retail_sales_table
    GROUP BY
        customer_id,
        category
) AS ranked_customers
WHERE ranking <= 3
ORDER BY
    category,
    ranking,
    total_sales DESC;

-- Write a SQL Query to calculate the running total of daily sales using SUM() OVER():
WITH daily_sales AS
(
    SELECT
        sale_date,
        SUM(total_sale) AS total_daily_sales
    FROM retail_sales_table
    GROUP BY sale_date
)

SELECT
    sale_date,
    total_daily_sales,
    SUM(total_daily_sales) OVER (
        ORDER BY sale_date
    ) AS running_total
FROM daily_sales;

-- Write a SQL Query to compute the 7-Day Moving Average:
WITH daily_sales AS
(
    SELECT
        sale_date,
        SUM(total_sale) AS daily_sales
    FROM retail_sales_table
    GROUP BY sale_date
)

SELECT
    sale_date,
    daily_sales,
    ROUND
    (
            AVG(daily_sales) OVER
            ( 
				ORDER BY sale_date
				ROWS BETWEEN 6 PRECEDING AND CURRENT ROW 
			), 2
	) AS moving_avg_7_days
FROM daily_sales;

-- Write a SQL Query to identify Days Where Sales Exceeded the Monthly Average:
WITH daily_sales AS
(
    SELECT
        sale_date,
        SUM(total_sale) AS daily_sales
    FROM retail_sales_table
    GROUP BY sale_date
)

SELECT *
FROM
(
    SELECT
        sale_date,
        daily_sales,
        AVG(daily_sales) OVER(
            PARTITION BY YEAR(sale_date), MONTH(sale_date)
        ) AS monthly_avg
    FROM daily_sales
) t
WHERE daily_sales > monthly_avg;

-- Write a SQL Query to find Customers Spending Above the Overall Average Customer Spending:
WITH customer_sales AS
(
    SELECT
        customer_id,
        SUM(total_sale) AS total_spent
    FROM retail_sales_table
    GROUP BY customer_id
)
    
SELECT *
FROM customer_sales
WHERE total_spent >
(
    SELECT AVG(total_spent)
    FROM customer_sales
)
ORDER BY total_spent DESC;

-- Write a SQL Query to rank Categories by Revenue Within Each Gender:
SELECT
    gender,
    category,
    total_revenue,
    DENSE_RANK() OVER (
        PARTITION BY gender
        ORDER BY total_revenue DESC
    ) AS ranking
FROM
(
    SELECT
        gender,
        category,
        SUM(total_sale) AS total_revenue
    FROM retail_sales_table
    GROUP BY
        gender,
        category
) AS category_revenue;

-- Write a SQL Query to calculate Month-over-Month (MoM) Sales Growth:
WITH monthly_sales AS
(
    SELECT
        YEAR(sale_date) AS sale_year,
        MONTH(sale_date) AS sale_month,
        SUM(total_sale) AS total_sales
    FROM retail_sales_table
    GROUP BY
        YEAR(sale_date),
        MONTH(sale_date)
),
monthly_growth AS
(
    SELECT
        sale_year,
        sale_month,
        total_sales,
        LAG(total_sales) OVER(
            ORDER BY sale_year, sale_month
        ) AS previous_month_sales
    FROM monthly_sales
)

SELECT
    sale_year,
    sale_month,
    total_sales,
    previous_month_sales,
    ROUND(
        (total_sales - previous_month_sales) / previous_month_sales * 100, 2) 
        AS mom_growth_percent
FROM monthly_growth;

-- Write a SQL Query to find the Median Transaction Value:
WITH ordered_sales AS
(
    SELECT
        total_sale,
        ROW_NUMBER() OVER(ORDER BY total_sale) AS rn,
        COUNT(*) OVER() AS total_rows
    FROM retail_sales_table
)

SELECT
    ROUND(AVG(total_sale),2) AS median_transaction
FROM ordered_sales
WHERE rn IN
(
    FLOOR((total_rows + 1) / 2),
    FLOOR((total_rows + 2) / 2)
);