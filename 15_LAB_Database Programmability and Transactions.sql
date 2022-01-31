
#1
SELECT * FROM towns;
SELECT * FROM addresses;
SELECT * FROM employees;

SELECT COUNT(employee_id) FROM employees AS e
		JOIN addresses a USING(address_id)
        JOIN towns t USING(town_id)
        WHERE t.`name` = 'Berlin';
        
        

DELIMITER //
CREATE FUNCTION ufn_count_employees_by_town(town_name VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE e_count INT;
    SET e_count := (SELECT COUNT(employee_id) FROM employees AS e
		JOIN addresses a USING(address_id)
        JOIN towns t USING(town_id)
		WHERE t.`name` = town_name);
	RETURN e_count;
END //
    
DELIMITER ;
SELECT ufn_count_employees_by_town('Berlin');


#2
DELIMITER //
CREATE PROCEDURE usp_raise_salaries(department_name VARCHAR(50)) 
BEGIN
	UPDATE employees AS e
    JOIN departments AS d
    ON e.department_id = d.department_id
    SET salary = salary * 1.05
    WHERE d.`name` = department_name;
END //

DELIMITER ;

SELECT department_id, salary FROM employees;
SELECT * FROM departments;

CALL usp_raise_salaries('Sales');

#3
DROP PROCEDURE IF EXISTS `usp_raise_salary_by_id`;
DELIMITER //
CREATE PROCEDURE usp_raise_salary_by_id(emp_id INT) 
BEGIN
	UPDATE employees
    SET salary = salary * 1.05
    WHERE employee_id = emp_id;
END //

DELIMITER ;

SELECT employee_id, salary FROM employees
WHERE employee_id = 17;

CALL usp_raise_salary_by_id('17');

#3
DROP PROCEDURE IF EXISTS `usp_raise_salary_by_id`;

DELIMITER //
CREATE PROCEDURE usp_raise_salary_by_id(emp_id INT) 
BEGIN
	START TRANSACTION;
    IF((SELECT COUNT(*) FROM employees WHERE employee_id = emp_id) = 0)
    THEN ROLLBACK;
    ELSE
		UPDATE employees
		SET salary = salary * 1.05
		WHERE employee_id = emp_id;

	END IF;
END //

DELIMITER ;

SELECT employee_id, salary FROM employees
WHERE employee_id = 17;

CALL usp_raise_salary_by_id('17');


#4
DROP TABLE IF EXISTS deleted_employees;

CREATE TABLE deleted_employees (
  `employee_id` INT PRIMARY KEY AUTO_INCREMENT,
  `first_name` VARCHAR(20) NOT NULL,
  `last_name` VARCHAR(20) NOT NULL,
  `middle_name` VARCHAR(20) DEFAULT NULL,
  `job_title` VARCHAR(50) NOT NULL,
  `department_id` INT,
  `salary` DECIMAL(19,4) NOT NULL
);

DROP TRIGGER IF EXISTS tr_deleted_employees;

DELIMITER $$
CREATE TRIGGER tr_deleted_employees
AFTER DELETE
ON employees
FOR EACH ROW
BEGIN
	INSERT INTO deleted_employees
    ( `employee_id`, `first_name`, `last_name`, `middle_name`, `job_title`, `department_id`, `salary`)
    VALUES
    ( OLD.`employee_id`, OLD.`first_name`, OLD.`last_name`, OLD.`middle_name`, OLD.`job_title`, OLD.`department_id`, OLD.`salary`);
END $$

DELIMITER ;

SELECT * FROM employees
WHERE employee_id = '3';

DELETE FROM soft_uni.employees
WHERE employee_id IN (3);

SELECT * FROM deleted_employees;
