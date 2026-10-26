-- PROJECT

CREATE DATABASE inventory_db;
USE inventory_db;
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    price DECIMAL(10,2),
    stock_qty INT,
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

INSERT INTO products (product_name, price, stock_qty, supplier_id) VALUES
('Laptop',50000,10,1),
('Mouse',500,50,1),
('Keyboard',1500,30,1),
('Monitor',12000,15,2),
('Phone',30000,20,2),
('Charger',800,40,3),
('Headphones',2000,25,3),
('Shoes',2500,12,4),
('Bag',1200,8,4),
('Watch',5000,18,5);

select * from products;

CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(100),
    contact VARCHAR(15)
);

INSERT INTO suppliers (supplier_name, contact) VALUES
('ABC Traders','1111111111'),
('XYZ Supplies','2222222222'),
('Global Mart','3333333333'),
('Fresh Foods','4444444444'),
('Tech Source','5555555555'),
('Prime Goods','6666666666'),
('Quick Supply','7777777777'),
('Urban Traders','8888888888'),
('Metro Supply','9999999999'),
('Star Distributors','1010101010');

select * from suppliers;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100),
    email VARCHAR(100)
);

INSERT INTO customers (customer_name, email) VALUES
('Amit','amit@gmail.com'),
('Rahul','rahul@gmail.com'),
('Priya','priya@gmail.com'),
('Sneha','sneha@gmail.com'),
('Vikas','vikas@gmail.com'),
('Neha','neha@gmail.com'),
('Rohit','rohit@gmail.com'),
('Pooja','pooja@gmail.com'),
('Karan','karan@gmail.com'),
('Anjali','anjali@gmail.com');

select * from customers;

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO orders (customer_id, order_date) VALUES
(1,'2026-04-01'),
(2,'2026-04-02'),
(3,'2026-04-03'),
(4,'2026-04-04'),
(5,'2026-04-05'),
(6,'2026-04-06'),
(7,'2026-04-07'),
(8,'2026-04-08'),
(9,'2026-04-09'),
(10,'2026-04-10');

select * from orders;

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1,1,1),
(2,2,2),
(3,3,1),
(4,4,1),
(5,5,2),
(6,6,3),
(7,7,1),
(8,8,2),
(9,9,1),
(10,10,1);

select * from order_items;

-- 1. List all products along with their supplier names
SELECT p.product_name, s.supplier_name
FROM products p
JOIN suppliers s 
ON p.supplier_id = s.supplier_id;

-- 2. Which products have stock less than 5 units?
SELECT product_name, stock_qty
FROM products
WHERE stock_qty < 5;

-- 3. What is the total sales amount of all orders?
SELECT p.product_name, SUM(p.price * oi.quantity) AS total_sales
FROM order_items oi
JOIN products p 
ON oi.product_id = p.product_id
group by p.product_name
order by total_sales desc;

-- 4. Which products are the best-selling products?
SELECT p.product_name, SUM(p.price * oi.quantity) AS total_sold
FROM order_items oi
JOIN products p 
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
limit 1;

-- 5. How many orders has each customer placed?
SELECT c.customer_name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o 
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
order by total_orders desc;

-- 6. Show order details with product names and quantities
SELECT o.order_id, p.product_name, oi.quantity
FROM orders o
JOIN order_items oi 
ON o.order_id = oi.order_id
JOIN products p 
ON oi.product_id = p.product_id;

-- 7. Which orders were placed in the last 7 days?
SELECT *
FROM orders
WHERE order_date >= CURDATE() - INTERVAL 7 DAY;

-- 8. Who are the top 3 customers based on number of orders?
SELECT c.customer_name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o 
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_orders DESC
LIMIT 3;

-- 9. What is the total revenue generated per product?
SELECT p.product_name, SUM(p.price * oi.quantity) AS revenue
FROM products p
JOIN order_items oi 
ON p.product_id = oi.product_id
GROUP BY p.product_name
order by revenue desc;

-- 10. How many products are supplied by each supplier?
SELECT s.supplier_name, COUNT(p.product_id) AS total_products
FROM suppliers s
JOIN products p 
ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_name;

-- 11. Which products have never been sold?
SELECT p.product_name
FROM products p
LEFT JOIN order_items oi 
ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- 12. What is the total amount for each order?
SELECT o.order_id, SUM(p.price * oi.quantity) AS order_total
FROM orders o
JOIN order_items oi 
ON o.order_id = oi.order_id
JOIN products p 
ON oi.product_id = p.product_id
GROUP BY o.order_id;

-- 13. What is the monthly sales report?
SELECT MONTH(o.order_date) AS month,
SUM(p.price * oi.quantity) AS total_sales
FROM orders o
JOIN order_items oi 
ON o.order_id = oi.order_id
JOIN products p 
ON oi.product_id = p.product_id
GROUP BY MONTH(o.order_date);

-- 14. What is the average order value?
SELECT AVG(order_total) 
FROM (
    SELECT o.order_id, SUM(p.price * oi.quantity) AS order_total
    FROM orders o
    JOIN order_items oi 
    ON o.order_id = oi.order_id
    JOIN products p 
    ON oi.product_id = p.product_id
    GROUP BY o.order_id) as temp;      -- Nested query

-- 15. Which is the most expensive product?
SELECT product_name, price
FROM products
ORDER BY price DESC
LIMIT 1;

-- 16. Which is the least selling product?
SELECT p.product_name, SUM(oi.quantity) AS total_sold
FROM products p
JOIN order_items oi 
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_sold ASC
LIMIT 1;

-- 17. Which customers have not placed any orders?
SELECT c.customer_name
FROM customers c
LEFT JOIN orders o 
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 18. What is the total quantity sold by each supplier?
SELECT s.supplier_name, SUM(oi.quantity) AS total_quantity
FROM suppliers s
JOIN products p 
ON s.supplier_id = p.supplier_id
JOIN order_items oi 
ON p.product_id = oi.product_id
GROUP BY s.supplier_name;

-- 19. What is the running total of sales over time?
SELECT o.order_date,
SUM(p.price * oi.quantity) OVER (ORDER BY o.order_date) AS running_total
FROM orders o
JOIN order_items oi 
ON o.order_id = oi.order_id
JOIN products p 
ON oi.product_id = p.product_id;

-- 20. How are products ranked based on total sales?
SELECT p.product_name,
SUM(p.price * oi.quantity) AS total_sales,
RANK() OVER (ORDER BY SUM(p.price * oi.quantity) DESC) AS rank_no
FROM products p
JOIN order_items oi 
ON p.product_id = oi.product_id
GROUP BY p.product_name;
