# 🍜 Case Study #1: Danny's Diner

<img src="https://user-images.githubusercontent.com/81607668/127727503-9d9e7a25-93cb-4f95-8bd0-20b87cb4b459.png" alt="Image" width="500" height="520">

## 📚 Table of Contents
- [Task Summary](#task-summary)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Questions and Solutions](#questions-and-solutions)

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
- The ````DISTINCT```` keyword is highly important here as it avoids counting multiple, duplicate visits on the same day. For example, Customer A has 2 visits on date ````"2021-01-01"````. Without the ````DISTINCT```` keyword, 2 separate days will be counted instead of 1.

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


**4. What is the most purchased item on the menu and how many times was it purchased by all customers?**

**5. Which item was the most popular for each customer?**


**6. Which item was purchased first by the customer after they became a member?**


**7. Which item was purchased just before the customer became a member?**


**8. What is the total items and amount spent for each member before they became a member?**


**9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?**

**10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?**