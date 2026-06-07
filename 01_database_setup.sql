-- ==============================================================================
-- 1. STAR SCHEMA ARCHITECTURE & DATA QUALITY RESTRICTIONS
-- ==============================================================================

-- Customer Dimension Table
CREATE TABLE dim_users (
    user_id VARCHAR(50) PRIMARY KEY,
    location VARCHAR(100)
);

-- Product Catalog Dimension Table
CREATE TABLE dim_products (
    product_id VARCHAR(50) PRIMARY KEY,
    category VARCHAR(100),
    subcategory VARCHAR(100),
    brand VARCHAR(100)
);

-- Vendor Dimension Table
CREATE TABLE dim_sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_rating NUMERIC(3, 1)
);

-- Central Fact Table (Transactional & Financial Metrics)
CREATE TABLE fact_orders (
    order_id SERIAL PRIMARY KEY,
    user_id VARCHAR(50) REFERENCES dim_users(user_id),
    product_id VARCHAR(50) REFERENCES dim_products(product_id),
    seller_id VARCHAR(50) REFERENCES dim_sellers(seller_id),
    price NUMERIC(10, 2),
    discount NUMERIC(5, 2),
    final_price NUMERIC(10, 2),
    rating NUMERIC(3, 1),
    review_count INT,
    stock_at_purchase INT,
    purchase_date DATE,
    shipping_time_days INT,
    device VARCHAR(50),
    payment_method VARCHAR(50),
    is_returned BOOLEAN,
    delivery_status VARCHAR(50),
    CONSTRAINT chk_price_logic CHECK (final_price <= price) -- Data Quality Guardrail
);
