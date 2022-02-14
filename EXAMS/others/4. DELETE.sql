
#4
DELETE FROM players WHERE age >= 45;

#4
DELETE FROM addresses WHERE id % 3 = 0;

#4
DELETE FROM clients AS cl WHERE CHAR_LENGTH(full_name) > 3
AND (SELECT COUNT(id) FROM courses WHERE client_id = cl.id) = 0;

#4
DELETE FROM employees
WHERE manager_id IS NOT NULL
AND salary >= 6000
AND id NOT IN (manager_id);

#4
DELETE FROM games AS g
WHERE (SELECT COUNT(game_id) FROM games_categories
WHERE game_id = g.id) = 0
AND g.release_date IS NULL;

#4
DELETE FROM employees AS e
WHERE (SELECT COUNT(*) FROM employees_clients WHERE e.id = employee_id) = 0;

#4
DELETE FROM colonists AS c
WHERE (SELECT COUNT(*) FROM travel_cards WHERE colonist_id = c.id) = 0;

#4
DELETE FROM customers
WHERE id NOT IN (SELECT customer_id FROM orders);

