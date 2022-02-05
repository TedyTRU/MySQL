CREATE DATABASE taxi_company;
USE taxi_company;

-- Section 1:
#1

CREATE TABLE addresses (
	id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL
);

CREATE TABLE categories (
	id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(10) NOT NULL
);

CREATE TABLE clients (
	id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20) NOT NULL
);

CREATE TABLE drivers (
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    age INT NOT NULL,
    rating FLOAT DEFAULT 5.5
);

CREATE TABLE cars (
	id INT PRIMARY KEY AUTO_INCREMENT,
    make VARCHAR(20) NOT NULL,
    model VARCHAR(20) ,
    `year` INT NOT NULL DEFAULT 0,
    mileage INT DEFAULT 0,
    `condition` CHAR(1) NOT NULL,
    category_id INT NOT NULL,
    
    CONSTRAINT fk_cars_categories
    FOREIGN KEY (category_id)
    REFERENCES categories (id)
);

CREATE TABLE courses (
	id INT PRIMARY KEY AUTO_INCREMENT,
    from_address_id INT NOT NULL,
    `start` DATETIME NOT NULL,
    bill DECIMAL(10, 2) DEFAULT 0,
    car_id INT NOT NULL,
    client_id INT NOT NULL,
    
    CONSTRAINT fk_courses_addresses
    FOREIGN KEY (from_address_id)
    REFERENCES addresses(id),
    
	CONSTRAINT fk_courses_cars
    FOREIGN KEY (car_id)
    REFERENCES cars(id),
    
	CONSTRAINT fk_courses_clients
    FOREIGN KEY (client_id)
    REFERENCES clients(id)
);

CREATE TABLE cars_drivers (
	car_id INT NOT NULL,
    driver_id INT NOT NULL,
    
    CONSTRAINT pk_cars_drivers
    PRIMARY KEY (car_id, driver_id),
    
    CONSTRAINT fk_cars_drivers_cars
    FOREIGN KEY (car_id)
    REFERENCES cars(id),
    
	CONSTRAINT fk_cars_drivers_drivers
    FOREIGN KEY (driver_id)
    REFERENCES drivers(id)
);

-- Section 2:
#2
SELECT * FROM clients;
SELECT * FROM drivers;

SELECT id, CONCAT_WS(' ', first_name, last_name) AS 'full_name', 
CONCAT('(088)9999', id * 2) AS 'phone_number'
FROM drivers 
WHERE id BETWEEN 10 AND 20;

#2
INSERT INTO clients (full_name, phone_number)
SELECT CONCAT_WS(' ', first_name, last_name), CONCAT('(088) 9999', id * 2)
FROM drivers WHERE id BETWEEN 10 AND 20;

#3
SELECT * FROM cars;

SELECT * FROM cars
WHERE `condition` != 'C'
AND `year` <= '2010'
AND (mileage >= 800000 OR mileage IS NULL)
AND make != ('Mercedes-Benz')
;

#3
UPDATE cars
SET `condition` = 'C'
WHERE `condition` != 'C'
AND (
`year` <= '2010'
AND (mileage >= 800000 OR mileage IS NULL)
AND make != ('Mercedes-Benz')
);

#4
SELECT * FROM clients;
SELECT * FROM courses;

SELECT * FROM clients AS cl
LEFT JOIN courses AS co
ON cl.id = co.client_id
WHERE co.client_id IS NULL 
AND CHAR_LENGTH(full_name) > 3;

#4
DELETE FROM clients AS cl WHERE CHAR_LENGTH(full_name) > 3
AND (SELECT COUNT(id) FROM courses WHERE client_id = cl.id) = 0;

-- Section 3:
#5
SELECT make, model, `condition` FROM cars
ORDER BY id;

#6
SELECT first_name, last_name, `make`, model, mileage FROM cars AS c
JOIN cars_drivers AS cd ON c.id = cd.car_id
JOIN drivers AS d ON d.id = cd.driver_id
WHERE c.mileage IS NOT NULL
ORDER BY c.mileage DESC, first_name;

#7
SELECT * FROM cars;
SELECT * FROM courses;

SELECT ca.id AS 'car_id', ca.make, ca.mileage, COUNT(co.id) AS 'count_of_courses',
ROUND(AVG(co.bill), 2) AS 'avg_bill' FROM cars AS ca
LEFT JOIN courses AS co ON ca.id = co.car_id
GROUP BY ca.id
HAVING count_of_courses != 2
ORDER BY count_of_courses DESC, ca.id;

#8
SELECT cl.full_name, COUNT(co.car_id) AS 'count_of_cars', SUM(co.bill) AS 'total_sum'
FROM courses AS co
JOIN clients AS cl ON cl.id = co.client_id
GROUP BY co.client_id
HAVING count_of_cars > 1 AND SUBSTRING(full_name, 2, 1) = 'a'
ORDER BY cl.full_name;

#9
SELECT a.`name`,
(CASE 
WHEN HOUR(co.`start`) BETWEEN 6 AND 20 THEN 'Day'
ELSE 'Night'
END) AS 'day_time',
co.bill, cl.full_name, ca.make, ca.model, cat.`name` AS 'category_name'
FROM courses AS co
JOIN clients AS cl ON cl.id = co.client_id
JOIN addresses AS a ON a.id = co.from_address_id
JOIN cars AS ca ON ca.id = co.car_id
JOIN categories AS cat ON cat.id = ca.category_id
ORDER BY co.id
;

-- Section 4:
#10

DELIMITER $$
CREATE FUNCTION udf_courses_by_client (phone_num VARCHAR (20)) 
RETURNS INT
DETERMINISTIC
BEGIN

RETURN 
(SELECT COUNT(co.car_id) AS 'count' FROM courses AS co
RIGHT JOIN clients AS cl ON co.client_id = cl.id
WHERE cl.phone_number = phone_num
GROUP BY co.client_id)
;

END $$

DELIMITER ;
SELECT udf_courses_by_client ('(803) 6386812') as `count`;
SELECT udf_courses_by_client ('(831) 1391236') as `count`;
SELECT udf_courses_by_client ('(704) 2502909') as `count`;

#11

DELIMITER $$
CREATE PROCEDURE udp_courses_by_address (address_name VARCHAR(100))
BEGIN

SELECT a.`name`, cl.full_name,
(CASE 
WHEN co.bill < 20 THEN 'Low'
WHEN co.bill < 30 THEN 'Medium'
ELSE 'High'
END) AS 'level_of_bill',
ca.make, ca.`condition`, cat.`name` AS 'cat_name'
FROM courses AS co
JOIN clients AS cl ON cl.id = co.client_id
JOIN addresses AS a ON a.id = co.from_address_id
JOIN cars AS ca ON co.car_id = ca.id
JOIN categories AS cat ON cat.id = ca.category_id
WHERE a.`name` = address_name
ORDER BY ca.make, cl.full_name
;

END $$

DELIMITER ;
CALL udp_courses_by_address('700 Monterey Avenue');
CALL udp_courses_by_address('66 Thompson Drive');

