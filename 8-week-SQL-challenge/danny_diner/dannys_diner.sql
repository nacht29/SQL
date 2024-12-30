WITH pre_member_order AS (
	SELECT
		members.customer_id,
		sales.order_date,
		sales.product_id,
		DENSE_RANK() OVER (
			PARTITION BY members.customer_id
			ORDER BY sales.order_date DESC
		) AS rev_ranked
	FROM
		members
	INNER JOIN sales
		ON sales.customer_id = members.customer_id 
		AND sales.order_date < members.join_date
)

SELECT
	pre_member_order.customer_id,
	menu.product_name
FROM
	pre_member_order
INNER JOIN menu
	ON menu.product_id = pre_member_order.product_id
WHERE
	rev_ranked = 1
ORDER BY
	pre_member_order.customer_id ASC;	