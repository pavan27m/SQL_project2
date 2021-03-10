USE pavan;

SELECT customer_name AS `Customer Name`, customer_segment AS `Customer Segment`
FROM cust_dimen;

SELECT * 
FROM cust_dimen
ORDER BY customer_name DESC;

SELECT order_id, order_date
FROM orders_dimen
WHERE order_priority like "high";

SELECT SUM(sales) `total sales`, AVG(sales) `average sales`
FROM market_fact;

SELECT MAX(sales), MIN(sales)
FROM market_fact;

SELECT region, COUNT(*) AS no_of_customers
FROM cust_dimen
GROUP BY region
ORDER BY no_of_customers DESC;

SELECT region, MAX(no_of_customers)
FROM(SELECT region, COUNT(*)  no_of_customers
FROM cust_dimen
GROUP BY region) R;

SELECT o.order_date, m.order_quantity, m.sales
FROM orders_dimen o
LEFT JOIN market_fact m ON o.ord_id =  m.ord_id;

SELECT customer_name 
FROM cust_dimen
WHERE customer_name LIKE "_R%" OR customer_name LIKE "___D%";

SELECT c.cust_id, m.sales,c.customer_name, c.region
FROM cust_dimen c
LEFT JOIN market_fact m ON c.cust_id = m.cust_id
WHERE m.sales BETWEEN 1000 AND 5000;

SELECT c.customer_name, count(m.prod_id) no_of_tables_purchased
FROM cust_dimen c
INNER JOIN market_fact m ON m.cust_id = c.cust_id
INNER JOIN prod_dimen p on p.prod_id = m.prod_id
WHERE c.region = "atlantic" AND p.product_sub_category ="TABLES"
GROUP BY c.customer_name;

SELECT customer_name, customer_segment AS "no of small business owners", region
FROM cust_dimen
WHERE region LIKE "ONTARIO" AND customer_segment LIKE "small business"
ORDER BY customer_name;

SELECT prod_id, order_quantity AS "no of products sold"
FROM market_fact
ORDER BY "no of products sold" DESC;

SELECT prod_id, product_sub_category, product_category
FROM prod_dimen
WHERE(product_category = "furniture" OR product_category = "technology");

SELECT product_category, SUM(profit)
FROM prod_dimen p
LEFT JOIN market_fact m on m. prod_id = p.prod_id
GROUP BY product_category
ORDER BY profit DESC;

SELECT product_category, product_sub_category, profit 
FROM prod_dimen p
INNER JOIN market_fact m ON m.prod_id = p.prod_id
GROUP BY product_sub_category;

SELECT sales `3rd highest sales`
FROM market_fact
ORDER BY sales DESC LIMIT 2,1;


SELECT c.region, COUNT(distinct s.ship_id) AS no_of_shipments, SUM(m.profit) AS profit_in_each_region
FROM market_fact m
INNER JOIN cust_dimen c ON m.cust_id = c.cust_id
INNER JOIN shipping_dimen s ON m.ship_id = s.ship_id
INNER JOIN prod_dimen p ON m.prod_id = p.prod_id
WHERE 
	p.product_sub_category IN
	(SELECT p.product_sub_category
	FROM market_fact m
	INNER JOIN prod_dimen p ON m.prod_id = p.prod_id
	GROUP BY p.product_sub_category
	HAVING SUM (m.profit)  <= ALL
		(SELECT SUM(m.profit) AS profits
		FROM market_fact m
		INNER JOIN prod_dimen p ON m.prod_id = p.prod_id
		GROUP BY p.product_sub_category))
GROUP BY c.region
ORDER BY profit_in_each_region DESC;