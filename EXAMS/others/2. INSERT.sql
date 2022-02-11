
#2
INSERT INTO coaches (first_name, last_name, salary, coach_level)
SELECT first_name, last_name, salary * 2, CHAR_LENGTH(first_name) FROM players
WHERE age >= 45;

#2
INSERT INTO addresses (address, town, country, user_id)
(SELECT username, `password`, ip, age FROM users WHERE gender = 'M');

#2
INSERT INTO clients (full_name, phone_number)
SELECT CONCAT_WS(' ', first_name, last_name), CONCAT('(088) 9999', id * 2)
FROM drivers WHERE id BETWEEN 10 AND 20;

#2
INSERT INTO products_stores (product_id, store_id)
(SELECT p.id, 1 FROM products AS p LEFT JOIN products_stores AS ps ON p.id = ps.product_id WHERE ps.product_id IS NULL);

#2
INSERT INTO games (`name`, rating, budget, team_id)
SELECT REVERSE(LOWER(SUBSTRING(`name`, 2))), id, leader_id * 1000, id
FROM teams 
WHERE id BETWEEN 1 AND 9;

#2
INSERT INTO cards (card_number, card_status, bank_account_id)
SELECT REVERSE(full_name), 'Active', id FROM clients
WHERE id BETWEEN 191 AND 200;

#2
INSERT INTO travel_cards (card_number, job_during_journey, colonist_id, journey_id)
SELECT 
		IF(birth_date > '1980-01-01',
        CONCAT(YEAR(birth_date), DAY(birth_date), lEFT(ucn, 4)),
        CONCAT(YEAR(birth_date), MONTH(birth_date), RIGHT(ucn, 4))),
        
       (CASE 
			WHEN id % 2 = 0 THEN 'Pilot'
            WHEN id % 3 = 0 THEN 'Cook'
            ELSE 'Engineer'
            END),
            
            id,
            
            LEFT(ucn, 1)
            
FROM colonists WHERE id BETWEEN 96 AND 100;









