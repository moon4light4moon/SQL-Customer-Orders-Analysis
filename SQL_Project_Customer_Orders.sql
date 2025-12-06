
-- ------------------------------------------------------------
-- 1. Drop existing tables (for clean re-run)
-- ------------------------------------------------------------
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS categories;

-- ------------------------------------------------------------
-- 2. Customers table
-- ------------------------------------------------------------
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    full_name   TEXT NOT NULL,
    city        TEXT,
    segment     TEXT,         -- Customer segment: Retail / Corporate / Online
    signup_date TEXT          -- Customer registration date
);

-- ------------------------------------------------------------
-- 3. Categories table (maps product → category)
-- ------------------------------------------------------------
CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    product     TEXT NOT NULL,
    category    TEXT NOT NULL  -- Example: Electronics / Accessories / Home Office
);

-- ------------------------------------------------------------
-- 4. Orders table
-- ------------------------------------------------------------
CREATE TABLE orders (
    order_id    INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date  TEXT NOT NULL,
    product     TEXT NOT NULL,
    quantity    INTEGER NOT NULL,
    unit_price  REAL NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ------------------------------------------------------------
-- 5. Insert sample data: customers
-- ------------------------------------------------------------
INSERT INTO customers (customer_id, full_name, city, segment, signup_date) VALUES
(1, 'Anna Novak',        'Kyiv',      'Online',    '2023-01-10'),
(2, 'Oleh Petrenko',     'Lviv',      'Retail',    '2023-02-05'),
(3, 'Iryna Bondar',      'Kyiv',      'Corporate', '2023-02-20'),
(4, 'Maksym Shevchenko', 'Odessa',    'Online',    '2023-03-01'),
(5, 'Daria Melnyk',      'Kharkiv',   'Retail',    '2023-03-15'),
(6, 'Yaroslav Sytnyk',   'Dnipro',    'Online',    '2023-04-01'),
(7, 'Viktoria Koval',    'Lviv',      'Corporate', '2023-04-10'),
(8, 'Andrii Hutsul',     'Kyiv',      'Online',    '2023-05-01'),
(9, 'Olena Kravets',     'Odessa',    'Retail',    '2023-05-20'),
(10,'Roman Polishchuk',  'Kharkiv',   'Corporate', '2023-06-01');

-- ------------------------------------------------------------
-- 6. Insert sample data: categories
-- ------------------------------------------------------------
INSERT INTO categories (category_id, product, category) VALUES
(1, 'Laptop',           'Electronics'),
(2, 'Smartphone',       'Electronics'),
(3, 'Headphones',       'Accessories'),
(4, 'Keyboard',         'Accessories'),
(5, 'Mouse',            'Accessories'),
(6, 'Monitor',          'Electronics'),
(7, 'Office Chair',     'Home Office'),
(8, 'Webcam',           'Accessories');

-- ------------------------------------------------------------
-- 7. Insert sample data: orders
-- ------------------------------------------------------------
INSERT INTO orders (order_id, customer_id, order_date, product, quantity, unit_price) VALUES
(1,  1, '2023-03-01', 'Laptop',       1, 1200.00),
(2,  1, '2023-03-15', 'Mouse',        2,   25.00),
(3,  2, '2023-03-20', 'Smartphone',   1,  800.00),
(4,  2, '2023-04-01', 'Headphones',   1,   60.00),
(5,  3, '2023-04-05', 'Monitor',      2,  250.00),
(6,  3, '2023-04-18', 'Keyboard',     1,   45.00),
(7,  4, '2023-04-20', 'Laptop',       1, 1100.00),
(8,  4, '2023-04-25', 'Office Chair', 1,  200.00),
(9,  5, '2023-05-02', 'Smartphone',   1,  750.00),
(10, 5, '2023-05-10', 'Mouse',        1,   25.00),
(11, 6, '2023-05-15', 'Headphones',   2,   55.00),
(12, 6, '2023-05-22', 'Webcam',       1,   70.00),
(13, 7, '2023-06-01', 'Laptop',       1, 1300.00),
(14, 7, '2023-06-10', 'Monitor',      1,  260.00),
(15, 8, '2023-06-12', 'Keyboard',     1,   40.00),
(16, 8, '2023-06-18', 'Mouse',        1,   20.00),
(17, 9, '2023-06-20', 'Office Chair', 2,  190.00),
(18, 9, '2023-06-25', 'Headphones',   1,   65.00),
(19,10, '2023-07-01', 'Smartphone',   1,  820.00),
(20,10, '2023-07-05', 'Webcam',       1,   75.00);

-- ------------------------------------------------------------
-- 8. Basic selects (optional for debugging)
-- ------------------------------------------------------------
SELECT * FROM customers;
SELECT * FROM categories;
SELECT * FROM orders;

-- ------------------------------------------------------------
-- 9. Query 1: All customers
-- ------------------------------------------------------------
SELECT *
FROM customers;

-- ------------------------------------------------------------
-- 10. Query 2: All raw orders
-- ------------------------------------------------------------
SELECT
    order_id,
    customer_id,
    order_date,
    product,
    quantity,
    unit_price
FROM orders
ORDER BY order_date;

-- ------------------------------------------------------------
-- 11. Query 3: Orders with calculated order_amount
-- ------------------------------------------------------------
SELECT
    order_id,
    customer_id,
    order_date,
    product,
    quantity,
    unit_price,
    (quantity * unit_price) AS order_amount
FROM orders
ORDER BY order_date;

-- ------------------------------------------------------------
-- 12. Query 4: Total spent by each customer
-- ------------------------------------------------------------
SELECT
    o.customer_id,
    c.full_name,
    c.city,
    c.segment,
    SUM(o.quantity * o.unit_price) AS total_spent
FROM orders o
INNER JOIN customers c
    ON c.customer_id = o.customer_id
GROUP BY
    o.customer_id,
    c.full_name,
    c.city,
    c.segment
ORDER BY total_spent DESC;

-- ------------------------------------------------------------
-- 13. Query 5: Products with revenue above average
-- ------------------------------------------------------------
SELECT
    product,
    SUM(quantity * unit_price) AS product_revenue
FROM orders
GROUP BY product
HAVING
    SUM(quantity * unit_price) >
    (
        SELECT AVG(rev)
        FROM (
            SELECT SUM(quantity * unit_price) AS rev
            FROM orders
            GROUP BY product
        )
    )
ORDER BY product_revenue DESC;

-- ------------------------------------------------------------
-- 14. Query 6: Orders after May 1 with customer data
-- ------------------------------------------------------------
SELECT
    o.order_id,
    o.order_date,
    c.full_name,
    c.city,
    c.segment,
    o.product,
    o.quantity,
    o.unit_price,
    (o.quantity * o.unit_price) AS order_amount
FROM orders o
INNER JOIN customers c
    ON c.customer_id = o.customer_id
WHERE o.order_date >= '2023-05-01'
ORDER BY o.order_date;

-- ------------------------------------------------------------
-- 15. Query 7: Number of customers in each segment
-- ------------------------------------------------------------
SELECT
    segment,
    COUNT(*) AS customers_count
FROM customers
GROUP BY segment;

-- ------------------------------------------------------------
-- 16. Query 8: Average order amount by customer segment
-- ------------------------------------------------------------
SELECT
    c.segment,
    AVG(o.quantity * o.unit_price) AS avg_order_amount
FROM orders o
INNER JOIN customers c
    ON c.customer_id = o.customer_id
GROUP BY c.segment;

-- ------------------------------------------------------------
-- 17. Query 9: Full order list with customer data
-- ------------------------------------------------------------
SELECT
    o.order_id,
    o.order_date,
    c.full_name,
    c.city,
    o.product AS product_name,
    o.quantity,
    o.unit_price,
    (o.quantity * o.unit_price) AS order_amount
FROM orders o
INNER JOIN customers c
    ON c.customer_id = o.customer_id;

-- ------------------------------------------------------------
-- 18. Query 10: All customers including those without orders
-- ------------------------------------------------------------
SELECT
    c.customer_id,
    c.full_name,
    c.city,
    c.segment,
    COALESCE(SUM(o.quantity * o.unit_price), 0) AS total_spent
FROM customers c
LEFT JOIN orders o
    ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name, c.city, c.segment
ORDER BY total_spent DESC;
