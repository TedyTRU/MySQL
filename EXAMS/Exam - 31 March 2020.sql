CREATE SCHEMA insta_Influnecers;
USE insta_Influnecers;

-- Section 1:
#1
CREATE TABLE users (
	id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(30) NOT NULL UNIQUE,
    `password` VARCHAR(30) NOT NULL,
    email VARCHAR(50) NOT NULL,
    gender CHAR(1) NOT NULL,
    age INT NOT NULL,
    job_title VARCHAR(40) NOT NULL,
    ip VARCHAR(30) NOT NULL
);

CREATE TABLE photos (
	id INT PRIMARY KEY AUTO_INCREMENT,
    `description` TEXT NOT NULL,
    `date` DATETIME NOT NULL,
    views INT NOT NULL DEFAULT 0
);

CREATE TABLE addresses (
	id INT PRIMARY KEY AUTO_INCREMENT,
    address VARCHAR(30) NOT NULL,
    town VARCHAR(30) NOT NULL,
    country VARCHAR(30) NOT NULL,
    user_id INT NOT NULL,
    
    CONSTRAINT fk_users_addresses
    FOREIGN KEY (user_id)
    REFERENCES users (id)
);

CREATE TABLE comments (
	id INT PRIMARY KEY AUTO_INCREMENT,
    `comment` VARCHAR(255) NOT NULL,
    `date` DATETIME NOT NULL,
    photo_id INT NOT NULL,
    
	CONSTRAINT fk_photos_addresses
    FOREIGN KEY (photo_id)
    REFERENCES photos (id)
);

CREATE TABLE users_photos (
	user_id INT NOT NULL,
    photo_id INT NOT NULL,
    
    CONSTRAINT pk_users_photos
    PRIMARY KEY (user_id, photo_id),
    
    CONSTRAINT fk_users_photos_users
    FOREIGN KEY (user_id)
    REFERENCES users (id),
    
	CONSTRAINT fk_users_photos_photos
    FOREIGN KEY (photo_id)
    REFERENCES photos (id)
);

CREATE TABLE likes (
	id INT PRIMARY KEY AUTO_INCREMENT,
    photo_id INT,
    user_id INT,
    
	CONSTRAINT fk_likes_users
    FOREIGN KEY (user_id)
    REFERENCES users (id),
    
	CONSTRAINT fk_likes_photos
    FOREIGN KEY (photo_id)
    REFERENCES photos (id)
);

-- Section 2:
#2
INSERT INTO addresses (address, town, country, user_id)
(SELECT username, `password`, ip, age FROM users WHERE gender = 'M');

#3
SELECT * FROM addresses;

UPDATE addresses
SET country = (CASE LEFT(country, 1)
	WHEN 'B' THEN 'Blocked'
	WHEN 'T' THEN 'Test'
	WHEN 'P' THEN 'In Progress'
    END
)
WHERE LEFT(country, 1) IN ('B', 'T', 'P');

#4
DELETE FROM addresses WHERE id % 3 = 0;


-- Section 3:
#5

SELECT username, gender, age FROM users
ORDER BY age DESC, username;

#6
SELECT * FROM comments;
SELECT * FROM likes;
SELECT * FROM photos;

SELECT p.id, p.`date` AS 'date_and_time', p.`description`, COUNT(p.id) AS 'commentsCount'
FROM photos AS p
JOIN comments AS c ON p.id = c.photo_id
GROUP BY p.id
ORDER BY commentsCount DESC, p.id
LIMIT 5;

#7
SELECT * FROM users;
SELECT * FROM users_photos
WHERE user_id = photo_id;


SELECT CONCAT_WS(' ', u.id, u.username) AS 'id_username', u.email 
FROM users AS u
JOIN users_photos AS up
ON u.id = up.user_id
WHERE up.user_id = up.photo_id;

#8
SELECT * FROM comments;
SELECT * FROM likes;
SELECT * FROM photos;

SELECT p.id AS 'photo_id', 
COUNT(DISTINCT l.id) AS 'likes_count', 
COUNT(DISTINCT c.id) AS 'comments_count' 
FROM photos AS p
LEFT JOIN likes AS l On p.id = l.photo_id
LEFT JOIN comments AS c ON p.id = c.photo_id
GROUP BY p.id
ORDER BY likes_count DESC, comments_count DESC, p.id;


#8
SELECT p.id,
(SELECT COUNT(*) FROM likes WHERE photo_id = p.id) AS 'likes_count',
(SELECT COUNT(*) FROM comments WHERE photo_id = p.id) AS 'comments_count'
FROM photos AS p
ORDER BY likes_count DESC, comments_count DESC, p.id;



#9
SELECT * FROM photos;

SELECT * FROM photos
WHERE DAY(`date`) = '10';

SELECT CONCAT(LEFT(`description`, 30), '...') AS 'summary', `date` 
FROM photos
WHERE DAY(`date`) = 10
ORDER BY `date` DESC;


-- Section 4:
#10
SELECT COUNT(*) FROM users AS u
JOIN users_photos AS up
ON u.id = up.user_id
WHERE username = 'ssantryd';


DELIMITER $$
CREATE FUNCTION udf_users_photos_count(username VARCHAR(30)) 
RETURNS INT
DETERMINISTIC
BEGIN

RETURN 

(SELECT COUNT(*) FROM users AS u
LEFT JOIN users_photos AS up
ON u.id = up.user_id
WHERE u.username = username);

END $$

DELIMITER ;
SELECT udf_users_photos_count('ssantryd') AS photosCount;


#11

SELECT * FROM addresses;

SELECT * FROM users AS u
JOIN addresses AS a
ON a.user_id = u.id
WHERE a.address = '97 Valley Edge Parkway'
AND a.town = 'Divinópolis';





