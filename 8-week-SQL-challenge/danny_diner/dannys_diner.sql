-- Question 1 
SELECT 
  sales.customer_id, 
  SUM(menu.price) AS total_sales
FROM
	sales
INNER JOIN menu
  ON sales.product_id = menu.product_id
GROUP BY
	sales.customer_id
ORDER BY
	sales.customer_id ASC;

-- Question 2
SELECT
	sales.customer_id,
	COUNT(DISTINCT order_date) as number_of_visits
FROM
	sales
GROUP BY
	sales.customer_id;