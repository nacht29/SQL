WITH customer_data AS (
	SELECT
		sales.customer_id,
		sales.order_date,
		menu.product_name,
		menu.price,
		CASE
		WHEN sales.order_date >= members.join_date
			THEN 'Y'
		ELSE
			'N'
		END AS member
	FROM
		sales
	LEFT JOIN members
		ON members.customer_id = sales.customer_id
	INNER JOIN menu
		ON menu.product_id = sales.product_id
	ORDER BY
		sales.customer_id
)

SELECT
	*,
	CASE
	WHEN member = 'N'
		THEN NULL
	ELSE
		DENSE_RANK() OVER (
			PARTITION BY customer_id, member
			ORDER BY order_date
		)
	END AS ranking
FROM
	customer_data;