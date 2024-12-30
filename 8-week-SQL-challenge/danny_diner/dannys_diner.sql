WITH member_orders AS (
	SELECT
		members.customer_id,
		sales.product_id,
		DENSE_RANK() OVER (
			PARTITION BY members.customer_id
			ORDER BY sales.order_date ASC
		) AS ranked
	FROM
		members
	INNER JOIN sales
		ON sales.customer_id = members.customer_id 
		AND sales.order_date > members.join_date
)

SELECT
	member_orders.customer_id,
	SUM(menu.price) * 10 AS points
FROM
	member_orders
INNER JOIN menu
	ON menu.product_id = member_orders.product_id
WHERE
	member_orders.ranked <= 7
GROUP BY
	member_orders.customer_id
ORDER BY
	member_orders.customer_id;