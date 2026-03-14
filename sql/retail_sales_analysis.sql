-- Retail Sales SQL Analysis Project
-- Tools: MySQL
-- Dataset: Retail Sales Dataset
-- Author: Salahuddin K M

-- Creating the database and using it
CREATE DATABASE retail_sales_db;

USE retail_sales_db;

-- Tables creation

-- Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(10),
    birth_date DATE,
    city VARCHAR(50),
    join_date DATE
);

-- Products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    unit_price DECIMAL(10,2),
    cost_price DECIMAL(10,2)
);

-- Stores Table
CREATE TABLE stores (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100),
    city VARCHAR(50),
    region VARCHAR(50)
);

-- Transactions table
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    transaction_date DATE,
    customer_id INT,
    product_id INT,
    store_id INT,
    quantity INT,
    discount DECIMAL(5,2),
    payment_method VARCHAR(50)
);

SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM stores;
SELECT COUNT(*) FROM transactions;

-- Sales Master Table(analysis dataset)
CREATE TABLE sales_analysis AS
SELECT
t.ï»¿transaction_id,
t.transaction_date,
MONTH(t.transaction_date) AS month,
p.ProductName,
p.Category,
s.Region,
t.quantity,
p.UnitPrice,
p.CostPrice,
t.discount,
(t.quantity * p.UnitPrice * (1 - t.discount)) AS revenue,
((p.UnitPrice - p.CostPrice) * t.quantity) AS profit
FROM transactions t
JOIN products p ON t.product_id = p.ProductID
JOIN stores s ON t.store_id = s.StoreID;

-- Master Dataset view
CREATE VIEW sales_master AS
SELECT
t.ï»¿transaction_id,
t.transaction_date,
t.customer_id,
p.ProductName,
p.Category,
s.Region,
t.quantity,
p.UnitPrice,
t.discount,
(t.quantity * p.UnitPrice * (1 - t.discount)) AS revenue
FROM transactions t
JOIN products p ON t.product_id = p.ProductID
JOIN stores s ON t.store_id = s.StoreID;

-- KPI Metrics

-- Total Revenue
SELECT CEIL(SUM(revenue)) AS total_revenue FROM sales_master;

-- Total Transactions
SELECT COUNT(*) AS total_transactions FROM transactions;

-- Total Quantity Sold
SELECT SUM(quantity) AS total_quantities_sold FROM transactions;

-- Sales by Region

SELECT
region,
CEIL(SUM(revenue)) AS total_sales
FROM sales_master
GROUP BY region
ORDER BY total_sales DESC;

-- Sales by Category

SELECT
category,
CEIL(SUM(revenue)) AS total_sales
FROM sales_master
GROUP BY category
ORDER BY total_sales DESC;

-- Monthly Sales Trend

SELECT
MONTH(transaction_date) AS month,
CEIL(SUM(revenue)) AS monthly_sales
FROM sales_master
GROUP BY month
ORDER BY month;

-- Top 10 Products

SELECT
ProductName,
CEIL(SUM(revenue)) AS total_sales
FROM sales_master
GROUP BY ProductName
ORDER BY total_sales DESC
LIMIT 10;
