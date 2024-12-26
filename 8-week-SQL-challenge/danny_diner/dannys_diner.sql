WITH sales_in_order AS (
	SELECT
		sales.customer_id,
		sales.order_date,
		menu.product_name,
	DENSE_RANK() OVER(
		PARTITION BY sales.customer_id
		ORDER BY sales.order_date ASC) AS ranked
	FROM
		sales
	LEFT JOIN menu
		ON menu.product_id = sales.product_id
)

SELECT
	DISTINCT customer_id,
	order_date,
	product_name
FROM
	sales_in_order
WHERE
	ranked = 1
ORDER BY
	customer_id;

