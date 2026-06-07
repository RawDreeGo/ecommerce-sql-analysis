# 📈 E-Commerce Advanced SQL Analytics: 1M+ Operational Records

<!-- PROJECT BANNER PLACEHOLDER -->
![Project Cover Banner](./images/project_cover_banner.png)

## 🎯 Executive Summary
In the modern retail ecosystem, data redundancy and unoptimized data streams can drain company resources and mask critical financial leakage. This project showcases the end-to-end data engineering and business intelligence workflow of a **Data Analyst** acting across **Financial Control, Operations, and Growth Marketing**.

Operating on a high-volume Amazon retail dataset containing **over 1,000,000 raw transactional records**, I designed, implemented, and populated a highly optimized relational **Star Schema** data warehouse in PostgreSQL. Beyond database normalization and maintaining strict data quality constraints, this repository leverages high-performance window functions and advanced aggregations to deliver actionable, data-driven answers to complex corporate bottlenecks.

---

## 🚀 Key Business Problems Solved
This analytical suite directly targets three critical corporate challenges:
1. **User Retention & Omnichannel Loyalty:** Identifying exactly how many days a customer takes to make a repeat purchase across different platforms.
2. **Revenue Leakage Control:** Highlighting specific supplier-category combinations responsible for catastrophic item return rates.
3. **Cumulative Growth Velocity:** Providing corporate leadership with real-time running totals of revenue generation across major product segments to measure progress against annual benchmarks.

---
## 🛠️ Step-by-Step Implementation Guide

### Phase 1: Exploratory Data Inspection & Staging

Before writing a single line of DDL (Data Definition Language), a raw exploration of the source file is essential. Understanding data types, null tendencies, and column delimiters prevents schema failure down the line.

#### 1. Inspecting the Raw Source File
To evaluate the incoming structure, the raw comma-separated values (CSV) database file was inspected using a simple plain-text editor. 

![Raw CSV File Inspection](./images/Img001.png)

**Key Observations from the Raw File:**
* **Schema Design Mapping:** The file is a flat table containing mixed structural fields. Columns like `user_id`, `product_id`, and `seller_id` are combined with transactional metrics like `price` and `final_price` in a single line.
* **Data Types Identification:** Categorical entries (`category`, `subcategory`, `device`) appear as text, while tracking numbers and counts (`review_count`, `stock`) are structured as discrete integers.
* **Data Quality Constraints:** Currency fields feature precise decimals, demanding numeric casting rather than floats to maintain absolute financial precision. This inspection directly guided the creation of our optimized staging schema.
