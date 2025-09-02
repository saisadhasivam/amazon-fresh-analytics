-- ============================================================
-- Amazon Fresh Analytics - Main Script
-- End-to-End SQL (Phases 1–14)
-- ============================================================

-- ======================
-- 1. Database Setup
-- ======================
DROP DATABASE IF EXISTS amazon_fresh_analytics;
CREATE DATABASE amazon_fresh_analytics;
USE amazon_fresh_analytics;

-- ======================
-- 2. Table Creation
-- ======================

CREATE TABLE Customers (
    CustomerID VARCHAR(36) PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    Gender VARCHAR(10),
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100),
    SignupDate DATE,
    PrimeMember VARCHAR(3) DEFAULT 'No'
);

CREATE TABLE Suppliers (
    SupplierID VARCHAR(36) PRIMARY KEY,
    SupplierName VARCHAR(100),
    City VARCHAR(100),
    ContactNumber VARCHAR(15)
);

CREATE TABLE Products (
    ProductID VARCHAR(36) PRIMARY KEY,
    ProductName VARCHAR(150),
    Category VARCHAR(100),
    SubCategory VARCHAR(100),
    PricePerUnit DECIMAL(10,2),
    StockQuantity INT,
    SupplierID VARCHAR(36),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

CREATE TABLE Orders (
    OrderID VARCHAR(36) PRIMARY KEY,
    CustomerID VARCHAR(36),
    OrderDate DATE,
    OrderAmount DECIMAL(10,2),
    DeliveryFee DECIMAL(10,2),
    DiscountApplied DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Order_Details (
    OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID VARCHAR(36),
    ProductID VARCHAR(36),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    Discount DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Reviews (
    ReviewID VARCHAR(36) PRIMARY KEY,
    ProductID VARCHAR(36),
    CustomerID VARCHAR(36),
    Rating TINYINT CHECK (Rating BETWEEN 1 AND 5),
    ReviewText TEXT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- ======================
-- 3. Data Import
-- ======================
-- NOTE: Replace '/path/to/file.csv' with actual file paths on your system.

LOAD DATA INFILE '/path/to/customers.csv'
INTO TABLE Customers
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/path/to/suppliers.csv'
INTO TABLE Suppliers
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/path/to/products.csv'
INTO TABLE Products
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/path/to/orders.csv'
INTO TABLE Orders
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/path/to/order_details.csv'
INTO TABLE Order_Details
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/path/to/reviews.csv'
INTO TABLE Reviews
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- ======================
-- 4. Queries by Task
-- ======================

-- Task 3: Customers from a specific city
SELECT * FROM Customers WHERE City = 'East Ronald';

-- Task 3: Products under Fruits
SELECT * FROM Products WHERE Category = 'Fruits';

-- Task 4: Customers with constraints already defined in CREATE TABLE above

-- Task 5: Insert Products
INSERT INTO Products (ProductID, ProductName, Category, SubCategory, PricePerUnit, StockQuantity, SupplierID)
VALUES 
('P101', 'Organic Apple', 'Fruits', 'Fresh Fruits', 120, 500, 'S001'),
('P102', 'Brown Bread', 'Bakery', 'Breads', 45, 300, 'S002'),
('P103', 'Almond Milk', 'Dairy', 'Milk Substitutes', 180, 200, 'S003');

-- Task 6: Update Product Stock
UPDATE Products
SET StockQuantity = 600
WHERE ProductID = 'P101';

-- Task 7: Delete Supplier
DELETE FROM Suppliers WHERE City = 'South Debra';

-- Task 8: Constraints (already added in CREATE TABLE, re-added here for clarity)
ALTER TABLE Reviews ADD CONSTRAINT chk_rating CHECK (Rating BETWEEN 1 AND 5);
ALTER TABLE Customers MODIFY PrimeMember VARCHAR(3) DEFAULT 'No';

-- Task 9: Clauses & Aggregations
SELECT * FROM Orders WHERE OrderDate > '2024-01-01';

SELECT p.ProductName, ROUND(AVG(r.Rating),2) AS avg_rating
FROM Reviews r JOIN Products p ON r.ProductID = p.ProductID
GROUP BY p.ProductName
HAVING AVG(r.Rating) > 4;

SELECT p.ProductName, SUM(od.Quantity) AS total_units_sold
FROM Order_Details od JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY total_units_sold DESC;

-- Task 10: High Value Customers
SELECT c.CustomerID, c.Name,
       SUM(od.Quantity * od.UnitPrice - od.Discount) AS total_spending
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Order_Details od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.Name
HAVING total_spending > 5000
ORDER BY total_spending DESC;

-- Task 11: Complex Joins
SELECT o.OrderID, SUM(od.Quantity * od.UnitPrice - od.Discount) AS total_revenue
FROM Orders o JOIN Order_Details od ON o.OrderID = od.OrderID
GROUP BY o.OrderID;

SELECT c.CustomerID, c.Name, COUNT(o.OrderID) AS total_orders
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE YEAR(o.OrderDate) = 2025
GROUP BY c.CustomerID, c.Name
ORDER BY total_orders DESC;

SELECT s.SupplierName, SUM(p.StockQuantity) AS total_stock
FROM Suppliers s JOIN Products p ON s.SupplierID = p.SupplierID
GROUP BY s.SupplierID, s.SupplierName
ORDER BY total_stock DESC;

-- Task 12: Normalization (Optional: just structure, not dropping old Products here)
CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(100) UNIQUE
);

CREATE TABLE SubCategories (
    SubCategoryID INT AUTO_INCREMENT PRIMARY KEY,
    SubCategoryName VARCHAR(100),
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Task 13: Subqueries
SELECT p.ProductName, SUM(od.Quantity * od.UnitPrice - od.Discount) AS total_revenue
FROM Order_Details od JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY total_revenue DESC
LIMIT 3;

SELECT c.CustomerID, c.Name
FROM Customers c
WHERE c.CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Orders);

-- Task 14: Real-World Analysis
SELECT City, COUNT(*) AS prime_members
FROM Customers
WHERE PrimeMember = 'Yes'
GROUP BY City
ORDER BY prime_members DESC
LIMIT 5;

SELECT p.Category, COUNT(od.OrderDetailID) AS total_orders
FROM Order_Details od JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY total_orders DESC
LIMIT 3;

SELECT c.CustomerID, c.Name AS customer_name,
       ROUND(AVG(o.OrderAmount),2) AS avg_order_value
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.Name
ORDER BY avg_order_value DESC
LIMIT 10;

-- ============================================================
-- End of Main Script
-- ============================================================