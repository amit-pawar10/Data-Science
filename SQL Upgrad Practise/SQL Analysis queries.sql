SET SQL_SAFE_UPDATES = 0;


-- Module: Database Design and Introduction to SQL
-- Session: Database Creation in MySQL Workbench
-- DDL Statements

-- 1. Create a table shipping_mode_dimen having columns with their respective data types as the following:
--    (i) Ship_Mode VARCHAR(25)
--    (ii) Vehicle_Company VARCHAR(25)
--    (iii) Toll_Required BOOLEAN

-- 2. Make 'Ship_Mode' as the primary key in the above table.


-- -----------------------------------------------------------------------------------------------------------------
-- DML Statements

-- 1. Insert two rows in the table created above having the row-wise values:
--    (i)'DELIVERY TRUCK', 'Ashok Leyland', false
--    (ii)'REGULAR AIR', 'Air India', false

-- 2. The above entry has an error as land vehicles do require tolls to be paid. Update the ‘Toll_Required’ attribute
-- to ‘Yes’.

-- 3. Delete the entry for Air India.


-- -----------------------------------------------------------------------------------------------------------------
-- Adding and Deleting Columns

-- 1. Add another column named 'Vehicle_Number' and its data type to the created table. 

-- 2. Update its value to 'MH-05-R1234'.

-- 3. Delete the created column.


-- -----------------------------------------------------------------------------------------------------------------
-- Changing Column Names and Data Types

-- 1. Change the column name ‘Toll_Required’ to ‘Toll_Amount’. Also, change its data type to integer.

-- 2. The company decides that this additional table won’t be useful for data analysis. Remove it from the database.


-- -----------------------------------------------------------------------------------------------------------------
-- Session: Querying in SQL
-- Basic SQL Queries

-- 1. Print the entire data of all the customers.
SELECT * FROM cust_dimen;
-- 2. List the names of all the customers.
SELECT Customer_Name FROM cust_dimen;
-- 3. Print the name of all customers along with their city and state.
SELECT Customer_Name , City, State
FROM cust_dimen;

-- 4. Print the total number of customers.
select count(*) as Total_Customers
from cust_dimen;

-- 5. How many customers are from West Bengal?
SELECT COUNT(*) 
FROM cust_dimen
WHERE State = 'West Bengal';

-- 6. Print the names of all customers who belong to West Bengal.
SELECT Customer_Name
FROM cust_dimen
WHERE State = 'West Bengal';

-- -----------------------------------------------------------------------------------------------------------------
-- Operators

-- 1. Print the names of all customers who are either corporate or belong to Mumbai.
SELECT Customer_Name, City, Customer_Segment
FROm cust_dimen
WHERE City = 'Mumbai' OR Customer_Segment = 'CORPORATE';

-- 2. Print the names of all corporate customers from Mumbai.
SELECT Customer_Name, City, Customer_Segment
FROm cust_dimen
WHERE City = 'Mumbai' AND Customer_Segment = 'CORPORATE';

-- 3. List the details of all the customers from southern India: namely Tamil Nadu, Karnataka, Telangana and Kerala.
SELECT *
FROM cust_dimen
WHERE State IN ('Tamil Nadu', 'Karnataka', 'Telangana' ,'Kerala');

-- 4. Print the details of all non-small-business customers.
SELECT *
FROM cust_dimen
WHERE Customer_Segment != 'Small Business';

-- 5. List the order ids of all those orders which caused losses.
SELECT Ord_id, Profit
FROm market_fact_full
WHERE Profit < 0;

-- 6. List the orders with '_5' in their order ids and shipping costs between 10 and 15.
SELECT Ord_id, Shipping_Cost
FROM market_fact_full
WHERE Ord_id LIKE '%\_5%' AND Shipping_Cost BETWEEN 10 AND 15;

SELECT * FROM market_fact_full;

-- -----------------------------------------------------------------------------------------------------------------
-- Aggregate Functions

-- 1. Find the total number of sales made.
SELECT COUNT(Sales) 
FROM market_fact_full;

-- 2. What are the total numbers of customers from each city?
SELECT COUNT(Customer_Name) AS City_wise_customer, City
FROm cust_dimen
GROUP BY City;

-- 3. Find the number of orders which have been sold at a loss.
SELECT COUNT(Ord_id) AS Loss_Count
FROm market_fact_full
WHERE Profit < 0;

-- 4. Find the total number of customers from Bihar in each segment.
SELECT COUNT(Cust_id) AS Bihar_customer_count, State, Customer_Segment
FROm cust_dimen
WHERE State= 'Bihar'
GROUP BY Customer_Segment;

-- 5. Find the customers who incurred a shipping cost of more than 50.


-- -----------------------------------------------------------------------------------------------------------------
-- Ordering

-- 1. List the customer names in alphabetical order.
SELECT Customer_Name
FROM cust_dimen
ORDER BY Customer_Name;

SELECT  DISTINCT Customer_Name
FROM cust_dimen
ORDER BY Customer_Name;

-- 2. Print the three most ordered products.
SELECT Prod_id, SUM(Order_Quantity)
FROM market_fact_full
GROUP BY Prod_id
ORDER BY SUM(Order_Quantity) DESC
LIMIT 3;

-- 3. Print the three least ordered products.
SELECT Prod_id, SUM(Order_Quantity)
FROM market_fact_full
GROUP BY Prod_id
ORDER BY SUM(Order_Quantity)
LIMIT 3;

-- 4. Find the sales made by the five most profitable products.

-- 5. Arrange the order ids in the order of their recency.

-- 6. Arrange all consumers from Coimbatore in alphabetical order.


-- -----------------------------------------------------------------------------------------------------------------
-- String and date-time functions

-- 1. Print the customer names in proper case.
-- SELECT Customer_Name, CONCAT(UPPER(SUBSTRING(SUBSTRING_INDEX (LOWER(Customer_Name),' ',1),1,1),
-- 	UPPER(SUBSTRING(SUBSTRING_INDEX (LOWER(Customer_Name),' ',-1),1,1))))
--     FROM cust_dimen;

-- 2. Print the product names in the following format: Category_Subcategory.
SELECT Product_Category, Product_Sub_Category, CONCAT(Product_Category, '_', Product_Sub_Category) AS Product_Name
FROM prod_dimen;


-- 3. In which month were the most orders shipped?
SELECT COUNT(Ship_id), month(Ship_Date) AS month_Shipment
FROM shipping_dimen
GROUP BY month_Shipment
ORDER BY COUNT(Ship_id) desc
LIMIT 3;

-- 4. Which month and year combination saw the most number of critical orders?
SELECT COUNT(Ship_id), month(Ship_Date) AS month_Shipment, YEAR(Ship_Date) AS year_Shipment
FROM shipping_dimen
GROUP BY year_Shipment, month_Shipment
ORDER BY COUNT(Ship_id) desc;

-- 5. Find the most commonly used mode of shipment in 2011.


-- -----------------------------------------------------------------------------------------------------------------
-- Regular Expressions

-- 1. Find the names of all customers having the substring 'car'.
SELECT Customer_Name
FROM cust_dimen
WHERE CUstomer_Name REGEXP 'car';

-- 2. Print customer names starting with A, B, C or D and ending with 'er'.
SELECT Customer_Name
FROM cust_dimen
WHERE CUstomer_Name REGEXP '^[abcd].*er$';

-- -----------------------------------------------------------------------------------------------------------------
-- Nested Queries

-- 1. Print the order number of the most valuable order by sales.
SELECT Ord_id, Sales, ROUND(Sales) AS Rounded_Sales
FROM market_fact_full
WHERE Sales = (
	SELECT MAX(Sales)
    FROM market_fact_full
    );

-- 2. Return the product categories and subcategories of all the products which don’t have details about the product
-- base margin.
SELECT * 
FROM prod_dimen
WHERE Prod_id in (
	SELECT Prod_id
	FROm market_fact_full
	WHERE Product_Base_Margin is null);

-- 3. Print the name of the most frequent customer.
SELECT Customer_Name, Cust_id 
FROM cust_dimen
WHERE Cust_id = (
	SELECT Cust_id
	FROM market_fact_full
	GROUP BY Cust_id
	ORDER BY COUNT(Cust_id) DESC
	LIMIT 1 );

-- 4. Print the three most common products.
SELECT Product_Category, Product_Sub_Category
FROm prod_dimen
WHERE Prod_id IN (
	SELECT Prod_id
    FROM market_fact_full
    GROUP BY Prod_id
    ORDER BY COUNT(Prod_id) desc)
    LIMIT 3;
-- -----------------------------------------------------------------------------------------------------------------
-- CTEs

-- 1. Find the 5 products which resulted in the least losses. Which product had the highest product base
-- margin among these?

WITH least_losses AS (
	SELECT Prod_id,Profit, Product_Base_Margin
	FROM market_fact_full
	WHERE Profit <0
	ORDER BY Profit DESC
	LIMIT 5)
    SELECT *
    FROM least_losses
    WHERE Product_Base_Margin = (
		SELECT MAX(Product_Base_Margin)
        FROM least_losses)
    ;


-- 2. Find all low-priority orders made in the month of April. Out of them, how many were made in the first half of
-- the month?

WITH low_priority_orders AS (
	SELECT Ord_id, Order_Date, Order_Priority
	FROM orders_dimen
	WHERE Order_Priority = 'Low' AND month(Order_Date) = 4)
    SELECT COUNt(Ord_id) AS Order_Count
    FROM low_priority_orders
    WHERE day(Order_date) BETWEEN 1 AND 15
    ;
    

-- -----------------------------------------------------------------------------------------------------------------
-- Views

-- 1. Create a view to display the sales amounts, the number of orders, profits made and the shipping costs of all
-- orders. Query it to return all orders which have a profit of greater than 1000.

CREATE VIEW order_info
AS SELECT Ord_id, Sales, Order_Quantity, Profit, Shipping_Cost
FROM market_fact_full;

SELECT Ord_id, Profit
FROM order_info
WHERE Profit > 1000;

-- 2. Which year generated the highest profit?
CReate VIEW market_facts_and_orders
AS SELECT * FROM market_fact_full
	INNER JOIN orders_dimen
    USING (Ord_id);

SELECT SUM(Profit), YEAR(Order_Date) AS years
FROM market_facts_and_orders
GROUP BY years
ORDER BY SUM(Profit) DESC
LIMIT 1;

-- -----------------------------------------------------------------------------------------------------------------
-- Session: Joins and Set Operations
-- Inner Join

-- 1. Print the product categories and subcategories along with the profits made for each order.
SELECT Ord_id, Product_Category, Product_Sub_Category, Profit
FROM prod_dimen AS p 
	INNER JOIN 
market_fact_full AS m
	ON p.Prod_id = m.Prod_id;

-- 2. Find the shipment date, mode and profit made for every single order.
SELECT Ord_id, Ship_Date, Ship_Mode, Profit
	FROM market_fact_full AS m
		INNER JOIN 
	shipping_dimen AS s
		ON m.Ship_id = s.Ship_id;

-- 3. Print the shipment mode, profit made and product category for each product.
SELECT m.Prod_id, s.Ship_Mode, p.Product_Category, m.Profit
FROM market_fact_full AS m
	INNER JOIN
shipping_dimen AS s
	ON m.Ship_id = s.Ship_id
	INNER JOIN
prod_dimen AS p
	ON m.Prod_id = p.Prod_id;

-- 4. Which customer ordered the most number of products?
SELECT c.Customer_Name, SUM(Order_Quantity) AS Total_Orders
FROM cust_dimen AS c
	INNER JOIN
market_fact_full AS m
	ON c.cust_id = m.cust_id
GROuP BY c.Customer_Name
ORDER BY Total_Orders DESC;
    

-- 5. Selling office supplies was more profitable in Delhi as compared to Patna. True or false?
SELECT p.Prod_id,  Product_Category, City, SUM(Profit) AS City_wise_Profit
FROM prod_dimen AS p
INNER JOIN 
market_fact_full AS m
ON p.Prod_id = m.Prod_id
INNER JOIN
cust_dimen AS c
ON m.cust_id = c.cust_id
WHERE Product_Category = 'Office supplies' AND (City = 'Delhi' OR City = 'Patna')
GROUP BY City;

-- 6. Print the name of the customer with the maximum number of orders.
select Customer_Name, COUNT(Customer_Name) as No_Of_Orders
from cust_dimen c
inner join market_fact_full m
on c.cust_id = m.cust_id
group by Customer_Name
order by No_Of_Orders desc
limit 1;

-- 7. Print the three most common products.


-- -----------------------------------------------------------------------------------------------------------------
-- Outer Join

-- 1. Return the order ids which are present in the market facts table.

-- Execute the below queries before solving the next question.
create table manu (
	Manu_Id int primary key,
	Manu_Name varchar(30),
	Manu_City varchar(30)
);

insert into manu values
(1, 'Navneet', 'Ahemdabad'),
(2, 'Wipro', 'Hyderabad'),
(3, 'Furlanco', 'Mumbai');

alter table Prod_Dimen
add column Manu_Id int;

update Prod_Dimen
set Manu_Id = 2
where Product_Category = 'technology';

-- 2. Display the products sold by all the manufacturers using both inner and outer joins.

-- 3. Display the number of products sold by each manufacturer.

-- 4. Create a view to display the customer names, segments, sales, product categories and
-- subcategories of all orders. Use it to print the names and segments of those customers who ordered more than 20
-- pens and art supplies products.


-- -----------------------------------------------------------------------------------------------------------------
-- Union, Union all, Intersect and Minus

-- 1. Combine the order numbers for orders and order ids for all shipments in a single column.

-- 2. Return non-duplicate order numbers from the orders and shipping tables in a single column.

-- 3. Find the shipment details of products with no information on the product base margin.

-- 4. What are the two most and the two least profitable products?
(SELECT Prod_id, SUM(Profit)
FROM market_fact_full
GROUP BY Prod_id
ORDER BY SUM(Profit) DESC
limit 2)
UNION
(SELECT Prod_id, SUM(Profit)
FROM market_fact_full
GROUP BY Prod_id
ORDER BY SUM(Profit) 
limit 2);

-- -----------------------------------------------------------------------------------------------------------------
-- Module: Advanced SQL
-- Session: Window Functions	
-- Window Functions in Detail

-- 1. Rank the orders made by Aaron Smayling in the decreasing order of the resulting sales.

-- 2. For the above customer, rank the orders in the increasing order of the discounts provided. Also display the
-- dense ranks.

-- 3. Rank the customers in the decreasing order of the number of orders placed.
SELECT Customer_Name,
	COUNT(DISTINCT Ord_id),
    RANK() OVER(ORDER BY COUNT(DISTINCT Ord_id) DESC) AS Order_rank,
    DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT Ord_id) DESC) AS Order_dense_rank,
    ROW_NUMBER() OVER(ORDER BY COUNT(DISTINCT Ord_id) DESC) AS Order_row_number
FROM market_fact_full AS m
	INNER JOIN cust_dimen AS c
    ON m.cust_id = c.cust_id
GROUP BY Customer_Name;

-- 4. Create a ranking of the number of orders for each mode of shipment based on the months in which they were
-- shipped. 
WITH shipping_summary AS (
	SELECT Ship_Mode,
			MONTH(Ship_Date) AS shipping_month,
			COUNT(*) AS Shipments
	FROM shipping_dimen
	GROUP BY Ship_Mode,
			shipping_month
            )
            SELECT *,
            RANK() OVER(PARTITION BY Ship_Mode ORDER BY Shipments DESC) AS shipping_rank
            FROM shipping_summary;
            

SELECT * FROM shipping_dimen;
-- -----------------------------------------------------------------------------------------------------------------
-- Named Windows

-- 1. Rank the orders in the increasing order of the shipping costs for all orders placed by Aaron Smayling. Also
-- display the row number for each order.
SELECT Ord_id,
		Shipping_Cost,
        Customer_name,
        RANK() OVER w AS disc_rank,
        ROW_NUMBER() OVER w AS disc_rank
	FROM market_fact_full AS m
		INNER JOIN cust_dimen AS c
        ON m.cust_id = c.cust_id
        WHERE Customer_name = 'Aaron Smayling'
        WINDOW w AS (ORDER BY Shipping_Cost);
        


-- -----------------------------------------------------------------------------------------------------------------
-- Frames

-- 1. Calculate the month-wise moving average shipping costs of all orders shipped in the year 2011.
WITH ship_summary AS
(
	SELECT SUM(shipping_cost) AS monthly_ship_total,
			month(ship_date) AS ship_month
	FROM market_fact_full AS m
	INNER JOIN shipping_dimen AS s
	ON m.Ship_id = s.Ship_id
	WHERE year(ship_date) = 2011
	GROUP by month(ship_date)
)
SELECT *,
		AVG(monthly_ship_total) OVER w AS moving_avg
        FROM ship_summary
        WINDOW w AS (ORDER BY ship_month ROWS 3 PRECEDING);

-- Lead And Lag EXAmple
WITH cust_order AS
(
	SELECT c.Customer_Name,
			m.Ord_id,
			o.Order_Date
	FROM 
	market_fact_full AS m
	LEFT JOIN
	orders_dimen AS o
	ON m.Ord_id = o.Ord_id
	LEFT JOIN
	cust_dimen AS c
	ON m.cust_id = c.cust_id
	WHERE Customer_Name = 'RICK WILSON'
	GROUP BY 
			c.Customer_Name,
			m.Ord_id,
			o.Order_Date
),
next_date_summary AS
(
	SELECT *,
			LEAD(order_date, 1, '2015-01-01') OVER(ORDER BY order_date, ord_id) AS next_order_date
	FROM cust_order
	ORDER BY Customer_Name,
			Order_date,
			Ord_id
)
SELECT *,
		DATEDIFF(next_order_date, order_date) AS days_diff
	FROM next_date_summary;


-- Lag
WITH cust_order AS
(
	SELECT c.Customer_Name,
			m.Ord_id,
			o.Order_Date
	FROM 
	market_fact_full AS m
	LEFT JOIN
	orders_dimen AS o
	ON m.Ord_id = o.Ord_id
	LEFT JOIN
	cust_dimen AS c
	ON m.cust_id = c.cust_id
	WHERE Customer_Name = 'RICK WILSON'
	GROUP BY 
			c.Customer_Name,
			m.Ord_id,
			o.Order_Date
),
previous_date_summary AS
(
	SELECT *,
			LAG(order_date, 1, '2015-01-01') OVER(ORDER BY order_date, ord_id) AS previous_order_date
	FROM cust_order
	ORDER BY Customer_Name,
			Order_date,
			Ord_id
)
SELECT *,
		DATEDIFF(order_date, previous_order_date) AS days_diff
	FROM previous_date_summary;

-- -----------------------------------------------------------------------------------------------------------------
-- Session: Programming Constructs in Stored Functions and Procedures
-- IF Statements

-- 1. Classify an order as 'Profitable' or 'Not Profitable'.


-- -----------------------------------------------------------------------------------------------------------------
-- CASE Statements

-- 1. Classify each market fact in the following ways:
--    Profits less than -500: Huge loss
--    Profits between -500 and 0: Bearable loss 
--    Profits between 0 and 500: Decent profit
--    Profits greater than 500: Great profit
SELECT market_fact_id,
		profit,
        CASE 
			WHEN profit < -500 THEN 'Huge Loss'
            WHEN profit BETWEEN -500 AND 0 THEN 'Bearable Loss'
            WHEN profit BETWEEN 0 AND 500 THEN 'Decent Profit'
            ELSE 'Great Profit'
		END AS Profit_type
FROM market_fact_full;


-- 2. Classify the customers on the following criteria (TODO)
--    Top 20% of customers: Gold
--    Next 35% of customers: Silver
--    Next 45% of customers: Bronze
WITH cust_summary AS
(
	SELECT m.cust_id,
			c.customer_name,
			ROUND(SUM(m.Sales)) AS total_sales,
			PERCENT_RANK() OVER(ORDER BY ROUND(SUM(m.Sales)) DESC) AS perc_rank
	FROM 
		market_fact_full AS m
	LEFT JOIN
		cust_dimen AS c
	ON 
		m.cust_id = c.cust_id
	GROUP BY cust_id
)
SELECT *,
		CASE
			WHEN perc_rank < 0.2 THEN 'Gold'
            WHEN perc_rank < 0.35 THEN 'Silver'
            ELSE 'Bronze'
		END AS customer_category
FROM cust_summary;

-- UDF
/*
DELIMITER $$

CREATE FUNCTION profiTType(profit int)
	RETURNS varchar(30) DETERMINISTIC
    
BEGIN

DECLARE message VARCHAR(30);
IF profit < -500 THEN
	SET message = 'Huge Loss';
ELSEIF profit BETWEEN -500 AND 0 THEN
	SET message = 'Bearable Loss';
ELSEIF profit BETWEEN 0 AND 500 THEN
	SET message = 'Decent Profit';
ELSE 
	SET message = 'Great Profit';

END IF;

RETURN message;

END;
$$
DELIMITER ;


SELECT profitType(1000) AS Function_Output;
*/


-- -----------------------------------------------------------------------------------------------------------------
-- Stored Functions

-- 1. Create and use a stored function to classify each market fact in the following ways:
--    Profits less than -500: Huge loss
--    Profits between -500 and 0: Bearable loss 
--    Profits between 0 and 500: Decent profit
--    Profits greater than 500: Great profit


-- -----------------------------------------------------------------------------------------------------------------
-- Stored Procedures

-- 1. Classify each market fact in the following ways:
--    Profits less than -500: Huge loss
--    Profits between -500 and 0: Bearable loss 
--    Profits between 0 and 500: Decent profit
--    Profits greater than 500: Great profit

-- The market facts with ids '1234', '5678' and '90' belong to which categories of profits?


-- -----------------------------------------------------------------------------------------------------------------
-- Outer Join

-- 1. Return the order ids which are present in the market facts table


-- Execute the below queries before solving the next question.
create table IF NOT EXISTS manu(
    Manu_Id int primary key,
    Manu_name varchar(30),
    Manu_city varchar(30)
);

insert into manu values
(1,'Navneet','Ahemdabad'),
(2,'Wipro','Hyderabad'),
(3,'Furlanco','Mumbai');

alter table Prod_Dimen
add column Manu_Id int;

update Prod_dimen
set Manu_Id = 2
where Product_Category = 'technology';

-- 2. Display the products sold by all the manufacturers using both inner and outer joins


-- 3. Display the number of products sold by each manufacturer




/* Profits per product , subcategory
	Avg profit per order
    Avg profit % per order */
-- -------------------------------------------------------
-- Product level Profit
SELECT p.product_category,
	-- p.product_sub_category,
        SUM(m.profit) AS Profit
FROM market_fact_full AS m
INNER JOIN 
prod_dimen AS p
ON m.prod_id = p.prod_id
INNER JOIN
orders_dimen AS o
ON m.ord_id = o.ord_id
GROUP BY p.product_category
	-- p.product_sub_category
ORDER BY SUM(m.profit);

-- Subcategory level Profit
SELECT p.product_category,
		p.product_sub_category,
        SUM(m.profit) AS Profit
FROM market_fact_full AS m
INNER JOIN 
prod_dimen AS p
ON m.prod_id = p.prod_id
INNER JOIN
orders_dimen AS o
ON m.ord_id = o.ord_id
GROUP BY p.product_category,
		p.product_sub_category
ORDER BY p.product_category, 
		SUM(m.profit);
        
-- order table summary 
-- Checking if there are multiple order_numbers       
SELECT COUNT(*) AS order_table_total,
		COUNT(DISTINCT Ord_id) AS order_id_count, 
		COUNT(DISTINCT Order_number) AS order_no_count
FROM orders_dimen;

-- CHecking data of duplicate order numbers
SELECT *
FROM orders_dimen
WHERE order_number in
(
	SELECT order_number
	FROM orders_dimen
	GROUP BY order_number
	HAVING COUNT(order_number) > 1
);

-- Avg Profit per ord
 SELECT p.product_category,
        SUM(m.profit) AS Profit,
        COUNT(DISTINCT o.order_number) AS Total_orders,
        ROUND(SUM(m.profit)/COUNT(DISTINCT o.order_number),2) AS average_profit_per_order,
		ROUND(SUM(m.Sales)/COUNT(DISTINCT o.order_number),2) AS average_sales_per_order,
        ROUND(SUM(m.profit)/SUM(m.Sales),4)*100 AS Profit_percentage
FROM market_fact_full AS m
	INNER JOIN 
		prod_dimen AS p
		ON m.prod_id = p.prod_id
	INNER JOIN
		orders_dimen AS o
		ON m.ord_id = o.ord_id
GROUP BY p.product_category
ORDER BY p.product_category, 
		SUM(m.profit);
        
-- Profitable customers
-- cust_id | rank | cust_name | profit | cust_city  | cust_state | sales

-- exploring customer table
SELECT cust_id,
		customer_name,
        city AS customer_city,
        state AS customer_state
FROM cust_dimen
WHERE cust_id LIKE 'cust_1%';

-- Profitable 10 customers
-- cust_id | rank | cust_name | profit | cust_city  | cust_state | sales
WITH cust_summary AS
(
	SELECT c.cust_id,	
			RANK() OVER(ORDER BY SUM(m.profit) DESC) AS customer_rank,
			c.customer_name,
			ROUND(SUM(m.profit),2) AS profit,
			city AS customer_city,
			state AS customer_state,
			ROUND(SUM(m.sales),2) AS sales
	FROM cust_dimen AS c
		INNER JOIN market_fact_full AS m
		ON c.cust_id = m.cust_id
	GROUP BY c.cust_id
)
SELECT *
	FROM cust_summary
-- For Top 10 customers
LIMIT 10;
        
-- Customers without orders
SELECT * FROM cust_dimen;

SELECT c.*
FROM cust_dimen AS c
	LEFT JOIN
		market_fact_full AS m
		ON c.cust_id = m.cust_id
WHERE m.ord_id IS NULL;

-- Verifying if there actual no customers without any orders
SELECT COUNT(cust_id) FROM cust_dimen;
-- 1832

SELECT COUNT(DISTINCT cust_id) FROM market_fact_full;
-- 1832

-- Customers with order more than 1
SELECT c.*,
		COUNT(DISTINCT ord_id) AS Order_count
FROM cust_dimen AS c
	LEFT JOIN
		market_fact_full AS m
		ON c.cust_id = m.cust_id
GROUP BY c.cust_id
HAVING COUNT(DISTINCT ord_id) <> 1;

-- Unique cust_name and city
SELECT customer_name,
	city,
    COUNT(cust_id) AS cust_id_count
FROM cust_dimen
GROUP BY customer_name,
		city
HAVING COUNT(cust_id) >1;

-- FInal Output
WITH cust_details AS
(
	SELECT c.*,
			COUNT(DISTINCT ord_id) AS Order_count
	FROM cust_dimen AS c
		LEFT JOIN
			market_fact_full AS m
			ON c.cust_id = m.cust_id
	GROUP BY c.cust_id
	HAVING COUNT(DISTINCT ord_id) <> 1
),
fraud_customers AS
(
	SELECT customer_name,
		city,
		COUNT(cust_id) AS cust_id_count
	FROM cust_dimen
	GROUP BY customer_name,
			city
	HAVING COUNT(cust_id) >1	
)
SELECT cd.*,
		CASE WHEN fc.cust_id_count IS NOT NULL THEN 'FRAUD'
			ELSE 'NORMAL'
		END AS fraud_flag
	FROM cust_details AS cd
		LEFT JOIN fraud_customers AS fc
        ON cd.customer_name = fc.customer_name AND cd.city = fc.city;


        