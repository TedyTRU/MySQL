
CREATE SCHEMA minions;
USE minions;

#1
CREATE TABLE minions (
	`id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(20) NOT NULL,
    `age` INT
);

CREATE TABLE towns (
	`town_id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL
);

#2
ALTER TABLE towns
CHANGE COLUMN `town_id` `id` INT NOT NULL AUTO_INCREMENT;

ALTER TABLE minions
ADD COLUMN `town_id` INT NOT NULL;

ALTER TABLE minions
ADD CONSTRAINT fk_minions_towns
FOREIGN KEY (`town_id`) REFERENCES `towns`(`id`);

#3
INSERT INTO towns VALUES 
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna');

INSERT INTO minions VALUES
(1, 'Kevin', '22', 1),
(2, 'Bob', '15', 3),
(3, 'Steward', NULL, 2);

#4
TRUNCATE minions;

SELECT * FROM  minions;

#5
DROP TABLE minions;
DROP TABLE towns;

#6
CREATE TABLE people (
	`id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(200) NOT NULL,
    `picture` BLOB,
    `height` DECIMAL(19, 2),
    `weight` DECIMAL(19, 2),
    `gender` CHAR(1) NOT NULL,
    `birthdate` DATE NOT NULL,
    `biography` VARCHAR(200) 
);

INSERT INTO people VALUES 
(1, 'Ivan', NULL, '1.70', '75.5', 'm', DATE(NOW()), NULL),
(2, 'Mara', NULL, '1.70', '75.5', 'f', '1995-10-12', NULL),
(3, 'Petko', NULL, '1.80', '90', 'm', '1990-09-25', NULL),
(4, 'Iva', NULL, '1.70', '50', 'f', '1992-01-12', NULL),
(5, 'Ivana', NULL, '1.70', '60', 'f', '1990-05-18', NULL);

#7
CREATE TABLE users (
	`id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `username` VARCHAR(30) NOT NULL,
    `password` VARCHAR(26) NOT NULL,
	`profile_picture` BLOB,
    `last_login_time` DATETIME,
    `is_deleted` BOOLEAN 
);

INSERT INTO users (`username`, `password`) VALUES
('Gosho', '123456'),
('Tosho', '123456'),
('Pesho', '123456'),
('Misho', '123456'),
('Tsho', '123456');

#8
ALTER TABLE users
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users PRIMARY KEY (id, username);

#9
ALTER TABLE users
MODIFY `last_login_time` DATETIME DEFAULT NOW();

#10
ALTER TABLE users
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users PRIMARY KEY (id),
CHANGE COLUMN `username` `username` VARCHAR(30) UNIQUE;

#11
CREATE DATABASE movies DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
DROP SCHEMA IF EXISTS movies;
CREATE DATABASE movies;
USE movies;

CREATE TABLE directors (
	`id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `director_name` VARCHAR(50) NOT NULL,
    `notes` VARCHAR(100)
);

INSERT INTO directors (director_name) VALUES
('name 1'),
('name 2'),
('name 3'),
('name 4'),
('name 5');

CREATE TABLE genres (
	`id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `genre_name` VARCHAR(30) NOT NULL,
    `notes` VARCHAR(100)
);

INSERT INTO genres (genre_name) VALUES
('name 1'),
('name 2'),
('name 3'),
('name 4'),
('name 5');

CREATE TABLE categories (
	`id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `category_name` VARCHAR(30) NOT NULL,
    `notes` VARCHAR(100)
);

INSERT INTO categories (category_name) VALUES
('name 1'),
('name 2'),
('name 3'),
('name 4'),
('name 5');

CREATE TABLE movies (
	`id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`title` VARCHAR(50) NOT NULL,
    `director_id` INT,
	`copyright_year` YEAR,
    `length` TIME,
    `genre_id` INT,
    `category_id` INT,
    `rating` INT,
    `notes` VARCHAR(100)
);

INSERT INTO movies (title) VALUES 
('movie 1'),
('movie 2'),
('movie 3'),
('movie 4'),
('movie 5');

#12
DROP DATABASE IF EXISTS car_rental;
CREATE DATABASE car_rental;
USE car_rental;

CREATE TABLE categories (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `category` VARCHAR(20) NOT NULL,
	`daily_rate` DOUBLE,
    `weekly_rate` DOUBLE,
    `monthly_rate` DOUBLE,
    `weekend_rate` DOUBLE
);

INSERT INTO categories (category) VALUES
('name 1'),
('name 2'),
('name 3');

CREATE TABLE cars (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `plate_number` VARCHAR(20),
    `make` VARCHAR(20),
    `model` VARCHAR(20),
    `car_year` INT,
    `category_id` INT,
    `doors` INT,
    `picture` BLOB,
    `car_condition` VARCHAR(50),
    `available` BOOLEAN
);

INSERT INTO cars (plate_number) VALUES
('name 1'),
('name 2'),
('name 3');

CREATE TABLE employees (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(50),
    `last_name` VARCHAR(50),
    `title` VARCHAR(50),
    `notes` TEXT
);

INSERT INTO employees (first_name) VALUES
('name 1'),
('name 2'),
('name 3');

CREATE TABLE customers (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `driver_licence_number` VARCHAR(50),
    `full_name` VARCHAR(50),
    `address` VARCHAR(50),
    `city` VARCHAR(50),
    `zip_code` VARCHAR(10),
    `notes` TEXT
);

INSERT INTO customers (driver_licence_number) VALUES
('name 1'),
('name 2'),
('name 3');

CREATE TABLE rental_orders (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `employee_id` INT,
    `customer_id` INT,
    `car_id` INT,
    `car_condition` VARCHAR(50),
    `tank_level` VARCHAR(20),
    `kilometrage_start` INT,
    `kilometrage_end` INT,
    `total_kilometrage` INT,
    `start_date` DATE,
    `end_date` DATE,
    `total_days` INT,
    `rate_applied` DOUBLE,
    `tax_rate` DOUBLE,
    `order_status` VARCHAR(30),
    `notes` TEXT
);

INSERT INTO rental_orders (`employee_id`, `customer_id`) VALUES
(1, 2),
(2, 3),
(3, 1);

#13
DROP DATABASE IF EXISTS soft_uni;
CREATE SCHEMA soft_uni;
USE soft_uni;

CREATE TABLE `towns`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL
);

CREATE TABLE `addresses` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `address_text` VARCHAR(45) NOT NULL, 
    `town_id` INT
);

CREATE TABLE `departments`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL
);

CREATE TABLE `employees` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(45) NOT NULL,
    `middle_name` VARCHAR(45),
    `last_name` VARCHAR(45) NOT NULL,
    `job_title` VARCHAR(45),
    `department_id` INT NOT NULL,
    `hire_date` DATE, 
    `salary` DECIMAL(19,2), 
    `address_id` INT, 
    CONSTRAINT fk_employees_departments FOREIGN KEY `employees`(`department_id`) REFERENCES `departments`(`id`),
    CONSTRAINT fk_employees_addresses FOREIGN KEY `employees`(`address_id`) REFERENCES `addresses`(`id`)
);

INSERT INTO `towns` (`name`)
VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas');

INSERT INTO `departments` (`name`)
VALUES
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance');

INSERT INTO `employees` (`first_name`, `middle_name`, `last_name`, `job_title`, `department_id`, `hire_date`, `salary`)
VALUES
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88);

#14
SELECT * FROM towns;
SELECT * FROM departments;
SELECT * FROM employees;

#15
SELECT * FROM towns
ORDER BY `name`;

SELECT * FROM departments
ORDER BY `name`;

SELECT * FROM employees
ORDER BY `salary` DESC;

#16
SELECT `name` FROM towns
ORDER BY `name`;

SELECT `name` FROM departments
ORDER BY `name`;

SELECT `first_name`, `last_name`, `job_title`, `salary` FROM employees
ORDER BY `salary` DESC;

#17
UPDATE employees
SET `salary` = `salary` * 1.1;
SELECT `salary` FROM employees;

#18
DELETE FROM occupancies;






















