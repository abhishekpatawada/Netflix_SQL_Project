# Netflix_SQL_Project
![Query Output](logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT 
	type , 
	COUNT(*) as "type_count" 
FROM netflix_table
GROUP BY type;
```

### 2. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT * FROM netflix_table
WHERE type = 'Movie' and release_year = 2020;
```

### 3. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT 
	LTRIM(UNNEST(STRING_TO_ARRAY(country, ','))) as new_country,
	COUNT(show_id) as "count" FROM netflix_table
GROUP BY new_country
ORDER BY count DESC LIMIT 5;
```

### 4. Identify the Longest Movie

```sql
SELECT 
	title , 
	duration 
FROM netflix_table
WHERE 
	type = 'Movie' 
	and 
	duration = ( SELECT MAX(duration) FROM netflix_table);
```

### 5. Find Content Added in the Last 5 Years

```sql
SELECT * FROM netflix_table
WHERE 
	TO_DATE(date_added , 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

### 6. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT 
	title, 
	director 
FROM netflix_table
WHERE director ILIKE  '%Rajiv Chilaka%';
```

### 7. List All TV Shows with More Than 5 Seasons

```sql
SELECT 
	title, 
	duration 
FROM netflix_table
WHERE 
	type = 'TV Show' and
	SPLIT_PART(duration , ' ' , 1):: numeric >= 5;
```

### 8. Count the Number of Content Items in Each Genre

```sql
SELECT 
	LTRIM(UNNEST(STRING_TO_ARRAY(listed_in , ','))) as "genre", 
	COUNT(*) 
FROM netflix_table
GROUP BY genre;
```

### 9.Find each year and the average numbers of content release in India on netflix. 
### return top 5 year with highest avg content release!

```sql
SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added , 'Month DD, YYYY')) AS "year" , 
	COUNT(*) 
FROM netflix_table
WHERE country ILIKE '%India%'
GROUP BY year
ORDER BY count DESC LIMIT 5;
```

### 10. List All Movies that are Documentaries

```sql
SELECT * FROM netflix_table
WHERE 
	listed_in ILIKE '%Documentaries' AND 
	type = 'Movie';
```

### 11. Find All Content Without a Director

```sql
SELECT * FROM netflix_table
WHERE director IS NULL;
```

### 12. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT COUNT(*) FROM netflix_table
WHERE 
	casts ILIKE '%Salman Khan%' AND 
	release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

### 13. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
SELECT 
	LTRIM(UNNEST(STRING_TO_ARRAY(casts , ','))) AS actors , 
	COUNT(*) 
FROM netflix_table
WHERE 
	country ILIKE '%India%' AND 
	type = 'Movie'
GROUP BY actors
ORDER BY count DESC LIMIT 10;
```

### 14. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```
