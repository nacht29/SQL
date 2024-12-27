WITH sales_count AS (
	SELECT
		menu.product_id,
		menu.product_name,
		COUNT(*) AS unit_sold
	FROM
		menu
	LEFT JOIN sales
		ON sales.product_id = menu.product_id
	GROUP BY
		menu.product_id,
		menu.product_name
),

sales_count_ranking AS (
	SELECT
		sales_count.product_id,
		sales_count.product_name,
		sales_count.unit_sold,
		DENSE_RANK() OVER (
			ORDER BY sales_count.unit_sold DESC
		) AS ranking
	FROM
		sales_count
)

SELECT
	product_id,
	product_name,
	unit_sold
FROM
	sales_count_ranking
WHERE
	ranking = 1;