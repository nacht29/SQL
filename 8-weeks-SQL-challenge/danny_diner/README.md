**1. What is the total amount each customer spent at the restaurant?**

````sql
SELECT 
  sales.customer_id, 
  SUM(menu.price) AS total_sales
FROM
	sales
LEFT JOIN menu
  ON sales.product_id = menu.product_id
GROUP BY
	sales.customer_id
ORDER BY
	sales.customer_id ASC;
````

Steps:
1. Use ```JOIN``` to merge ````sales```` table and ````menu````table since we need ````sales.customer_id```` and ````menu.price```` to show and count the amount each customer spent
2. Use ````SUM```` to total up the sales contributed by each customer.
3. Use ````GROUP```` to calculate contribution by each customer separately, then arrange the results with ````sales.customer````_id in ascending order.