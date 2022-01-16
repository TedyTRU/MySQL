
#1
SELECT * FROM departments
ORDER BY department_id;

#2
SELECT `name` FROM departments
ORDER BY department_id;

#3
SELECT first_name, last_name, salary FROM employees
ORDER BY employee_id;

#4
SELECT first_name, middle_name, last_name FROM employees
ORDER BY employee_id;

#5
SELECT * FROM employees;

SELECT CONCAT(first_name, '.', last_name, '@softuni.bg') AS 'full_email_address'
FROM employees;

#6
SELECT DISTINCT salary FROM employees
ORDER BY employee_id;

#7
SELECT * FROM employees
WHERE job_title = 'Sales Representative'
ORDER BY employee_id;

#8
SELECT first_name, last_name, job_title FROM employees
WHERE salary BETWEEN 20000 AND 30000
ORDER BY employee_id;

#9
SELECT * FROM employees;

SELECT CONCAT(first_name, ' ', middle_name, ' ', last_name) AS 'Full Name'
FROM employees
WHERE salary IN (25000, 14000, 12500, 23600);

#10
SELECT first_name, last_name FROM employees
WHERE manager_id IS NULL;

#11
SELECT first_name, last_name, salary FROM employees
WHERE salary > 50000
ORDER BY salary DESC;

#12
SELECT first_name, last_name FROM employees
ORDER BY salary DESC
LIMIT 5;

#13
SELECT first_name, last_name FROM employees
WHERE NOT (department_id = 4);

#14
SELECT * FROM employees
ORDER BY salary DESC, first_name, last_name DESC, middle_name, employee_id;
