
#3
UPDATE coaches
SET coach_level = coach_level + 1
WHERE LEFT(first_name, 1) = 'A'
AND id IN (SELECT coach_id FROM players_coaches);

-- //
UPDATE `coaches`
SET `coach_level` = `coach_level` + 1
WHERE (SELECT COUNT(coach_id) FROM `players_coaches`
WHERE `id` = `coach_id`) > 0 AND `first_name` LIKE 'A%';

-- //
UPDATE coaches
SET coach_level=coach_level+1
WHERE first_name LIKE 'A%'
and id=(SELECT coach_id FROM players_coaches pc WHERE coach_id=id
    LIMIT 1)
;

#3
UPDATE addresses
SET country = (CASE LEFT(country, 1)
	WHEN 'B' THEN 'Blocked'
	WHEN 'T' THEN 'Test'
	WHEN 'P' THEN 'In Progress'
    END
)
WHERE LEFT(country, 1) IN ('B', 'T', 'P');

#3
UPDATE cars
SET `condition` = 'C'
WHERE `condition` != 'C'
AND (
`year` <= '2010'
AND (mileage >= 800000 OR mileage IS NULL)
AND make != ('Mercedes-Benz')
);

#3
UPDATE employees
SET manager_id = 3, salary = salary + 500
WHERE YEAR(hire_date) >= 2003
AND store_id NOT IN (5, 14);

#3
UPDATE employees
SET salary = salary + 1000
WHERE age < 40
AND salary <= 5000;

#3
UPDATE employees_clients
SET employee_id = 
(SELECT * FROM (SELECT employee_id
FROM employees_clients
GROUP BY employee_id
ORDER BY COUNT(client_id), employee_id
LIMIT 1) AS s)
WHERE employee_id = client_id;

 #3
UPDATE journeys 
SET purpose =
(CASE
	WHEN id % 2 = 0 THEN 'Medical'
	WHEN id % 3 = 0 THEN 'Technical'
	WHEN id % 5 = 0 THEN 'Educational'
	WHEN id % 7 = 0 THEN 'Military'
    ELSE purpose
END);

#3
UPDATE products
SET quantity_in_stock = quantity_in_stock - 5
WHERE quantity_in_stock >= 60 AND quantity_in_stock <= 70;

