-- [Current State of the Company]
-- Query 1: Retrieve the list of products offered by the company
-- This query identifies all columns in the 'orders' table that relate to product quantities.
SELECT column_name AS offered_products
FROM information_schema.columns
WHERE table_name = 'orders' AND column_name LIKE '%qty%';

-- Query 2: Count the total number of customers
-- This query calculates the total number of customers in the 'accounts' table.
SELECT COUNT(*) AS no_of_customers 
FROM accounts a;

-- Query 3: Count the total number of employees (sales representatives)
-- This query calculates the total number of sales representatives in the 'sales_reps' table.
SELECT COUNT(*) AS no_of_employees 
FROM sales_reps sr;

-- Query 4: Count the number of sales representatives in each region
-- This query joins the 'region' and 'sales_reps' tables and groups by region to calculate the count.
SELECT r.name AS region_name, COUNT(sr.name) AS no_sales_reps
FROM region r
LEFT JOIN sales_reps sr ON r.id = sr.region_id
GROUP BY r.name;

-- Query 5: Count the number of web events per channel
-- This query calculates the number of web events for each channel in the 'web_events' table.
SELECT channel, COUNT(*) AS no_web_event_channels
FROM web_events we
GROUP BY channel;

-- Query 6: Count the total number of orders placed
-- This query calculates the total number of orders in the 'orders' table.
SELECT COUNT(id) AS total_orders 
FROM orders o;

-- Query 7: Find the date range of all order records
-- This query retrieves the earliest and latest dates from the 'web_events' table.
SELECT MIN(occurred_at) AS start_date, MAX(occurred_at) AS end_date 
FROM web_events we;

-- Query 8: Calculate the total order size for each product and the overall total quantity
-- This query sums the quantities of all product types in the 'orders' table.
SELECT SUM(poster_qty) AS poster_total_qty, 
       SUM(gloss_qty) AS gloss_total_qty, 
       SUM(standard_qty) AS standard_total_qty, 
       SUM(total) AS total_order_qty
FROM orders o;

-- Query 9: Calculate the proportion of each product type in total orders
-- This query computes the proportions of Standard, Gloss, and Poster products in total orders.
SELECT ROUND(1.0 * SUM(standard_qty) / SUM(total), 2) AS standard_qty_proportion,
       ROUND(1.0 * SUM(gloss_qty) / SUM(total), 2) AS gloss_qty_proportion,
       ROUND(1.0 * SUM(poster_qty) / SUM(total), 2) AS poster_qty_proportion
FROM orders o;

-- Query 10: Calculate the average number of orders per account
-- This query first counts the number of orders for each account, then computes the average.
SELECT ROUND(AVG(order_acc), 1) AS avg_order_per_account
FROM (SELECT account_id, COUNT(*) AS order_acc 
      FROM orders o
      GROUP BY account_id) AS order_per_acc;
