use supply_db ;

/* Question : Golf related products

List all products in categories related to golf. Display the Product_Id, Product_Name in the output. Sort the output in the order of product id.
Hint: You can identify a Golf category by the name of the category that contains golf.
*/
 Select Product_Name,
		Product_Id
 FROM product_info AS p
 inner join 
	category as c
	on p.Category_Id = c.Id
 where c.name like '%golf%'
 order by Product_Id;


-- **********************************************************************************************************************************

/*
Question : Most sold golf products

Find the top 10 most sold products (based on sales) in categories related to golf. Display the Product_Name and Sales column in the output. Sort the output in the descending order of sales.
Hint: You can identify a Golf category by the name of the category that contains golf.

HINT:
Use orders, ordered_items, product_info, and category tables from the Supply chain dataset.
*/
 Select Product_Name,
		sum(o.Sales) as sales
 FROM category AS c
 inner join
	product_info as p
	on  c.Id = p.Category_Id
 inner join 
	ordered_items As o
	on p.Product_Id = o.Item_id
 where c.name like '%golf%'
 group by Product_Name
 order by sales desc
 limit 10;


-- **********************************************************************************************************************************

/*
Question: Segment wise orders

Find the number of orders by each customer segment for orders. Sort the result from the highest to the lowest 
number of orders.The output table should have the following information:
-Customer_segment
-Orders
*/
 select segment,
		count(o.order_id) as orders
 from customer_info as c
 inner join 
	orders as o 
	on c.id = o.customer_id
 group by segment
 order by orders desc;

-- **********************************************************************************************************************************
/*
Question : Percentage of order split

Description: Find the percentage of split of orders by each customer segment for orders that took six days 
to ship (based on Real_Shipping_Days). Sort the result from the highest to the lowest percentage of split orders,
rounding off to one decimal place. The output table should have the following information:
-Customer_segment
-Percentage_order_split

HINT:
Use the orders and customer_info tables from the Supply chain dataset.

*/
WITH Seg_Orders AS
(
SELECT
cust.Segment AS customer_segment,
COUNT(ord.Order_Id) AS Orders
FROM
orders AS ord
LEFT JOIN
customer_info AS cust
ON ord.Customer_Id = cust.Id
WHERE Real_Shipping_Days=6
GROUP BY 1
)
SELECT
a.customer_segment,
ROUND(a.Orders/SUM(b.Orders)*100,1) AS percentage_order_split
FROM
Seg_Orders AS a
JOIN
Seg_Orders AS b
GROUP BY 1
ORDER BY 2 DESC;

-- **********************************************************************************************************************************
