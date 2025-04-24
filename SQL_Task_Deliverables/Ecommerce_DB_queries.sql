-- 1. Create Tables
-- Create customers table
CREATE TABLE IF NOT EXISTS customers (
    customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_name TEXT,
    email TEXT,
    phone TEXT,
    address TEXT
);

-- Create products table
CREATE TABLE IF NOT EXISTS products (
    product_id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_name TEXT,
    category TEXT,
    price REAL
);

-- Create orders table
CREATE TABLE IF NOT EXISTS orders (
    order_id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER,
    order_date TEXT,
    total_amount REAL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Create order_details table
CREATE TABLE IF NOT EXISTS order_details (
    order_detail_id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    price REAL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 2. Insert Sample Data
-- Insert customers
INSERT INTO customers (customer_name, email, phone, address) 
VALUES 
('John Doe', 'johndoe@example.com', '1234567890', '123 Elm St'),
('Jane Smith', 'janesmith@example.com', '0987654321', '456 Oak St');

-- Insert products
INSERT INTO products (product_name, category, price) 
VALUES 
('Laptop', 'Electronics', 799.99),
('Phone', 'Electronics', 599.99),
('Headphones', 'Accessories', 129.99);

-- Insert orders
INSERT INTO orders (customer_id, order_date, total_amount) 
VALUES 
(1, '2025-04-20 14:30:00', 899.98),
(2, '2025-04-22 10:15:00', 729.98);

-- Insert order details
INSERT INTO order_details (order_id, product_id, quantity, price) 
VALUES 
(1, 1, 1, 799.99),
(1, 3, 1, 129.99),
(2, 2, 1, 599.99),
(2, 3, 1, 129.99);

-- 3. Data Analysis Queries

-- Query 1: Get the total amount spent by each customer, ordered by highest spender
SELECT c.customer_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;

-- Query 2: Get all orders along with the customer names and product names
SELECT o.order_id, c.customer_name, p.product_name, od.quantity
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN order_details od ON o.order_id = od.order_id
INNER JOIN products p ON od.product_id = p.product_id;

-- Query 3: Get customers who spent more than the average order total
SELECT customer_name
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    WHERE total_amount > (SELECT AVG(total_amount) FROM orders)
);

-- Query 4: Get the total quantity of products ordered and average price per product
SELECT p.product_name, SUM(od.quantity) AS total_quantity, AVG(od.price) AS avg_price
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_name;

-- 4. Create View for Analysis
Drop VIEW IF EXISTS customer_spending;
CREATE VIEW customer_spending AS
SELECT c.customer_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

-- Query to check the view
SELECT * FROM customer_spending;

-- 5. Create Index for Optimization
Drop INDEX IF EXISTS idx_customer_id;

CREATE INDEX idx_customer_id ON orders(customer_id);

