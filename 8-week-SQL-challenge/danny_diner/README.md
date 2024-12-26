# 🍜 Case Study #1: Danny's Diner

<img src="https://user-images.githubusercontent.com/81607668/127727503-9d9e7a25-93cb-4f95-8bd0-20b87cb4b459.png" alt="Image" width="500" height="520">

## 📚 Table of Contents
- [Task Summary](#business-task)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Questions and Solutions](#question-and-solution)

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
1. Use ```JOIN``` to merge ````sales```` table and ````menu````table since we need ````sales.customer_id```` and ````menu.price```` to show and count the amount each customer spent
2. Use ````SUM```` to total up the sales contributed by each customer.
3. Use ````GROUP```` to calculate contribution by each customer separately, then arrange the results with ````sales.customer````_id in ascending order.

**Answer:**

| customer_id | total_sales |
|-------------|-------------|
| A           | 76          |
| B           | 74          |
| C           | 36          |

- Customer A spent $76.
- Customer B spent $74.
- Customer C spent $36.
