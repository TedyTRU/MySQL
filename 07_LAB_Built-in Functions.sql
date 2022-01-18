
#1
SELECT title FROM books
WHERE SUBSTRING(title, 1, 3) = 'The'
ORDER BY id;

#2
SELECT REPLACE(title, 'The', '***') AS 'title' FROM books
WHERE SUBSTRING(title, 1, 3) = 'The'
ORDER BY id;

#3
SELECT ROUND(SUM(cost), 2) AS sum FROM books;

--
SELECT ROUND(SUM(cost), -2) AS sum FROM books;

#4
SELECT * FROM authors;

SELECT CONCAT_WS(' ', first_name, last_name) AS 'Full Name',
TIMESTAMPDIFF(DAY, born, died) AS 'Days Lived'
FROM authors;

--
SELECT CONCAT_WS(' ', first_name, middle_name, last_name) AS 'Full Name',
DATE_FORMAT(born, '%b, %D, %Y') AS 'Born',
DATE_FORMAT(died, '%b, %D, %Y') AS 'Died',
TIMESTAMPDIFF(YEAR, born, IFNULL(died, NOW())) AS 'Years Lived'
FROM authors;

#5
SELECT title FROM books
WHERE title LIKE '%Harry Potter %'
ORDER BY id;





