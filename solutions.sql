CREATE TABLE netflix_table
(
	show_id	VARCHAR(5),
	type    VARCHAR(10),
	title	VARCHAR(250),
	director VARCHAR(550),
	casts	VARCHAR(1050),
	country	VARCHAR(550),
	date_added	VARCHAR(55),
	release_year	INT,
	rating	VARCHAR(15),
	duration	VARCHAR(15),
	listed_in	VARCHAR(250),
	description VARCHAR(550)
);




-- 1. Count the number of Movies vs TV Shows

SELECT 
	type , 
	COUNT(*) as "type_count" 
FROM netflix_table
GROUP BY type;

-- 2. List all movies released in a specific year (e.g., 2020)

SELECT * FROM netflix_table
WHERE type = 'Movie' and release_year = 2020;

-- 3. Find the top 5 countries with the most content on Netflix

SELECT 
	LTRIM(UNNEST(STRING_TO_ARRAY(country, ','))) as new_country,
	COUNT(show_id) as "count" FROM netflix_table
GROUP BY new_country
ORDER BY count DESC LIMIT 5;


-- 4. Identify the longest movie

SELECT 
	title , 
	duration 
FROM netflix_table
WHERE 
	type = 'Movie' 
	and 
	duration = ( SELECT MAX(duration) FROM netflix_table);


-- 5. Find content added in the last 5 years

SELECT * FROM netflix_table
WHERE 
	TO_DATE(date_added , 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';


-- 6. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT 
	title, 
	director 
FROM netflix_table
WHERE director ILIKE  '%Rajiv Chilaka%';


-- 7. List all TV shows with more than 5 seasons

SELECT 
	title, 
	duration 
FROM netflix_table
WHERE 
	type = 'TV Show' and
	SPLIT_PART(duration , ' ' , 1):: numeric >= 5;


-- 8. Count the number of content items in each genre

SELECT 
	LTRIM(UNNEST(STRING_TO_ARRAY(listed_in , ','))) as "genre", 
	COUNT(*) 
FROM netflix_table
GROUP BY genre;


-- 9.Find each year and the  numbers of content release in India on netflix.
-- return top 5 year with highest content release!

SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added , 'Month DD, YYYY')) AS "year" , 
	COUNT(*) 
FROM netflix_table
WHERE country ILIKE '%India%'
GROUP BY year
ORDER BY count DESC LIMIT 5;


-- 10. List all movies that are documentaries

SELECT * FROM netflix_table
WHERE 
	listed_in ILIKE '%Documentaries' AND 
	type = 'Movie';


-- 11. Find all content without a director

SELECT * FROM netflix_table
WHERE director IS NULL;


-- 12. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT COUNT(*) FROM netflix_table
WHERE 
	casts ILIKE '%Salman Khan%' AND 
	release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;

	
-- 13. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT 
	LTRIM(UNNEST(STRING_TO_ARRAY(casts , ','))) AS actors , 
	COUNT(*) 
FROM netflix_table
WHERE 
	country ILIKE '%India%' AND 
	type = 'Movie'
GROUP BY actors
ORDER BY count DESC LIMIT 10;


-- 14. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.

WITH new_table
AS(
	SELECT * ,
		CASE
			WHEN 
				description ILIKE '%Kill%' OR 
				description ILIKE '%Violence%' THEN 'bad'
			ELSE 'good'
		END category 
	FROM netflix_table
)
SELECT category , COUNT(*) FROM new_table
GROUP BY category;