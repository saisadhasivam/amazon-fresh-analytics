# Amazon Fresh Analytics 

This project analyzes **Amazon Fresh customer and sales data** using SQL.  
It covers **database design, data normalization, complex queries, and insights** into customer behavior, sales, and product performance.  


## Project Introduction  

### Problem Context  
Amazon Fresh, like many e-commerce platforms, generates a **huge volume of customer and sales data** every day. This includes:  
- Customer demographics & subscription status (Prime vs non-Prime)  
- Product catalog with categories, subcategories, suppliers, and stock levels  
- Orders and order details (prices, discounts, delivery fees, etc.)  
- Customer reviews and product ratings  

Despite having this rich dataset, the challenge is that **raw transactional data is scattered across multiple tables**. Without proper structuring, normalization, and advanced queries, it becomes very hard to answer critical business questions such as:  
- Who are our top customers and what are their spending patterns?  
- Which products and categories drive the most sales and revenue?  
- How do Prime members differ from regular customers?  
- Which suppliers and products need better stock management?  
- What customer feedback trends (ratings/reviews) reveal product quality?  

---

### Objective of the Project  
The goal of this project is to design and implement a **comprehensive SQL-based analytics system** for Amazon Fresh data. This includes:  
1. **Database Design & Normalization** – structuring raw data into relational tables (3NF) for efficiency and consistency.  
2. **Complex SQL Queries** – answering real-world business questions with joins, aggregations, subqueries, and constraints.  
3. **Customer Insights** – identifying top customers, order behavior, and loyalty patterns.  
4. **Product & Category Performance** – ranking products/categories by revenue, sales volume, and ratings.  
5. **Supplier Analysis** – understanding supplier contributions and stock availability.  
6. **Business-ready Insights** – generating KPIs and dashboards (via PPT) for decision-making.  

---

### Why This Matters  
For a platform like Amazon Fresh, **data-driven decisions** directly impact profitability and customer satisfaction. By analyzing this dataset, businesses can:  
- Improve inventory management and avoid stock-outs.  
- Tailor promotions to high-value customers.  
- Enhance customer experience by focusing on top-rated products.  
- Negotiate effectively with suppliers based on performance.  
- Increase revenue by doubling down on best-selling categories.  

---

In short, this project bridges the gap between **raw transactional data** and **strategic business insights**, showing how SQL alone can unlock powerful analytics. 

---

## Entity-Relationship Diagram (ERD)
![ERD](amazon_fresh_erd.png)

---

## Dataset Overview
The project uses **6 CSV files** as input datasets:

- **Customers** – customer demographics, location, Prime membership.  
- **Orders** – order details, dates, amounts, delivery fees.  
- **Order_Details** – line items for each order, quantities, unit prices, discounts.  
- **Products** – product catalog with categories, subcategories, suppliers.  
- **Suppliers** – supplier details and locations.  
- **Reviews** – customer reviews with ratings and text feedback.  

---

## SQL Workflow
The `amazon_fresh_main.sql` script includes:

1. **Database Setup**
   - Create tables (Customers, Orders, Order_Details, Products, Suppliers, Reviews).
   - Normalization of `Products` table (to 3NF: Categories & SubCategories).

2. **Data Insertion**
   - Insert sample records for testing.
   - Import CSV datasets.

3. **Basic Queries**
   - Select customers from a specific city.  
   - Fetch products by category.  
   - Update product stock & delete records conditionally.  

4. **Constraints**
   - Ensure ratings are between 1 and 5.  
   - Default value for PrimeMember = "No".  

5. **Complex Aggregations & Joins**
   - Orders placed after a given date.  
   - Products with average rating > 4.  
   - Rank products by total sales.  
   - Total spending per customer.  
   - Identify high-value customers.  
   - Total revenue per order.  
   - Customers with most orders (2025).  
   - Supplier with most stock.  

6. **Analytical Insights**
   - Top 3 products by revenue.  
   - Customers who never placed an order.  
   - Cities with highest Prime concentration.  
   - Top 3 most frequently ordered categories.  

---

## Key Insights
- **Top products by revenue**: Fall Snack, Close Vegetable, Study Snack.  
- **High-value customers** spend **> ₹70K**, dominated by Michael Garcia & Kristopher Douglas.  
- **Prime Members** are most concentrated in New David, Josephport, East Kristine.  
- **Most ordered categories**: Meat, Fruits, Snacks.  
- Some customers exist in the database but **never placed orders** (potential churn).  

---

## Deliverables
- `amazon_fresh_main.sql` → End-to-end SQL code.  
- `amazon-fresh-analytics.pdf` → Presentation with query screenshots & insights.  
- `amazon_fresh_erd.png` → ERD for database structure.  
- `data/` → Reference CSVs for reproducibility.  

---

## How to Run
1. Clone this repository:
   ```bash
   git clone https://github.com/saisadhasivam/amazon-fresh-analytics.git
   cd amazon-fresh-analytics
