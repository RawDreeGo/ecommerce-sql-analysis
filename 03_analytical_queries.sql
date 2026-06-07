-- ==============================================================================
-- 3. ADVANCED BUSINESS INTELLIGENCE METRICS
-- ==============================================================================

-- QUERY 1: Customer Retention & Repurchase Cycles (Omnichannel Analysis)
WITH user_purchase_sequences AS (
    SELECT 
        user_id,
        purchase_date,
        device,
        LAG(purchase_date) OVER(PARTITION BY user_id ORDER BY purchase_date) AS previous_purchase_date
    FROM fact_orders
    WHERE is_returned = FALSE 
)
SELECT 
    device,
    COUNT(*) AS total_recurrent_transactions,
    ROUND(AVG(purchase_date - previous_purchase_date), 1) AS avg_days_between_purchases
FROM user_purchase_sequences
WHERE previous_purchase_date IS NOT NULL 
GROUP BY device
ORDER BY total_recurrent_transactions DESC;


-- QUERY 2: Revenue Leakage Analysis (Financial Control)
SELECT 
    p.category,
    p.brand,
    COUNT(f.order_id) AS total_orders,
    SUM(CASE WHEN f.is_returned = TRUE THEN 1 ELSE 0 END) AS total_returns,
    ROUND((SUM(CASE WHEN f.is_returned = TRUE THEN 1 ELSE 0 END)::NUMERIC / COUNT(f.order_id)) * 100, 2) AS return_rate_pct,
    SUM(CASE WHEN f.is_returned = TRUE THEN f.final_price ELSE 0 END) AS lost_revenue_usd
FROM fact_orders f
JOIN dim_products p ON f.product_id = p.product_id
GROUP BY p.category, p.brand
HAVING COUNT(f.order_id) > 500 
ORDER BY lost_revenue_usd DESC
LIMIT 10;


-- QUERY 3: Commercial Growth Trajectory (Running Total Analysis)
WITH monthly_sales AS (
    SELECT 
        p.category,
        DATE_TRUNC('month', f.purchase_date)::DATE AS month_date,
        SUM(f.final_price) AS monthly_revenue
    FROM fact_orders f
    JOIN dim_products p ON f.product_id = p.product_id
    WHERE f.is_returned = FALSE 
    GROUP BY p.category, DATE_TRUNC('month', f.purchase_date)::DATE
)
SELECT 
    category,
    month_date,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(SUM(monthly_revenue) OVER(PARTITION BY category ORDER BY month_date), 2) AS historical_running_total
FROM monthly_sales
ORDER BY category, month_date;
