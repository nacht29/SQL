WITH first_orders AS (
    SELECT DISTINCT -- Added DISTINCT to ensure one first order
        s.customer_id,
        FIRST_VALUE(m.product_name) OVER (
            PARTITION BY s.customer_id 
            ORDER BY s.order_date, s.product_id
        ) as first_order
    FROM sales s
    JOIN menu m ON s.product_id = m.product_id
),
favorite_items AS (
    SELECT 
        customer_id,
        -- Take the first product in case of ties
        FIRST_VALUE(product_name) OVER (
            PARTITION BY customer_id 
            ORDER BY purchase_count DESC, product_id
        ) as favorite_item
    FROM (
        SELECT 
            s.customer_id,
            m.product_name,
            m.product_id,
            COUNT(*) as purchase_count
        FROM sales s
        JOIN menu m ON s.product_id = m.product_id
        GROUP BY s.customer_id, m.product_name, m.product_id
    ) item_counts
),
total_spent AS (
    SELECT 
        s.customer_id,
        SUM(m.price) as total_amount
    FROM sales s
    JOIN menu m ON s.product_id = m.product_id
    GROUP BY s.customer_id
),
visit_counts AS (
    SELECT 
        customer_id,
        COUNT(DISTINCT order_date) as total_visits
    FROM sales
    GROUP BY customer_id
)

SELECT DISTINCT -- Added DISTINCT to final select
    s.customer_id,
    fo.first_order,
    fi.favorite_item,
    CONCAT('$', FORMAT(ts.total_amount, 2)) as amount_spent,
    vc.total_visits as visit_count,
    CASE 
        WHEN m.join_date IS NOT NULL 
        THEN CONCAT('Member since ', DATE_FORMAT(m.join_date, '%Y-%m-%d'))
        ELSE 'Non-member'
    END as membership_status
FROM sales s
LEFT JOIN members m ON s.customer_id = m.customer_id
LEFT JOIN first_orders fo ON s.customer_id = fo.customer_id
LEFT JOIN favorite_items fi ON s.customer_id = fi.customer_id
LEFT JOIN total_spent ts ON s.customer_id = ts.customer_id
LEFT JOIN visit_counts vc ON s.customer_id = vc.customer_id
ORDER BY s.customer_id;