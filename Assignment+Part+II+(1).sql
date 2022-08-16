use supply_db ;

/*  Question: Month-wise NIKE sales

	Description:
		Find the combined month-wise sales and quantities sold for all the Nike products. 
        The months should be formatted as ‘YYYY-MM’ (for example, ‘2019-01’ for January 2019). 
        Sort the output based on the month column (from the oldest to newest). The output should have following columns :
			-Month
			-Quantities_sold
			-Sales
		HINT:
			Use orders, ordered_items, and product_info tables from the Supply chain dataset.
*/		
SELECT DATE_FORMAT(Order_Date,'%Y-%m') AS Month,
SUM(Quantity) AS Quantities_Sold,
SUM(Sales) AS Sales
FROM
orders AS ord
LEFT JOIN
ordered_items AS ord_itm
ON ord.Order_Id = ord_itm.Order_Id
LEFT JOIN
product_info AS prod_info
ON ord_itm.Item_Id=prod_info.Product_Id
WHERE LOWER(Product_Name) LIKE '%nike%'
GROUP BY 1
ORDER BY 1;

-- **********************************************************************************************************************************
/*

Question : Costliest products

Description: What are the top five costliest products in the catalogue? Provide the following information/details:
-Product_Id
-Product_Name
-Category_Name
-Department_Name
-Product_Price

Sort the result in the descending order of the Product_Price.

HINT:
Use product_info, category, and department tables from the Supply chain dataset.
*/
SELECT p.Product_id, p.product_name, 
		c.name As category_name, 
		d.name AS department_name, 
        p.product_price
FROM category AS c
INNER JOIN 
	product_info AS p
	on c.id = p.Category_Id
inner join
	department AS d
	ON p.department_id = d.id
order by p.product_price desc
limit 5;

-- **********************************************************************************************************************************

/*

Question : Cash customers

Description: Identify the top 10 most ordered items based on sales from all the ‘CASH’ type orders. 
Provide the Product Name, Sales, and Distinct Order count for these items. Sort the table in descending
 order of Order counts and for the cases where the order count is the same, sort based on sales (highest to
 lowest) within that group.
 
HINT: Use orders, ordered_items, and product_info tables from the Supply chain dataset.

*/
select p.product_name,
	 oi.sales, 
	count(distinct o.order_id) as order_count
from orders as o
inner join
	ordered_items as oi
	on o.order_id = oi.order_id
inner join 
	product_info as p
	on oi.item_id = p.product_id
where o.type = 'CASH'
group by p.product_name
order by order_count desc,
		oi.sales desc
limit 10;


-- **********************************************************************************************************************************
/*
Question : Customers from texas

Obtain all the details from the Orders table (all columns) for customer orders in the state of Texas (TX),
whose street address contains the word ‘Plaza’ but not the word ‘Mountain’. The output should be sorted by the Order_Id.

HINT: Use orders and customer_info tables from the Supply chain dataset.

*/
select o.*
from orders as o
inner join
		customer_info as c
        on o.customer_id = c.id
where c.street like '%Plaza%' and
		c.street not like '%Mountain%' and
        c.state = 'TX'
order by o.Order_Id;
        


-- **********************************************************************************************************************************
/*
 
Question: Home office

For all the orders of the customers belonging to “Home Office” Segment and have ordered items belonging to
“Apparel” or “Outdoors” departments. Compute the total count of such orders. The final output should contain the 
following columns:
-Order_Count
*/
select count(o.Order_Id) AS order_count
from customer_info as c
inner join 
	orders as o
	on c.id = o.customer_id
inner join 
	ordered_items as oi
	on o.Order_Id = oi.Order_Id
inner join 
	product_info as p
    on oi.item_id = p.Product_Id
inner join 
	department as d
	on p.Department_Id = d.Id
where c.segment = 'Home Office' AND (d.Name = 'Apparel' OR d.Name = 'Outdoors');
-- **********************************************************************************************************************************
/*

Question : Within state ranking
 
For all the orders of the customers belonging to “Home Office” Segment and have ordered items belonging
to “Apparel” or “Outdoors” departments. Compute the count of orders for all combinations of Order_State and Order_City. 
Rank each Order_City within each Order State based on the descending order of their order count (use dense_rank). 
The states should be ordered alphabetically, and Order_Cities within each state should be ordered based on their rank. 
If there is a clash in the city ranking, in such cases, it must be ordered alphabetically based on the city name. 
The final output should contain the following columns:
-Order_State
-Order_City
-Order_Count
-City_rank

HINT: Use orders, ordered_items, product_info, customer_info, and department tables from the Supply chain dataset.
*/
select o.Order_State,
		o.Order_City,
		count(o.Order_Id) AS order_count,
		DENSE_RANK() OVER(PARTITION BY Order_State ORDER BY count(Order_Id) DESC) AS city_rank
from customer_info as c
inner join 
	orders as o
	on c.id = o.customer_id
inner join 
	ordered_items as oi
	on o.Order_Id = oi.Order_Id
inner join 
	product_info as p
    on oi.item_id = p.Product_Id
inner join 
	department as d
	on p.Department_Id = d.Id
where c.segment = 'Home Office' AND d.Name IN ('Apparel', 'Outdoors')
group by o.Order_State, o.Order_City
order by Order_State, city_rank, Order_City;

-- **********************************************************************************************************************************
/*
Question : Underestimated orders

Rank (using row_number so that irrespective of the duplicates, so you obtain a unique ranking) the 
shipping mode for each year,
 based on the number of orders when the shipping days were underestimated (i.e., Scheduled_Shipping_Days < Real_Shipping_Days). ...
 The shipping mode with the highest orders that meet the required criteria should appear first.
 Consider only ‘COMPLETE’ and ‘CLOSED’ orders and those belonging to ....
the customer segment: ‘Consumer’....
 The final output should contain the following columns:
-Shipping_Mode,
-Shipping_Underestimated_Order_Count,
-Shipping_Mode_Rank

HINT: Use orders and customer_info tables from the Supply chain dataset.
*/
select year(o.Order_Date),o.Shipping_Mode, 
        count(Order_Id) as Shipping_Underestimated_Order_Count,
        RANK() over(partition by year(o.Order_date) order by count(Order_Id) desc) as Shipping_Mode_Rank
from customer_info as c
inner join 
	orders as o
	on c.id = o.customer_id
where c.segment ='Consumer' and 
	(o.order_status = 'COMPLETE' or o.order_status = 'CLOSED') and
    (o.Scheduled_Shipping_Days < o.Real_Shipping_Days)
group by year(o.Order_date), o.Shipping_Mode;


-- **********************************************************************************************************************************





