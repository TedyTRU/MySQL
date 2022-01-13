
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
















