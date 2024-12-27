# 🍜 Case Study #1: Danny's Diner

<img src="https://user-images.githubusercontent.com/81607668/127727503-9d9e7a25-93cb-4f95-8bd0-20b87cb4b459.png" alt="Image" width="500" height="520">

## 📚 Table of Contents
- [Task Summary](#task-summary)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Questions and Solutions](#questions-and-solutions)
- [Data Summary](#data-summary)

### Task Summary
Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite.

### Entity Relationship Diagram
![image](https://user-images.githubusercontent.com/81607668/127271130-dca9aedd-4ca9-4ed8-b6ec-1e1920dca4a8.png)

### Questions and Solutions
**1. What is the total amount each customer spent at the restaurant?**

````sql
SELECT 
	sales.customer_id, 
	SUM(menu.price) AS total_sales
FROM
	sales
LEFT JOIN menu
	ON sales.product_id = menu.product_id
GROUP BY
	sales.customer_id
ORDER BY
	sales.customer_id ASC;
````

**Steps:**
- Use ```JOIN``` to merge ````sales```` table and ````menu````table since we need ````sales.customer_id```` and ````menu.price```` to show and count the amount each customer spent
- Use ````SUM```` to total up the sales contributed by each customer.
- Use ````GROUP```` to calculate contribution by each customer separately, then arrange the results with ````sales.customer````_id in ascending order.

**Answer:**

| customer_id | total_sales |
|-------------|-------------|
| A           | 76          |
| B           | 74          |
| C           | 36          |

- Customer A spent $76.
- Customer B spent $74.
- Customer C spent $36.

**2. How many days has each customer visited the restaurant?**

````sql
SELECT
	sales.customer_id,
	COUNT(DISTINCT order_date) as number_of_visits
FROM
	sales
GROUP BY
	sales.customer_id;
````

**Steps:**
- Use ````COUNT(DISTINCT order_date)```` to count the unique number of visit by each customer
- The ````DISTINCT```` keyword is highly important here as it avoids counting multiple, duplicate visits on the same day. For example, Customer A has 2 visits on date ````"2021-01-01"````. Without the ````DISTINCT```` keyword, 2 separate days will be counted instead of 1

to test:
````sql
SELECT
	customer_id,
	order_date
FROM
	sales
GROUP BY
	customer_id,
	order_date
HAVING
	COUNT(*) > 1;
````

**Answer:**

|customer_id|number_of_visits|
|-----------|----------------|
|A          |4               |
|B          |6               |
|C          |2               |

- Customer A visitted on 4 days
- Customer B visitted on 6 days
- Customer C visitted on 2 days

**3. What was the first item from the menu purchased by each customer?**

````sql
WITH sales_in_order AS (
	SELECT
		sales.customer_id,
		sales.order_date,
		menu.product_name,
	DENSE_RANK() OVER(
		PARTITION BY sales.customer_id
		ORDER BY sales.order_date ASC) AS ranked
	FROM
		sales
	LEFT JOIN menu
		ON menu.product_id = sales.product_id
)

SELECT
	customer_id,
	order_date,
	product_name
FROM
	sales_in_order
WHERE
	ranked = 1
ORDER BY
	customer_id;
````

**Steps:**

- Create a CTE (think of it as a temporary table) that contains ````sales.customer_id````, ````sales.order_date```` and ````menu.product_name```` which we will need to show in the final result
- Within the CTE, create a column ````ranked```` which shows how early each food was ordered. ````DENSE_RANK()```` assigns the ranking follwoing ````ORDER BY sales.order_date ASC````, hence the earlier food orderd gets ranked higher
- ````PARTITION BY```` ensures the ranking is done separately for each customer

**Answer:**

|customer_id|order_date|product_name|
|-----------|----------|------------|
|A          |2021-01-01|curry       |
|A          |2021-01-01|sushi       |
|B          |2021-01-01|curry       |
|C          |2021-01-01|ramen       |

- Customer A ordered both curry and sushi on during their first visit
- Customer B ordered sushi on their first visit
- Customer C ordered ramen on their first visit

**4. What is the most purchased item on the menu and how many times was it purchased by all customers?**

````sql
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
````

**5. Which item was the most popular for each customer?**


**6. Which item was purchased first by the customer after they became a member?**


**7. Which item was purchased just before the customer became a member?**


**8. What is the total items and amount spent for each member before they became a member?**


**9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?**

**10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?**

### Data Summary

|customer_id|first_order|favorite_item|amount_spent|visit_count|membership_status      |
|-----------|-----------|-------------|------------|-----------|-----------------------|
|A          |sushi      |ramen        |$76.00      |4          |Member since 2021-01-07|
|B          |curry      |sushi        |$74.00      |6          |Member since 2021-01-09|
|C          |ramen      |ramen        |$36.00      |2          |Non-member             |
