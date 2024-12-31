WITH first_week AS (
	SELECT
		members.customer_id,
		members.join_date,
		DATE_ADD(members.join_date, INTERVAL 6 DAY) AS end_week
	FROM
		members
)

SELECT
	sales.customer_id,
	SUM(
		CASE
			WHEN sales.order_date BETWEEN first_week.join_date AND first_week.end_week
				THEN menu.price * 2
			WHEN menu.product_name = "sushi"
				THEN menu.price * 2
			ELSE
				menu.price
			END
	) * 10 AS points
FROM
	sales
INNER JOIN first_week
	ON first_week.customer_id = sales.customer_id
INNER JOIN menu
	ON sales.product_id = menu.product_id
WHERE
	sales.order_date <= "2021-01-31"
GROUP BY
	sales.customer_id
ORDER BY
	sales.customer_id;