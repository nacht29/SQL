WITH orders_by_customer AS (
	SELECT
		sales.customer_id,
		menu.product_name,
		COUNT(*) AS unit_sold
	FROM
		sales
	LEFT JOIN menu
		ON sales.product_id = menu.product_id
	GROUP BY
		sales.customer_id,
		menu.product_name
),

preference_ranking AS (
	SELECT
		customer_id,
		product_name,
		unit_sold,
		DENSE_RANK() OVER (
			PARTITION BY customer_id
			ORDER BY unit_sold DESC
		) AS ranking
	FROM
		orders_by_customer
)

SELECT
	customer_id,
	product_name,
	unit_sold
FROM
	preference_ranking
WHERE
	ranking = 1;