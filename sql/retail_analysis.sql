CREATE DATABASE retail;
USE retail;

CREATE TABLE sales (
    order_id INT,
    order_date DATE,
    customer_name VARCHAR(100),
    product_name VARCHAR(100),
    category VARCHAR(50),
    region VARCHAR(50),
    quantity INT,
    sales DECIMAL(10,2),
    profit DECIMAL(10,2),
    discount DECIMAL(5,2)
);

INSERT INTO sales VALUES
(1,'2024-01-05','Amit Sharma','Office Chair','Furniture','West',1,3500,1000,0.10),
(2,'2024-01-10','Neha Verma','Printer','Technology','East',1,18000,3000,0.05),
(3,'2024-01-15','Rahul Singh','Notebook','Stationery','South',10,500,200,0.00),
(4,'2024-02-05','Amit Sharma','Table','Furniture','West',1,8000,2000,0.15),
(5,'2024-02-10','Neha Verma','Laptop','Technology','East',1,55000,8000,0.10),
(6,'2024-02-15','Rahul Singh','Pen','Stationery','South',20,600,150,0.05),
(7,'2024-03-01','Amit Sharma','Monitor','Technology','North',1,12000,2500,0.08),
(8,'2024-03-05','Neha Verma','Office Chair','Furniture','East',2,7000,1800,0.12),
(9,'2024-03-10','Rahul Singh','Notebook','Stationery','South',15,750,300,0.00),
(10,'2024-03-15','Amit Sharma','Desk','Furniture','West',1,15000,3500,0.10);

-- Retrieve total sales, profit, and quantity overall
SELECT 
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity
FROM sales;

-- Calculate month-wise revenue and growth percentage
SELECT 
    month,
    revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY month)) /
        LAG(revenue) OVER (ORDER BY month) * 100, 2
    ) AS growth_percentage
FROM (
    SELECT 
        DATE_FORMAT(order_date,'%Y-%m') AS month,
        SUM(sales) AS revenue
    FROM sales
    GROUP BY month
) t
ORDER BY month;


-- Identify top 10 profitable products
SELECT 
    product_name,
    SUM(profit) AS total_profit
FROM sales
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 10;

-- Rank region-wise sales and profit
SELECT 
    region,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    RANK() OVER (ORDER BY SUM(profit) DESC) AS profit_rank
FROM sales
GROUP BY region;

-- Calculate category-wise margin percentage
SELECT 
    category,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS margin_percentage
FROM sales
GROUP BY category;

-- Find customer with highest lifetime value
SELECT 
    customer_name,
    SUM(sales) AS lifetime_value
FROM sales
GROUP BY customer_name
ORDER BY lifetime_value DESC
LIMIT 1;

-- Analyze discount versus profit impact
SELECT 
    discount,
    ROUND(AVG(profit),2) AS avg_profit
FROM sales
GROUP BY discount
ORDER BY discount;p