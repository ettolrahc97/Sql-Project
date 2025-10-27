-- Calculate the average order amount for each country
SELECT country, AVG(priceEach * quantityOrdered) AS avg_order_value
FROM classicmodels.customers c 
INNER JOIN classicmodels.orders o
ON c.customerNumber = o.customerNumber
INNER JOIN classicmodels.orderdetails od
ON o.orderNumber = od.orderNumber
GROUP BY country
ORDER BY avg_order_value DESC;


-- Calculate the total sales amount of each product line
SELECT productLine, SUM(priceEach * quantityOrdered) AS sales_value
FROM classicmodels.products p 
INNER JOIN orderdetails od
ON p.productCode = od.productCode
GROUP BY productLine
ORDER BY sales_value DESC;

-- List the Top 10 Best-Selling Products based on Total Quantity Sold
SELECT productName, SUM(quantityOrdered) AS units_sold
FROM classicmodels.products p
INNER JOIN classicmodels.orderdetails od
ON p.productCode = od.productCode
GROUP BY productName
ORDER BY units_sold DESC
LIMIT 10;

-- Least ordered selling-products
SELECT productName, SUM(quantityOrdered) AS units_sold
FROM classicmodels.products p
INNER JOIN classicmodels.orderdetails od
ON p.productCode = od.productCode
GROUP BY productName
ORDER BY units_sold 
LIMIT 10;


-- Evaluate the sales performance of each sales representative
SELECT emp.firstName, emp.lastName, SUM(quantityOrdered * priceEach) as order_value
FROM classicmodels.employees emp 
INNER JOIN customers cu 
ON employeeNumber = salesRepEmployeeNumber AND emp.jobTitle = 'Sales Rep'
LEFT JOIN orders o 
ON cU.customerNumber = o.customerNumber
LEFT JOIN orderdetails od
ON o.orderNumber = od.orderNumber
GROUP BY emp.firstName, emp.lastName
ORDER BY order_value DESC;

-- Calculate the average number or orders placed by each customer
SELECT COUNT(o.orderNumber) / COUNT(DISTINCT c.customerNumber)
FROM classicmodels.customers c 
LEFT JOIN classicmodels.orders o 
ON c.customerNumber = o.customerNumber;

-- Calculate the percentage of orders that were shipped on time
SELECT SUM( CASE WHEN shippedDate <= requiredDate THEN 1 ELSE 0 END) / COUNT(orderNumber) * 100 AS PERCENT_ON_TIME
FROM classicmodels.orders;

-- Calculate the profit margin for each product by subtracting the cost of goods sold (COGS) from the sales revenue
SELECT productName, SUM((priceEach * quantityOrdered) - (buyPrice * quantityOrdered)) as net_profit
FROM products p 
INNER JOIN orderdetails o 
ON p.productCode = o.productCode
GROUP BY productName
ORDER BY net_profit DESC;

-- Segment customers based on their total purchase amount
SELECT c.*, t2.customer_segment
FROM customers c
LEFT JOIN
(
SELECT *,
CASE WHEN total_purchased_value > 100000 THEN 'HIGH VALUE'
	 WHEN total_purchased_value BETWEEN 50000 AND 100000 THEN 'MEDIUM VALUE'  	
     WHEN total_purchased_value < 50000 THEN 'LOW VALUE'
ELSE 'OTHER' END AS customer_segment
FROM 
(SELECT customerNumber, SUM(priceEach * quantityOrdered) AS total_purchased_value
FROM classicmodels.orders o 
INNER JOIN classicmodels.orderdetails od
ON o.orderNumber = od.orderNumber
GROUP BY customerNumber) T1
)t2
ON c.customerNUmber = t2.customerNumber;

-- Identify frequently co-purchased products to understand cross-selling opportunities
SELECT od.productCode, p.productName, od2.productCode, p2.productName, COUNT(*) AS purchased_together
FROM orderdetails od
INNER JOIN orderdetails od2
ON od.orderNumber = od2.orderNumber AND od.productCode <> od2.productCode
INNER JOIN products p 
ON od.productCode = p.productCode
INNER JOIN products p2
ON od2.productCode = p2.productCode
GROUP BY od.productCode, p.productName, od2.productCode, p2.productName
ORDER BY purchased_together DESC


















