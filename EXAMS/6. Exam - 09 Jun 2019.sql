CREATE SCHEMA RUK_bank;
USE RUK_bank;

-- Section 1:
#1

CREATE TABLE branches (
	id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE employees (
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    started_on DATE NOT NULL,
    branch_id INT NOT NULL,
    
    CONSTRAINT fk_employees_branches
    FOREIGN KEY (branch_id)
    REFERENCES branches (id)
);

CREATE TABLE clients (
	id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(50) NOT NULL,
    age INT NOT NULL
);

CREATE TABLE bank_accounts (
	id INT PRIMARY KEY AUTO_INCREMENT,
    account_number VARCHAR(10) NOT NULL,
    balance DECIMAL(10, 2) NOT NULL,
    client_id INT NOT NULL UNIQUE,
    
    CONSTRAINT fk_bank_accounts_clients
    FOREIGN KEY (client_id)
    REFERENCES clients (id)
);

CREATE TABLE cards (
	id INT PRIMARY KEY AUTO_INCREMENT,
    card_number VARCHAR(19) NOT NULL,
    card_status VARCHAR(7) NOT NULL,
    bank_account_id INT NOT NULL,
    
    CONSTRAINT fk_cards_bank_accounts
    FOREIGN KEY (bank_account_id)
    REFERENCES bank_accounts (id)
);

CREATE TABLE employees_clients (
	employee_id INT,
    client_id INT,
    
    CONSTRAINT fk_employees_clients_employees
    FOREIGN KEY (employee_id)
    REFERENCES employees (id), 
    
	CONSTRAINT fk_employees_clients_clients
    FOREIGN KEY (client_id)
    REFERENCES clients (id)
);

-- Section 2:

#2
INSERT INTO cards (card_number, card_status, bank_account_id)
SELECT REVERSE(full_name), 'Active', id FROM clients
WHERE id BETWEEN 191 AND 200;

#3
-- -----------------
SELECT * FROM clients;
SELECT * FROM employees;
SELECT * FROM employees_clients
WHERE client_id IN (27, 46);

SELECT * FROM employees_clients
WHERE employee_id = client_id;

SELECT * FROM clients
WHERE id IN (27, 46);
-- -----------------

-- NE
UPDATE employees_clients
SET employee_id = 
(SELECT COUNT(client_id)
WHERE employee_id = client_id
GROUP BY employee_id
ORDER BY COUNT(client_id), employee_id
LIMIT 1)
WHERE employee_id = client_id;

-- DA
UPDATE employees_clients
SET employee_id = 
(SELECT * FROM (SELECT employee_id
FROM employees_clients
GROUP BY employee_id
ORDER BY COUNT(client_id), employee_id
LIMIT 1) AS s)
WHERE employee_id = client_id;

-- -----------------
SELECT * FROM employees_clients
WHERE employee_id = client_id;

SELECT employee_id, COUNT(client_id)
FROM employees_clients
-- WHERE employee_id = client_id
GROUP BY employee_id
ORDER BY COUNT(client_id), employee_id
LIMIT 1;

SELECT ec1.employee_id
		FROM employees_clients as ec1 
		GROUP BY ec1.employee_id
		ORDER BY COUNT(ec1.client_id), ec1.employee_id
        LIMIT 1;
-- -----------------

#4
SELECT * FROM employees_clients;
SELECT * FROM employees AS e
LEFT JOIN employees_clients AS ec ON ec.employee_id = e.id
WHERE employee_id IS NULl;

#4
DELETE FROM employees AS e
WHERE (SELECT COUNT(*) FROM employees_clients WHERE e.id = employee_id) = 0;

-- Section 3:
#5
SELECT id, full_name FROM clients
ORDER BY id;

#6
SELECT * FROM employees;

SELECT id, CONCAT_WS(' ', first_name, last_name) AS 'full_name',
CONCAT('$', salary) AS 'salary', started_on FROM employees
WHERE salary >= 100000 
AND started_on >= '2018-01-01'
ORDER BY salary DESC, id;

#7
SELECT c.id, CONCAT(c.card_number, ' : ', cl.full_name) AS 'card_token' FROM cards AS c
JOIN bank_accounts AS ba ON ba.id = c.bank_Account_id
JOIN clients AS cl ON ba.client_id = cl.id
ORDER BY c.id DESC;

#8
SELECT * FROM employees;
SELECT * FROM clients;
SELECT * FROM employees_clients;

SELECT CONCAT_WS(' ', e.first_name, e.last_name) AS 'name',
e.started_on, COUNT(ec.client_id) AS 'count_of_clients'
FROM employees AS e
JOIN employees_clients AS ec ON ec.employee_id = e.id
JOIN clients AS cl ON ec.client_id = cl.id
GROUP BY ec.employee_id
ORDER BY count_of_clients DESC, e.id
LIMIT 5;

#9
SELECT * FROM branches;
SELECT * FROM cards;

SELECT b.`name`, COUNT(c.id) AS 'count_of_cards' FROM branches AS b
LEFT JOIN employees AS e ON e.branch_id = b.id
LEFT JOIN employees_clients AS ec ON ec.employee_id = e.id
LEFT JOIN clients AS cl ON ec.client_id = cl.id
LEFT JOIN bank_accounts AS ba ON ba.client_id = cl.id
LEFT JOIN cards AS c ON ba.id = c.bank_account_id
GROUP BY b.`name`
ORDER BY count_of_cards DESC, b.`name`;

-- Section 4:

#10
SELECT * FROM clients;
SELECT * FROM bank_accounts;
SELECT * FROM cards;

SELECT cl.full_name, COUNT(c.id)  AS 'cards'
FROM clients AS cl
JOIN bank_accounts AS ba ON ba.client_id = cl.id
JOIN cards AS c ON c.bank_account_id = ba.id
GROUP BY c.bank_account_id;

DELIMITER $$
CREATE FUNCTION udf_client_cards_count(client_name VARCHAR(30))
RETURNS INT
DETERMINISTIC
BEGIN

RETURN 
(SELECT COUNT(c.id) 
FROM clients AS cl
JOIN bank_accounts AS ba ON ba.client_id = cl.id
JOIN cards AS c ON c.bank_account_id = ba.id
WHERE cl.full_name = client_name
GROUP BY c.bank_account_id)
;

END $$

DELIMITER ;

SELECT c.full_name, udf_client_cards_count('Baxy David') as `cards` FROM clients c
WHERE c.full_name = 'Baxy David';

#11

SELECT cl.full_name, cl.age, ba.account_number, CONCAT('$', ba.balance) AS 'balance'
FROM clients AS cl
JOIN bank_accounts AS ba ON ba.client_id = cl.id
WHERE cl.full_name = 'Hunter Wesgate';

DELIMITER $$
CREATE PROCEDURE udp_clientinfo (client_name VARCHAR(50))
BEGIN

SELECT cl.full_name, cl.age, ba.account_number, CONCAT('$', ba.balance) AS 'balance'
FROM clients AS cl
JOIN bank_accounts AS ba ON ba.client_id = cl.id
WHERE cl.full_name = client_name
;

END $$

DELIMITER ;
CALL udp_clientinfo('Hunter Wesgate');

