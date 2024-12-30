SELECT
	sales.customer_id,
	SUM(CASE
		WHEN menu.product_name = "sushi" THEN menu.price * 2
		ELSE menu.price
		END) * 10 AS points
FROM
	sales
INNER JOIN menu
	ON menu.product_id = sales.product_id
GROUP BY
	sales.customer_id;