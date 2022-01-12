#1
DROP SCHEMA if exists gamebar;
CREATE SCHEMA gamebar DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE gamebar;

CREATE TABLE employees (
	`id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL
);

CREATE TABLE categories (
	`id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL
);

CREATE TABLE products (
	`id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `category_id` INT NOT NULL,
		CONSTRAINT fk_category_id FOREIGN KEY (`category_id`)
        REFERENCES categories (`id`) 
        ON DELETE NO ACTION
        ON UPDATE CASCADE
);

#2
INSERT INTO employees 
VALUES
(1, 'Pesho', 'Peshov'),
(2, 'Gosho', 'Goshov'),
(3, 'Ivan', 'Ivanov');

#3
ALTER TABLE employees
ADD `middle_name` VARCHAR(100) NOT NULL DEFAULT '';

#5
ALTER TABLE employees
MODIFY `middle_name` VARCHAR(50);

ALTER TABLE employees 
ADD COLUMN `salary` DECIMAL(10, 2);

ALTER TABLE `products` 
ADD INDEX `fk_categories_ind` (`category_id` ASC) INVISIBLE;

#4
ALTER TABLE `products`
ADD CONSTRAINT fk_products_categories
FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);

ALTER TABLE `products` 
ADD CONSTRAINT `fk_category_id`
  FOREIGN KEY (`category_id`)
  REFERENCES `categories` (`id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;






SELECT first_name, last_name FROM `employees` LIMIT 2;
SELECT * FROM employees;

DELETE FROM `employees` WHERE (`id` = '1');

TRUNCATE TABLE `employees`;

SHOW CREATE TABLE `employees`;
SHOW ENGINES;

SHOW TABLE STATUS LIKE 'employees';



