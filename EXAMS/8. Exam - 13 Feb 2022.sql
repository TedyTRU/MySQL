CREATE DATABASE online_store;
USE online_store;

-- Section 1:
#1
CREATE TABLE brands (
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE categories (
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE reviews (
id INT PRIMARY KEY AUTO_INCREMENT,
content TEXT,
rating DECIMAL(10, 2) NOT NULL,
picture_url VARCHAR(80) NOT NULL,
published_at DATETIME NOT NULL
);

CREATE TABLE customers (
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(20) NOT NULL,
last_name VARCHAR(20) NOT NULL,
phone VARCHAR(30) NOT NULL UNIQUE,
address VARCHAR(60) NOT NULL,
discount_card BIT(1) NOT NULL
);

CREATE TABLE products (
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40) NOT NULL,
price DECIMAL(19, 2) NOT NULL,
quantity_in_stock INT,
`description` TEXT,
brand_id INT NOT NULL,
category_id INT NOT NULL,
review_id INT,

CONSTRAINT fk_products_brands
FOREIGN KEY (brand_id)
REFERENCES brands (id),

CONSTRAINT fk_products_categories
FOREIGN KEY (category_id)
REFERENCES categories (id),

CONSTRAINT fk_products_reviews
FOREIGN KEY (review_id)
REFERENCES reviews (id)
);

CREATE TABLE orders (
id INT PRIMARY KEY AUTO_INCREMENT,
order_datetime DATETIME NOT NULL,
customer_id INT NOT NULL,

CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id)
REFERENCES customers (id)
);

CREATE TABLE orders_products (
order_id INT, 
product_id INT,

CONSTRAINT fk_orders_products_orders
FOREIGN KEY (order_id)
REFERENCES orders (id),

CONSTRAINT fk_orders_products_products
FOREIGN KEY (product_id)
REFERENCES products (id)
);

-- Section 2: 
#2
SELECT EXTRACT(DAY FROM published_at) FROM reviews;
SELECT DAY(published_at) FROM reviews;

SELECT * FROM reviews;
SELECT * FROM products;
SELECT * FROM products
WHERE id >= 5;

#2
INSERT INTO reviews (content, picture_url, published_at, rating)
SELECT LEFT(`description`, 15), REVERSE(`name`), CONVERT('2010-10-10', DATETIME), price / 8
FROM products WHERE id >= 5;

-- //
INSERT INTO reviews (content, picture_url, published_at, rating)
SELECT LEFT(`description`, 15), REVERSE(`name`), '2010-10-10' AS published_at, price / 8
FROM products WHERE id >= 5;

#3
SELECT * FROM products
WHERE quantity_in_stock >= 60 AND quantity_in_stock <= 70;

#3
UPDATE products
SET quantity_in_stock = quantity_in_stock - 5
WHERE quantity_in_stock >= 60 AND quantity_in_stock <= 70;

#4
SELECT * FROM customers;
SELECT * FROM orders;

#4
DELETE FROM customers
WHERE id NOT IN (SELECT customer_id FROM orders);


-- Section 3: 
#5
SELECT * FROM categories
ORDER BY `name` DESC;

#6
SELECT * FROM products;

SELECT id, brand_id, `name`, quantity_in_stock 
FROM products
WHERE price > 1000 AND quantity_in_stock < 30
ORDER BY quantity_in_stock, id;

#7
SELECT * FROM reviews;

SELECT * FROM reviews
WHERE LEFT(content, 2) = 'My'
AND CHAR_LENGTH(content) > 61
ORDER BY rating DESC
;

#8
SELECT * FROM customers;
SELECT * FROM orders;

SELECT CONCAT_WS(' ', s.first_name, s.last_name) AS 'full_name',
s.address, o.order_datetime
FROM customers AS s
JOIN orders AS o ON s.id = o.customer_id
WHERE YEAR(o.order_datetime) <= '2018'
ORDER BY full_name DESC
;

#9
SELECT * FROM categories;
SELECT * FROM products;

#9
SELECT COUNT(p.id) AS 'items_count', c.`name`, 
SUM(p.quantity_in_stock) AS 'total_quantity'
FROM products AS p
JOIN categories AS c ON p.category_id = c.id
GROUP BY c.`name`
ORDER BY items_count DESC, total_quantity
LIMIT 5;


-- Section 4:
#10
SELECT * FROM products;
SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM orders_products;

SELECT * FROM customers
WHERE first_name = 'Shirley';
SELECT * FROM orders
WHERE customer_id = 1;
SELECT * FROM orders_products
WHERE order_id = 10;

#10
DELIMITER $$
CREATE FUNCTION udf_customer_products_count(customer_name VARCHAR(30))
RETURNS INT
DETERMINISTIC
BEGIN

RETURN 
(SELECT COUNT(op.product_id)
FROM customers AS c
JOIN orders AS o ON o.customer_id = c.id
JOIN orders_products AS op ON op.order_id = o.id
WHERE c.first_name = customer_name
GROUP BY c.first_name)
;

END $$

DELIMITER ;
SELECT c.first_name,c.last_name, udf_customer_products_count('Shirley') as `total_products` FROM customers c
WHERE c.first_name = 'Shirley';

#11
SELECT * FROM products;
SELECT * FROM categories;

SELECT p.price
FROM categories AS c
JOIN products AS p ON p.category_id = c.id
JOIN reviews AS r ON p.review_id = r.id
WHERE c.`name` = 'Phones and tablets'
AND r.rating < 4
;

#11
DELIMITER $$
CREATE PROCEDURE udp_reduce_price (category_name VARCHAR(50))
BEGIN

UPDATE products AS p
JOIN categories AS c ON p.category_id = c.id
JOIN reviews AS r ON p.review_id = r.id
SET p.price = p.price * 0.7
WHERE c.`name` = category_name
AND r.rating < 4
;

END $$

DELIMITER ;
CALL udp_reduce_price ('Phones and tablets');

