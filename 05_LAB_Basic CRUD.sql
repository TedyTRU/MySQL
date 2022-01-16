#1
SELECT id, first_name, last_name, job_title 
FROM employees
ORDER BY id;

#2
SELECT * FROM employees;

SELECT id, CONCAT(first_name, ' ', last_name) AS 'full_name', job_title, salary FROM employees
WHERE salary > 1000;

SELECT 
`id` AS 'No.',
concat(`first_name`, ' ', `last_name`) AS 'full_name',
`job_title` AS 'Job Title',
`salary`
FROM `employees`
WHERE salary > 1000
ORDER BY id;

#3
SELECT * FROM employees;

SELECT * FROM employees
WHERE job_title = 'Manager';

UPDATE employees
SET salary = salary + 100
WHERE job_title = 'Manager';
SELECT SALARY FROM employees;

#4
SELECT * FROM employees
ORDER BY salary DESC
LIMIT 1;

CREATE VIEW `v_top_paid_employee`
AS 
SELECT * FROM `employees`
ORDER BY `salary` DESC LIMIT 1;
SELECT * FROM `v_top_paid_employee`;

#5
SELECT * FROM employees
WHERE department_id = 4 AND salary >= 1000
ORDER BY id;

#6
DELETE FROM employees
WHERE department_id IN (1, 2);
SELECT * FROM employees;

DELETE FROM employees
WHERE department_id = 1 OR department_id = 2;
SELECT * FROM employees;


