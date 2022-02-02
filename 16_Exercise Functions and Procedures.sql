
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



#8
DELIMITER $$
CREATE PROCEDURE usp_get_holders_full_name ()
BEGIN
	SELECT CONCAT_WS(' ', first_name, last_name) AS 'full_name'
	FROM account_holders
    ORDER BY full_name, id;
END $$

DELIMITER ;
CALL usp_get_holders_full_name();

#9
DELIMITER $$
CREATE PROCEDURE usp_get_holders_with_balance_higher_than (total_money DECIMAL(19, 4))
BEGIN
	SELECT ah.first_name, ah.last_name 
	FROM account_holders AS ah
	JOIN accounts AS a
	ON ah.id = a.account_holder_id
	GROUP BY a.account_holder_id
	HAVING SUM(a.balance) > total_money
	ORDER BY a.account_holder_id;
END $$

DELIMITER ;
CALL usp_get_holders_with_balance_higher_than (7000);

#10
DELIMITER $$
CREATE FUNCTION ufn_calculate_future_value (sum DECIMAL(19, 4), yearly_interest_rate DOUBLE, number_years INT)
RETURNS DECIMAL(19, 4)
DETERMINISTIC
BEGIN
	RETURN POW((1 + yearly_interest_rate), number_years) * sum;
END $$

DELIMITER ;
SELECT ufn_calculate_future_value (1000, 0.5, 5);

#11

SELECT a.id AS 'account_id', ah.first_name, ah.last_name, a.balance AS 'current_balance',
(SELECT ufn_calculate_future_value (a.balance, 0.1, 5)) AS 'balance_in_5_years'
FROM account_holders AS ah
JOIN accounts AS a
ON ah.id = a.account_holder_id
WHERE a.id = 1;

DELIMITER $$
CREATE PROCEDURE usp_calculate_future_value_for_account (account_id INT, interest_rate DECIMAL(19, 4))
BEGIN
	SELECT a.id AS 'account_id', ah.first_name, ah.last_name, a.balance AS 'current_balance',
	(SELECT ufn_calculate_future_value (a.balance, interest_rate, 5)) AS 'balance_in_5_years'
	FROM account_holders AS ah
	JOIN accounts AS a
	ON ah.id = a.account_holder_id
	WHERE a.id = account_id;
END $$

DELIMITER ;
CALL usp_calculate_future_value_for_account(1, 0.1);

#12
SELECT COUNT(*) FROM accounts
WHERE id = 18;

DELIMITER $$
CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DECIMAL(19, 4))
BEGIN
	START TRANSACTION;
    IF ((SELECT COUNT(*) FROM accounts WHERE id = account_id) = 0)
    OR (money_amount < 0)
    THEN ROLLBACK;
    ELSE 
		UPDATE accounts
        SET balance = balance + money_amount
        WHERE id = account_id;
    END IF;
END $$ 

DELIMITER ;

SELECT * FROM accounts WHERE id = 1;
CALL usp_deposit_money(1, 10);

#13
DELIMITER $$
CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DECIMAL(19, 4))
BEGIN
	START TRANSACTION;
    IF ((SELECT COUNT(*) FROM accounts WHERE id = account_id) = 0)
    OR (money_amount < 0)
    OR ((SELECT balance FROM accounts WHERE id = account_id) < money_amount)
    THEN ROLLBACK;
    ELSE 
		UPDATE accounts
        SET balance = balance - money_amount
        WHERE id = account_id;
    END IF;
END $$ 

DELIMITER ;

SELECT * FROM accounts WHERE id = 1;
CALL usp_withdraw_money(1, 10);

#14
DELIMITER $$
CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, money_amount DECIMAL(19, 4))
BEGIN
	START TRANSACTION;
    IF ((SELECT COUNT(*) FROM accounts WHERE id = from_account_id) = 0)
    OR ((SELECT COUNT(*) FROM accounts WHERE id = to_account_id) = 0)
    OR (from_account_id = to_account_id)
    OR (money_amount <= 0)
    OR ((SELECT balance FROM accounts WHERE id = from_account_id) < money_amount)
    THEN ROLLBACK;
    ELSE 
		UPDATE accounts
        SET balance = balance + money_amount
        WHERE id = to_account_id;
        UPDATE accounts
        SET balance = balance - money_amount
        WHERE id = from_account_id;
    END IF;
END $$ 

DELIMITER ;

SELECT * FROM accounts WHERE id = 1;
SELECT * FROM accounts WHERE id = 2;
CALL usp_transfer_money(1, 2, 10);

#15
CREATE TABLE `logs` (
	log_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT,
    old_sum DECIMAL(19, 4),
    new_sum DECIMAL(19, 4)
);

DELIMITER $$
CREATE TRIGGER tr_update_accounts
AFTER UPDATE
ON accounts
FOR EACH ROW
BEGIN
	INSERT INTO `logs` (account_id, old_sum, new_sum)
    VALUES (OLd.id, OLD.balance, NEW.balance);
END $$

DELIMITER ;
SELECT * FROM `logs`;

#16
CREATE TABLE notification_emails (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `recipient` INT,
    `subject` TEXT,
    `body` TEXT
);

DELIMITER $$
CREATE TRIGGER tr_notify_logs
AFTER INSERT 
ON `logs`
FOR EACH ROW
BEGIN
	INSERT INTO notification_emails (`recipient`, `subject`, `body`)
    VALUES (
    NEW.account_id, 
    CONCAT('Balance change for account: ', NEW.account_id),
    CONCAT('On ', DATE_FORMAT(NOW(), '%b %d %Y at %r'), ' your balance was changed from ', ROUND(NEW.old_sum, 0), ' to ', ROUND(NEW.new_sum), 0, '.')
    );
END $$

DELIMITER ;
SELECT * FROM notification_emails;


DROP TRIGGER tr_notify_logs;