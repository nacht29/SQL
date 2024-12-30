WITH pre_member_order AS (
	SELECT
		members.customer_id,
		sales.order_date,
		sales.product_id
	FROM
		members
	INNER JOIN sales
		ON sales.customer_id = members.customer_id 
		AND sales.order_date < members.join_date
)

SELECT
	pre_member_order.customer_id,
	COUNT(*) AS item_purchased,
	SUM(menu.price) AS total_price
FROM
	pre_member_order
JOIN menu
	ON menu.product_id = pre_member_order.product_id
GROUP BY
	pre_member_order.customer_id
ORDER BY
	pre_member_order.customer_id ASC;