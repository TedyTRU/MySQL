CREATE DATABASE stores;
USE stores;

-- Section 1:
#1

CREATE TABLE pictures (
	id INT PRIMARY KEY AUTO_INCREMENT,
    url VARCHAR(100) NOT NULL,
    added_on DATETIME NOT NULL
);

CREATE TABLE categories (
	id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE products (
	id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE,
    best_before DATE,
    price DECIMAL(10, 2) NOT NULL,
    `description` TEXT,
    category_id INT NOT NULL,
    picture_id INT NOT NULL,
    
    CONSTRAINT fk_products_categories
    FOREIGN KEY (category_id)
    REFERENCES categories (id),
    
	CONSTRAINT fk_products_pictures
    FOREIGN KEY (picture_id)
    REFERENCES pictures (id)
);

CREATE TABLE towns (
	id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE addresses (
	id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL UNIQUE,
    town_id INT NOT NULL,
    
	CONSTRAINT fk_addresses_towns
    FOREIGN KEY (town_id)
    REFERENCES towns (id)
);

CREATE TABLE stores (
	id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(20) NOT NULL UNIQUE,
    rating FLOAT NOT NULL,
    has_parking BOOLEAN DEFAULT 0,
    address_id INT NOT NULL,
    
	CONSTRAINT fk_stores_addresses
    FOREIGN KEY (address_id)
    REFERENCES addresses (id)
);

CREATE TABLE employees (
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(15) NOT NULL,
    middle_name CHAR(1),
    last_name VARCHAR(20) NOT NULL,
    salary DECIMAL(19, 2) DEFAULT 0,
    hire_date DATE NOT NULL,
    manager_id INT,
    store_id INT not NULL,
    
	CONSTRAINT fk_employees_stores
    FOREIGN KEY (store_id)
    REFERENCES stores (id), 
    
   	CONSTRAINT fk_employees_employees
    FOREIGN KEY (manager_id)
    REFERENCES employees (id)
);

CREATE TABLE products_stores (
	product_id INT NOT NULL,
    store_id INT NOT NULL,
    
	CONSTRAINT pk_products_stores
    PRIMARY KEY (product_id, store_id),
    
	CONSTRAINT fk_products_stores_products
    FOREIGN KEY (product_id)
    REFERENCES products (id),
    
	CONSTRAINT fk_stores_stores_products
    FOREIGN KEY (store_id)
    REFERENCES stores (id)
);

-- Section 2:
#2
INSERT INTO products_stores (product_id, store_id)
(SELECT p.id, 1 FROM products AS p LEFT JOIN products_stores AS ps ON p.id = ps.product_id WHERE ps.product_id IS NULL);

#3
UPDATE employees
SET manager_id = 3, salary = salary + 500
WHERE YEAR(hire_date) >= 2003
AND store_id NOT IN (5, 14);

#4
DELETE FROM employees
WHERE manager_id IS NOT NULL
AND salary >= 6000
AND id NOT IN (manager_id);

-- Section 3:
#5
SELECT first_name, middle_name, last_name, salary, hire_date
FROM employees
ORDER BY hire_date DESC;

#6
SELECT * FROM products;
SELECT * FROM pictures;

SELECT pr.`name` AS 'product_name', pr.price, pr.best_before, 
CONCAT(SUBSTRING(pr.`description`, 1, 10), '...') AS 'short_description', pi.url
FROM products AS pr
JOIN pictures AS pi ON pr.picture_id = pi.id
WHERE CHAR_LENGTH(pr.`description`) > 100
AND YEAR(pi.added_on) < 2019
AND pr.price > 20
ORDER BY pr.price DESC;

#7
SELECT s.`name`, COUNT(ps.product_id) AS 'product_count', ROUND(AVG(pr.price), 2) AS 'avg'
FROM stores AS s
LEFT JOIN products_stores AS ps ON s.id = ps.store_id
LEFT JOIN products AS pr ON pr.id = ps.product_id
GROUP BY s.id
ORDER BY product_count DESC, `avg` DESC, s.id;

#8
SELECT * FROM employees;

SELECT CONCAT_WS(' ', e.first_name, e.last_name) AS 'Full_name',
s.`name` AS 'Store_name', a.`name` AS 'address', e.salary
FROM employees AS e
JOIN stores AS s ON e.store_id = s.id
JOIN addresses AS a ON s.address_id = a.id
WHERE e.salary < 4000
AND a.`name` LIKE '%5%'
AND CHAR_LENGTH(s.`name`) > 8
AND RIGHT(e.last_name, 1) = 'n'
;

#9
SELECT * FROM employees;
SELECT * FROM stores;

SELECT REVERSE(s.`name`) AS 'reversed_name', 
CONCAT(UPPER(t.`name`), '-', a.`name`) AS 'full_address',
COUNT(e.id) AS 'employees_count'
FROM employees AS e
JOIN stores AS s ON e.store_id = s.id
JOIN addresses AS a ON s.address_id = a.id
JOIN towns AS t ON t.id = a.town_id
GROUP BY e.store_id
ORDER BY full_address;

-- Section 4:
#10

DELIMITER $$
CREATE FUNCTION udf_top_paid_employee_by_store(store_name VARCHAR(50))  
RETURNS TEXT
DETERMINISTIC
BEGIN

RETURN 

(SELECT CONCAT( e.first_name, ' ', e.middle_name, '. ', e.last_name, ' works in store for ', 
2020 - YEAR(e.hire_date), ' years')
FROM employees AS e
JOIN stores AS s ON e.store_id = s.id
WHERE s.`name` = store_name
ORDER BY salary DESC
LIMIT 1);

END $$

DELIMITER ;
SELECT udf_top_paid_employee_by_store ('Stronghold') AS 'full_info';
SELECT udf_top_paid_employee_by_store ('Keylex') AS 'full_info';

#11

DELIMITER $$
CREATE PROCEDURE udp_update_product_price (address_name VARCHAR (50))
BEGIN

UPDATE products AS p
JOIN products_stores AS ps ON p.id = ps.product_id
JOIN stores AS s ON ps.store_id = s.id
JOIN addresses AS a ON s.address_id = a.id
SET p.price = p.price + 
(CASE 
WHEN LEFT(a.`name`, 1) = '0' THEN 100
ELSE 200
END) 
WHERE a.`name` = address_name
;

END $$

DELIMITER ;

CALL udp_update_product_price ('07 Armistice Parkway');
SELECT name, price FROM products WHERE id = 15;

CALL udp_update_product_price('1 Cody Pass');
SELECT name, price FROM products WHERE id = 17;


