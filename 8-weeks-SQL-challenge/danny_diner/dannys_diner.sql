-- Q1 - Q2
-- basic analysis on visit frequency and spending pattern
SELECT
	m.customer_id,
    SUM(me.price) AS amount_spent,
    COUNT(DISTINCT s.order_date) AS number_of_visits,
    ROUND(SUM(me.price) / COUNT(DISTINCT s.order_date),  2) AS expense_per_visit
FROM
	members AS m
LEFT JOIN sales AS s
	ON s.customer_id = m.customer_id
LEFT JOIN menu AS me
	ON me.product_id = s.product_id
GROUP BY
	m.customer_id;