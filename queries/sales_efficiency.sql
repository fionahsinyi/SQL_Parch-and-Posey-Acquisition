-- [Increasing Sales Efficiency]

-- Part a) Regional Performance based on total sales
-- This query evaluates the performance of sales representatives in each region by:
-- - Counting the number of sales representatives per region.
-- - Summing the total revenue (in USD) generated in each region.
SELECT 
    sr.region_id, 
    region.name AS region_name, 
    COUNT(DISTINCT sr.name) AS sales_rep_count, 
    SUM(o.total_amt_usd) AS total_sales 
FROM sales_reps sr
JOIN region ON sr.region_id = region.id
LEFT JOIN accounts ON sr.id = accounts.sales_rep_id
LEFT JOIN orders o ON accounts.id = o.account_id
GROUP BY sr.region_id, region.name
ORDER BY sr.region_id;

-- Part a) Extra Analysis: Individual sales rep performance in their region
-- This query compares each sales rep's performance against the regional average.
WITH order_stats AS (
    SELECT 
        sr.id AS sales_rep_id, 
        sr."name" AS sales_rep, 
        r."name" AS region, 
        COUNT(o.id) AS total_orders, 
        SUM(o.total_amt_usd) AS total_revenue
    FROM sales_reps sr
    JOIN region r ON r.id = sr.region_id
    JOIN accounts a ON sr.id = a.sales_rep_id
    JOIN orders o ON a.id = o.account_id
    GROUP BY sr.id, sr."name", r."name"
),
avg_order_stats AS (
    SELECT AVG(total_orders) AS avg_orders 
    FROM order_stats
)
SELECT 
    os.sales_rep, 
    os.region, 
    os.total_orders, 
    ROUND(avg_order_stats.avg_orders) AS avg_order_per_person, 
    os.total_revenue,
    CASE 
        WHEN os.total_orders > avg_order_stats.avg_orders THEN 'Overperform'
        ELSE 'Underperform'
    END AS performance
FROM order_stats os
CROSS JOIN avg_order_stats avg_orders
ORDER BY os.total_revenue DESC;

-- Part b) Location of Sales
-- This query retrieves the total revenue and geographical location (latitude and longitude)
-- for each account, providing insight into sales distribution.
SELECT 
    SUM(o.total_amt_usd) AS total_revenue, 
    o.account_id, 
    a.id, 
    a.lat, 
    a.long 
FROM orders o
JOIN accounts a ON o.account_id = a.id
GROUP BY o.account_id, a.id, a.lat, a.long;

-- Part b) Extra Analysis: Underperforming sales reps in the Northeast region
-- This query identifies the sales reps in the Northeast region who underperform compared 
-- to the regional average.
WITH order_stats AS (
    SELECT 
        sr.id AS sales_rep_id, 
        sr."name" AS sales_rep, 
        r."name" AS region, 
        COUNT(o.id) AS total_orders, 
        SUM(o.total_amt_usd) AS total_revenue
    FROM sales_reps sr
    JOIN region r ON r.id = sr.region_id
    JOIN accounts a ON sr.id = a.sales_rep_id
    JOIN orders o ON a.id = o.account_id
    GROUP BY sr.id, sr."name", r."name"
),
avg_order_stats AS (
    SELECT AVG(total_orders) AS avg_orders 
    FROM order_stats
)
SELECT 
    os.sales_rep, 
    os.region, 
    os.total_orders, 
    ROUND(avg_order_stats.avg_orders) AS avg_order_per_person, 
    os.total_revenue,
    CASE 
        WHEN os.total_orders > avg_order_stats.avg_orders THEN 'Overperform'
        ELSE 'Underperform'
    END AS performance
FROM order_stats os
CROSS JOIN avg_order_stats avg_orders
WHERE os.region = 'Northeast'
  AND CASE 
        WHEN os.total_orders > avg_order_stats.avg_orders THEN 'Overperform'
        ELSE 'Underperform'
      END = 'Underperform'
ORDER BY os.total_revenue ASC
LIMIT 10;
