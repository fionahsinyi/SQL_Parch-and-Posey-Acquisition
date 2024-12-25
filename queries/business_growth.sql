-- [Business Growth Analysis]

-- Query 1: Calculate total revenue over time by product type and overall revenue
-- This query groups the revenue data by month and calculates:
-- - Total revenue for Poster, Gloss, and Standard products.
-- - Overall revenue (sum of all product types) per month.
-- The results show how revenue evolves over time.
SELECT 
    DATE_TRUNC('month', occurred_at) AS month, 
    SUM(poster_amt_usd) AS poster_total, 
    SUM(gloss_amt_usd) AS gloss_total, 
    SUM(standard_amt_usd) AS standard_total, 
    SUM(total_amt_usd) AS total_revenue
FROM orders
GROUP BY month
ORDER BY month ASC;

-- Query 2: Count the number of orders placed over time, grouped by month
-- This query counts the total number of orders for each month to track changes in order volume.
SELECT 
    DATE_TRUNC('month', occurred_at) AS date, 
    COUNT(id) AS no_of_orders
FROM orders o 
GROUP BY date
ORDER BY date ASC;

-- Query 3: Track customer engagement over time based on web events
-- This query calculates the number of web events per month, indicating how actively customers interact with the platform.
SELECT 
    DATE_TRUNC('month', occurred_at) AS month, 
    COUNT(*) AS event_count
FROM web_events
GROUP BY month
ORDER BY month ASC;
