-- ==============================================================================
-- 2. DATA NORMALIZATION & BULK INGESTION PIPELINE
-- ==============================================================================

-- Populate Users Dimension (Handling duplicates via aggregation for Data Quality)
INSERT INTO dim_users (user_id, location)
SELECT user_id, MAX(location) AS location
FROM staging_amazon_sales
GROUP BY user_id;

-- Populate Products Dimension (Handling categorical inconsistencies)
INSERT INTO dim_products (product_id, category, subcategory, brand)
SELECT product_id, MAX(category), MAX(subcategory), MAX(brand)
FROM staging_amazon_sales
GROUP BY product_id;

-- Populate Sellers Dimension 
INSERT INTO dim_sellers (seller_id, seller_rating)
SELECT seller_id, MAX(seller_rating) 
FROM staging_amazon_sales 
GROUP BY seller_id;

-- Populate Central Fact Table linking all normalized dimensions
INSERT INTO fact_orders (
    user_id, product_id, seller_id, price, discount, final_price, 
    rating, review_count, stock_at_purchase, purchase_date, 
    shipping_time_days, device, payment_method, is_returned, delivery_status
)
SELECT 
    user_id, product_id, seller_id, price, discount, final_price, 
    rating, review_count, stock, purchase_date, 
    shipping_time_days, device, payment_method, is_returned, delivery_status
FROM staging_amazon_sales;
