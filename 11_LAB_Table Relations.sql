
#1
CREATE TABLE mountains (
	`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(50) NOT NULL
); 

CREATE TABLE peaks (
	`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    `mountain_id` INT,
		CONSTRAINT fk_peaks_mountains
        FOREIGN KEY (`mountain_id`)
        REFERENCES `mountains`(`id`)
	ON UPDATE CASCADE
    ON DELETE SET NULL
);

#2
SELECT * FROM campers;
SELECT * FROM vehicles;

SELECT v.driver_id, v.vehicle_type, 
CONCAT(c.first_name, ' ', c.last_name) AS 'driver_name'
FROM vehicles AS v
JOIN campers AS c
ON v.driver_id = c.id;

#3
SELECT * FROM routes;
SELECT * FROM campers;

SELECT r.starting_point AS 'route_starting_point',
r.end_point AS 'route_ending_point', r.leader_id, 
CONCAT_WS(' ', c.first_name, c.last_name) AS 'leader_name' 
FROM routes AS r 
JOIN campers AS c
ON r.leader_id = c.id;

#4
ALTER TABLE peaks
DROP FOREIGN KEY fk_peaks_mountains;

ALTER TABLE peaks
	ADD CONSTRAINT fk_peaks_mountains 
    FOREIGN KEY (`mountain_id`)
    REFERENCES `mountains` (`id`)
    ON UPDATE RESTRICT
    ON DELETE CASCADE;



#many-to-many
CREATE TABLE IF NOT EXISTS `projects`.`employee` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `projects`.`project` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `camp`.`peaks` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `mountains_id` INT(11) NOT NULL,
  PRIMARY KEY (`id`, `mountains_id`),
  INDEX `fk_peaks_mountains1_idx` (`mountains_id` ASC) VISIBLE,
  CONSTRAINT `fk_peaks_mountains1`
    FOREIGN KEY (`mountains_id`)
    REFERENCES `camp`.`mountains` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;