#1
SELECT * FROM employees;
SELECT * FROM departments;

SELECT e.employee_id, CONCAT_WS(' ', first_name, last_name) AS 'full_name',
d.department_id, d.name AS 'department_name'
FROM employees AS e
JOIN departments AS d
ON d.manager_id = e.employee_id
ORDER BY e.employee_id
LIMIT 5;

#2
SELECT * FROM addresses;
SELECT * FROM towns;

SELECT t.town_id, t.`name` AS 'town_name', a.address_text
FROM towns AS t
JOIN addresses AS a
ON a.town_id = t.town_id
WHERE t.town_id IN (9, 15, 32)
ORDER BY town_id, address_id;

#3
SELECT employee_id, first_name, last_name, department_id, salary
FROM employees
WHERE manager_id IS NULL;

#4
SELECT COUNT(*) AS 'count' FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);



