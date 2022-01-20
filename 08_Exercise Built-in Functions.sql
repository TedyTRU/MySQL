
#1
SELECT `first_name`, `last_name` FROM employees
WHERE LEFT(`first_name`, 2) = 'Sa'
ORDER BY `employee_id`;

#1
SELECT first_name, last_name FROM employees
WHERE SUBSTRING(first_name, 1, 2) = 'Sa';

#2
SELECT first_name, last_name FROM employees
WHERE last_name LIKE '%ei%'
ORDER BY employee_id;

#3
SELECT first_name FROM employees
WHERE department_id IN (3, 10) AND
YEAR(hire_date) BETWEEN 1995 AND 2005
ORDER BY employee_id;

#4
SELECT first_name, last_name FROM employees
WHERE job_title NOT LIKE '%engineer%'
ORDER BY employee_id;

#5
SELECT `name` FROM towns
WHERE CHAR_LENGTH(`name`) IN (5, 6)   -- BETWEEN 5 AND 6
ORDER BY `name`;

#6
SELECT * FROM towns
WHERE SUBSTRING(`name`, 1, 1) IN ('M', 'K', 'B', 'E')
ORDER BY `name`;

SELECT * FROM towns
WHERE LEFT(`name`, 1) IN ('M', 'K', 'B', 'E')
ORDER BY `name`;

#7
SELECT * FROM towns
WHERE LEFT(`name`, 1) NOT IN ('R', 'B', 'D')
ORDER BY `name`;

SELECT * FROM towns
WHERE SUBSTRING(`name`, 1, 1) NOT IN ('R', 'B', 'D')
ORDER BY `name`;

#8
CREATE VIEW `v_employees_hired_after_2000` AS
SELECT first_name, last_name FROM employees
WHERE YEAR(hire_date) > 2000;

SELECT * FROM v_employees_hired_after_2000;

#9
SELECT first_name, last_name FROM employees
WHERE CHAR_LENGTH(last_name) = 5;


USE geography;

#10
SELECT country_name, iso_code FROM countries
WHERE country_name LIKE '%A%A%A%'
ORDER BY iso_code;

#11
SELECT * FROM peaks;
SELECT * FROM rivers;

SELECT p.peak_name, r.river_name, LOWER(CONCAT(p.peak_name, SUBSTRING(r.river_name, 2))) AS 'mix'
FROM peaks AS p, rivers AS r
WHERE RIGHT(p.peak_name, 1) = LEFT(r.river_name, 1)
ORDER BY mix;

#12
SELECT `name`, SUBSTRING(`start`, 1, 10) AS 'start' FROM games
WHERE YEAR(`start`) IN (2011, 2012)
ORDER BY `start`, `name`
LIMIT 50;

SELECT * FROM games;

#13





