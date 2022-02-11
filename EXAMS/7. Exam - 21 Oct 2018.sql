CREATE DATABASE CJMS;
USE CJMS;

-- Section 1:
#1

CREATE TABLE planets (
	id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL
);

CREATE TABLE spaceships (
	id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    manufacturer VARCHAR(30) NOT NULL,
    light_speed_rate INT DEFAULT 0
);

CREATE TABLE colonists (
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    ucn CHAR(10) NOT NULL UNIQUE,
    birth_date DATE NOT NULL
);

CREATE TABLE spaceports (
	id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    planet_id INT,
    
    CONSTRAINT fk_spaceports_planets
    FOREIGN KEY (planet_id)
    REFERENCES planets (id)
);

CREATE TABLE journeys (
	id INT PRIMARY KEY AUTO_INCREMENT,
    journey_start DATETIME NOT NULL,
    journey_end DATETIME NOT NULL,
    purpose ENUM('Medical', 'Technical', 'Educational', 'Military') NOT NULL,
    destination_spaceport_id INT, 
    spaceship_id INT,
    
    CONSTRAINT fk_journeys_spaceports
    FOREIGN KEY (destination_spaceport_id)
    REFERENCES spaceports (id),
    
    CONSTRAINT fk_journeys_spaceships
    FOREIGN KEY (spaceship_id)
    REFERENCES spaceships (id)
);

CREATE TABLE travel_cards (
	id INT PRIMARY KEY AUTO_INCREMENT,
    card_number CHAR(10) NOT NULL UNIQUE,
    job_during_journey ENUM('Pilot', 'Engineer', 'Trooper', 'Cleaner', 'Cook') NOT NULL,
    colonist_id INT,
    journey_id INT,
    
    CONSTRAINT fk_travel_cards_colonists
    FOREIGN KEY (colonist_id)
    REFERENCES colonists (id),
    
    CONSTRAINT fk_travel_cards_journeys
    FOREIGN KEY (journey_id)
    REFERENCES journeys (id)
);

-- Section 2:
#2

SELECT * FROM travel_cards;

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

SELECT * FROM journeys 
WHERE id % 7 = 0 ;

#4
DELETE FROM colonists AS c
WHERE (SELECT COUNT(*) FROM travel_cards WHERE colonist_id = c.id) = 0;



-- Section 3:
#4
SELECT card_number, job_during_journey FROM travel_cards
ORDER BY card_number;

#5
SELECT id, CONCAT_WS(' ', first_name, last_name) AS 'full_name', ucn
FROM colonists
ORDER BY first_name, last_name, id;

#6
SELECT id, journey_start, journey_end FROM journeys
WHERE purpose = 'Military'
ORDER BY journey_start;

#7
SELECT * FROM travel_cards;
SELECT * FROM colonists;

SELECT c.id, CONCAT_WS(' ', first_name, last_name) AS 'full_name' FROM colonists AS c
JOIN travel_cards AS tc ON tc.colonist_id = c.id
WHERE tc.job_during_journey = 'Pilot'
ORDER BY c.id;

#8
SELECT COUNT(*) AS 'count' FROM journeys AS j
LEFT JOIN travel_cards AS tc ON tc.journey_id = j.id
WHERE j.purpose = 'Technical';

#9
SELECT * FROM journeys;
SELECT * FROM spaceships;

SELECT s.`name` AS 'spaceship_name', sp.`name` AS 'spaceport_name' FROM spaceships AS s
JOIN journeys AS j ON j.spaceship_id = s.id
JOIN spaceports AS sp ON sp.id = j.destination_spaceport_id
ORDER BY s.light_speed_rate DESC
LIMIT 1;

#10
SELECT * FROM spaceships;
SELECT * FROM colonists;

SELECT s.`name`, s.manufacturer FROM spaceships AS s
JOIN journeys AS j ON j.spaceship_id = s.id
JOIN travel_cards AS tc ON tc.journey_id = j.id
JOIN colonists AS c ON c.id = tc.colonist_id
WHERE c.birth_date > '1989-01-01'
AND tc.job_during_journey = 'Pilot'
ORDER BY s.`name`;

SELECT s.`name`, s.manufacturer FROM spaceships AS s
JOIN journeys AS j ON j.spaceship_id = s.id
JOIN travel_cards AS tc ON tc.journey_id = j.id
JOIN colonists AS c ON c.id = tc.colonist_id
WHERE YEAR(c.birth_date) > YEAR(DATE_SUB('2019-01-01', INTERVAL 30 YEAR))
AND tc.job_during_journey = 'Pilot'
ORDER BY s.`name`;

#11
SELECT p.`name` AS 'planet_name', s.`name` AS 'spaceport_name' FROM planets AS p 
JOIN spaceports AS s ON s.planet_id = p.id
JOIN journeys AS j ON j.destination_spaceport_id = s.id
WHERE j.purpose = 'Educational'
ORDER BY s.`name` DESC;

#12
SELECT * FROM spaceports;
SELECT * FROM journeys;

SELECT p.`name` AS 'planet_name', COUNT(s.id) AS 'journeys_count' FROM planets AS p 
JOIN spaceports AS s ON s.planet_id = p.id
JOIN journeys AS j ON j.destination_spaceport_id = s.id
GROUP BY s.planet_id
ORDER BY journeys_count DESC, planet_name;

#13
SELECT j.id, p.`name` AS 'planet_name', s.`name` AS 'spaceport_name', j.purpose AS 'journey_purpose'
-- DATEDIFF(j.journey_end, j.journey_start)
FROM planets AS p 
JOIN spaceports AS s ON s.planet_id = p.id
JOIN journeys AS j ON j.destination_spaceport_id = s.id
ORDER BY DATEDIFF(j.journey_end, j.journey_start)
LIMIT 1;

#14
SELECT * FROM travel_cards;
SELECT * FROM colonists;
SELECT * FROM journeys;

SELECT j.id FROM journeys AS j
ORDER BY DATEDIFF(j.journey_end, j.journey_start) DESC;

SELECT tc.job_during_journey AS 'job_name' FROM travel_cards AS tc
WHERE tc.journey_id =
(SELECT j.id FROM journeys AS j
ORDER BY DATEDIFF(j.journey_end, j.journey_start) DESC
LIMIT 1)
GROUP BY tc.job_during_journey
ORDER BY COUNT(tc.colonist_id)
LIMIT 1;

-- Section 4:
#15

SELECT COUNT(tc.colonist_id)
FROM planets AS p 
JOIN spaceports AS s ON s.planet_id = p.id
JOIN journeys AS j ON j.destination_spaceport_id = s.id
JOIN travel_cards AS tc ON tc.journey_id = j.id
JOIN colonists AS c ON tc.colonist_id = c.id
WHERE p.`name` = 'Otroyphus'
;

DELIMITER $$
CREATE FUNCTION udf_count_colonists_by_destination_planet (planet_name VARCHAR (30))
RETURNS INT
DETERMINISTIC
BEGIN

RETURN 
(SELECT COUNT(tc.colonist_id)
FROM planets AS p 
JOIN spaceports AS s ON s.planet_id = p.id
JOIN journeys AS j ON j.destination_spaceport_id = s.id
JOIN travel_cards AS tc ON tc.journey_id = j.id
JOIN colonists AS c ON tc.colonist_id = c.id
WHERE p.`name` = planet_name
);

END $$

DELIMITER ;
SELECT p.name, udf_count_colonists_by_destination_planet('Otroyphus') AS count
FROM planets AS p
WHERE p.name = 'Otroyphus';

#16
SELECT * FROM spaceships;
SELECT COUNT(*) FROM spaceships
WHERE `name` = 'Judgment';

DELIMITER $$
CREATE PROCEDURE udp_modify_spaceship_light_speed_rate(spaceship_name VARCHAR(50), light_speed_rate_increse INT(11)) 
BEGIN

IF (SELECT COUNT(*) FROM spaceships WHERE `name` = spaceship_name) > 0 THEN
	UPDATE spaceships AS s
	SET s.light_speed_rate = s.light_speed_rate + light_speed_rate_increse
	WHERE s.`name` = spaceship_name;
ELSE 
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Spaceship you are trying to modify does not exists.';
    ROLLBACK;
END IF
;

END $$

DELIMITER ;

CALL udp_modify_spaceship_light_speed_rate ('Na Pesho koraba', 1914);
SELECT name, light_speed_rate FROM spacheships WHERE name = 'Na Pesho koraba';

CALL udp_modify_spaceship_light_speed_rate ('USS Templar', 5);
SELECT name, light_speed_rate FROM spaceships WHERE name = 'USS Templar';

