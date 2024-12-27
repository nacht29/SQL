WITH sales_count_cte AS (
	SELECT
		menu.product_id,
		menu.product_name,
		COUNT(*) AS item_sold
	FROM
		menu
	LEFT JOIN sales
		ON sales.product_id = menu.product_id
	GROUP BY
		menu.product_id,
		menu.product_name
),

sales_ranking_cte AS (
	SELECT
		sales_count_cte.product_id,
		sales_count_cte.product_name,
		sales_count_cte.item_sold,
		DENSE_RANK() OVER (
			ORDER BY sales_count_cte.item_sold
		) AS ranking
	FROM
		sales_count_cte
)

SELECT
	product_id,
	product_name,
	item_sold
FROM
	sales_ranking_cte
WHERE
	ranking = 1;