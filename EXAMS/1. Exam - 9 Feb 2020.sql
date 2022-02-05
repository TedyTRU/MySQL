CREATE DATABASe fsd;
USE fsd;

-- Section 1: 

#1
CREATE TABLE countries (
	id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL
);

CREATE TABLE towns (
	id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL,
    country_id INT NOT NULL,
    
	CONSTRAINT fk_towns_countries
    FOREIGN KEY (country_id)
    REFERENCES countries (id)
);

CREATE TABLE stadiums (
	id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL,
    capacity INT NOT NULL,
    town_id INT NOT NULL, 
    
	CONSTRAINT fk_stadiums_towns
    FOREIGN KEY (town_id)
    REFERENCES towns (id)
);

CREATE TABLE skills_data (
	id INT PRIMARY KEY AUTO_INCREMENT,
    dribbling INT DEFAULT 0,
    pace INT DEFAULT 0,
    passing INT DEFAULT 0,
    shooting INT DEFAULT 0,
    speed INT DEFAULT 0,
    strength INT DEFAULT 0
);

CREATE TABLE teams (
	id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL,
    established DATE NOT NULL,
    fan_base BIGINT NOT NULL DEFAULT 0,
    stadium_id INT NOT NULL,
	
	CONSTRAINT fk_teams_stadiums
    FOREIGN KEY (stadium_id)
    REFERENCES stadiums (id)
);

CREATE TABLE players (
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(10) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    age INT NOT NULL DEFAULT 0,
    position CHAR(1) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL DEFAULT 0,
    hire_date DATETIME,
    skills_data_id INT NOT NULL,
    team_id INT,
    
	CONSTRAINT fk_players_skills_data
    FOREIGN KEY (skills_data_id)
    REFERENCES skills_data (id),
    
	CONSTRAINT fk_players_teams
    FOREIGN KEY (team_id)
    REFERENCES teams (id)
);

CREATE TABLE coaches (
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(10) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL DEFAULT 0,
    coach_level INT NOT NULL DEFAULT 0
);

CREATE TABLE players_coaches (
	player_id INT,
    coach_id INT,
    
    CONSTRAINT pk_players_coaches
    PRIMARY KEY (player_id, coach_id),
    
    CONSTRAINT fk_players_players_coaches
    FOREIGN KEY (player_id)
    REFERENCES players (id),
    
	CONSTRAINT fk_coaches_players_coaches
    FOREIGN KEY (coach_id)
    REFERENCES coaches (id)
);


-- Section 2: 

#2
INSERT INTO coaches (first_name, last_name, salary, coach_level)
SELECT first_name, last_name, salary * 2, CHAR_LENGTH(first_name) FROM players
WHERE age >= 45;

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

#4
DELETE FROM players WHERE age >= 45;


-- Section 3: 

#5
SELECT first_name, age, salary FROM players
ORDER BY salary DESC;

#6
SELECT p.id, CONCAT_WS(' ', p.first_name, p.last_name) AS 'full_name',
p.age, p.position, p.hire_date
FROM players AS p
JOIN skills_data AS sd
ON p.skills_data_id = sd.id
WHERE p.age < 23 AND p.position = 'A' AND p.hire_date IS NULL AND sd.strength > 50
ORDER BY p.salary, p.age;

#7
SELECT t.`name` AS 'team_name', t.established, t.fan_base, COUNT(p.id) AS 'players_count'
FROM teams AS t
LEFT JOIN players AS p
ON p.team_id = t.id
GROUP BY t.id
ORDER BY players_count DESC, t.fan_base DESC;

#8
SELECT MAX(sd.speed) AS 'max_speed', t.`name` AS 'town_name' 
FROM skills_data AS sd
RIGHT JOIN players AS p ON sd.id = p.skills_data_id
RIGHT JOIN teams AS te ON te.id = p.team_id
RIGHT JOIN stadiums AS s ON s.id = te.stadium_id
RIGHT JOIN towns AS t ON t.id = s.town_id
WHERE te.`name` NOT LIKE 'Devify'
GROUP BY t.`name`
ORDER BY max_speed DESC, t.`name`
;

#9
SELECT c.`name`, 
COUNT(p.id) AS 'total_count_of_players', 
SUM(p.salary) AS 'total_sum_of_salaries'
FROM countries AS c
LEFT JOIN towns AS t ON c.id = t.country_id
LEFT JOIN stadiums AS s ON t.id = s.town_id
LEFT JOIN teams AS te ON s.id = te.stadium_id
LEFT JOIN players AS p ON te.id = p.team_id
GROUP BY c.`name`
ORDER BY total_count_of_players DESC, c.`name`
;


-- Section 4:

#10

DELIMITER $$
CREATE FUNCTION udf_stadium_players_count (stadium_name VARCHAR(30))
RETURNS INT
DETERMINISTIC
BEGIN

RETURN 
(SELECT COUNT(p.id) FROM stadiums AS s
LEFT JOIN teams AS t ON s.id = t.stadium_id
LEFT JOIN players AS p ON t.id = p.team_id
WHERE s.`name` = stadium_name)
;

END $$

DELIMITER ;
SELECT udf_stadium_players_count ('Jaxworks') AS 'count';
SELECT udf_stadium_players_count ('Linklinks') AS 'count';


#11

DELIMITER $$
CREATE PROCEDURE udp_find_playmaker (min_dribble_points INT, team_name VARCHAR(45))
BEGIN

SELECT CONCAT_WS(' ', p.first_name, p.last_name) AS 'full_name',
p.age, p.salary, sd.dribbling, sd.speed, t.`name` As 'team_name'
FROM players AS p
JOIN skills_data AS sd ON p.skills_data_id = sd.id
JOIN teams AS t ON p.team_id = t.id
WHERE t.`name` = team_name AND sd.dribbling > min_dribble_points
AND sd.speed > (SELECT AVG(speed) FROM skills_data)
ORDER BY sd.speed DESC
LIMIT 1
;

END $$

DELIMITER ;
CALL udp_find_playmaker (20, 'Skyble');

