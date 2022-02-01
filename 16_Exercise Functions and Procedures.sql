
-- Procedures
#1
DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above_35000 ()
BEGIN
	SELECT first_name, last_name
	FROM employees
	WHERE salary > 35000
	ORDER BY first_name, last_name, employee_id;
END $$

DELIMITER ;
CALL usp_get_employees_salary_above_35000 ();

#2
DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above (salary_level DECIMAL(19, 4))
BEGIN
	SELECT first_name, last_name
	FROM employees
	WHERE salary >= salary_level
	ORDER BY first_name, last_name, employee_id;
END $$

DELIMITER ;
CALL usp_get_employees_salary_above (45000);

#3
DELIMITER $$
CREATE PROCEDURE usp_get_towns_starting_with (town_prefix VARCHAR(20))
BEGIN
	SELECT `name` FROM towns
    WHERE LOWER(`name`) LIKE LOWER(CONCAT(town_prefix, '%'))
    ORDER BY `name`;
END $$

DELIMITER ;
CALL usp_get_towns_starting_with('b');

#4
DELIMITER $$
CREATE PROCEDURE usp_get_employees_from_town(town_name VARCHAR(50))
BEGIN 
	SELECT e.first_name, e.last_name FROM employees AS e
    JOIN addresses AS a ON e.address_id = a.address_id
    JOIN towns AS t ON a.town_id = t.town_id
    WHERE t.`name` = town_name
    ORDER BY e.first_name, e.last_name, e.employee_id;
END $$

DELIMITER ;
CALL usp_get_employees_from_town('Sofia');


-- Functions
#5
DELIMITER $$
CREATE FUNCTION ufn_get_salary_level (salary DECIMAL(19, 4))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
	DECLARE salary_level VARCHAR(10);
    
		IF (salary < 30000) THEN SET salary_level := 'Low';
		ELSEIF (salary <= 50000) THEN SET salary_level := 'Average';
		ELSE SET salary_level := 'High';
        END IF;
        
    RETURN salary_level;
END $$

DELIMITER ;
SELECT ufn_get_salary_level(125500);


#5
DELIMITER $$
CREATE FUNCTION ufn_get_salary_level (salary DECIMAL(19, 4))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
	RETURN
    
		(CASE 
        WHEN salary < 30000 THEN 'Low'
        WHEN salary BETWEEN 30000 AND 50000 THEN 'Average'
        WHEN salary > 50000 THEN 'High'
        END
        );
        
END $$

DELIMITER ;
SELECT ufn_get_salary_level(125500);


-- Procedures
#6
DELIMITER $$
CREATE PROCEDURE usp_get_employees_by_salary_level (salary_level VARCHAR(10))
BEGIN
	SELECT first_name, last_name FROM employees
	WHERE (SELECT ufn_get_salary_level(salary) = salary_level)
	ORDER BY first_name DESC, last_name DESC;
END $$

DELIMITER ;
CALL usp_get_employees_by_salary_level('High');

SELECT first_name, last_name FROM employees
WHERE ufn_get_salary_level(salary) = 'High'
ORDER BY first_name DESC, last_name DESC;

#7
-- Function
DELIMITER $$
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))
RETURNS BIT
DETERMINISTIC
BEGIN
	RETURN (SELECT word REGEXP(CONCAT('^[', set_of_letters, ']+$')));
END $$

DELIMITER ;
SELECT ufn_is_word_comprised('oistmiahf', 'Sofia');
SELECT ufn_is_word_comprised('oistmiahf', 'halves');

SELECT 'halves' REGEXP(CONCAT('^[', 'oistmiahf', ']+$'));
SELECT 'Sofia' REGEXP(CONCAT('^[', 'oistmiahf', ']+$'));
SELECT 'halves' REGEXP('^[oistmiahf]+$');








