-- [Marketing Strategies Analysis]

-- Part a) Categorize customers into industries for targeted marketing
-- This query classifies customers into predefined industries based on keywords in their names.
-- The industries include Food Industry, Technology, Healthcare, Automotive, and Others.
SELECT DISTINCT
    CASE 
        WHEN a.name ILIKE '%food%' OR a.name ILIKE '%restaurant%' THEN 'Food Industry'
        WHEN a.name ILIKE '%tech%' OR a.name ILIKE '%software%' THEN 'Technology'
        WHEN a.name ILIKE '%medical%' OR a.name ILIKE '%health%' THEN 'Healthcare'
        WHEN a.name ILIKE '%auto%' OR a.name ILIKE '%car%' THEN 'Automotive'
        ELSE 'Other'
    END AS industry, 
    a.name AS customer_name
FROM accounts a
WHERE a.name ILIKE '%food%' 
   OR a.name ILIKE '%restaurant%' 
   OR a.name ILIKE '%tech%' 
   OR a.name ILIKE '%software%' 
   OR a.name ILIKE '%medical%' 
   OR a.name ILIKE '%health%' 
   OR a.name ILIKE '%auto%' 
   OR a.name ILIKE '%car%'
ORDER BY industry, customer_name;

-- Part b) Identify channels to deactivate in each region
-- This query identifies the least used marketing channels in each region.
-- The results help determine which channels to deactivate due to low engagement.
SELECT 
    r."name" AS region, 
    we.channel AS least_used_channel, 
    COUNT(we.channel) AS channel_count
FROM web_events we
JOIN accounts a ON we.account_id = a.id
JOIN sales_reps sr ON a.sales_rep_id = sr.id
JOIN region r ON sr.region_id = r.id
WHERE r."name" IN ('Midwest', 'Southeast', 'West', 'Northeast')
GROUP BY r."name", we.channel
ORDER BY r."name", channel_count ASC;
