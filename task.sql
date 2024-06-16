-- database: /path/to/database.db
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    email TEXT
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT,
    price REAL
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    price REAL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

--Query 1
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(o.order_id) AS total_orders
FROM
    customers c
LEFT JOIN
    orders o ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id, c.first_name, c.last_name, c.email
ORDER BY
    total_orders DESC;

--Query 2
SELECT
    p.product_id,
    p.product_name
FROM
    products p
LEFT JOIN
    order_items oi ON p.product_id = oi.product_id
WHERE
    oi.order_item_id IS NULL;

--Query 3
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    SUM(oi.quantity * oi.price) AS total_spent
FROM
    customers c
JOIN
    orders o ON c.customer_id = o.customer_id
JOIN
    order_items oi ON o.order_id = oi.order_id
WHERE
    o.order_date >= DATE('now', '-1 month')
GROUP BY
    c.customer_id, c.first_name, c.last_name, c.email
ORDER BY
    total_spent DESC
LIMIT 1;