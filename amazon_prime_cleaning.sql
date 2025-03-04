-- Amazon Prime Titles Data Cleaning

SELECT *
FROM amazon_prime_titles;

-- Creating separate table as to not work on raw data table

CREATE TABLE prime_video
LIKE amazon_prime_titles;

SELECT *
FROM prime_video;

INSERT prime_video
SELECT *
FROM amazon_prime_titles;


-- Check for duplicates using unique show_id

SELECT * 
FROM
(
SELECT show_id, COUNT(*) AS count
FROM prime_video
GROUP BY show_id
ORDER BY show_id DESC
) AS dup
WHERE count > 1;

-- Checking for Null Values

SELECT *
FROM prime_video;

-- director, cast, country, date_added, and ratings contain empty fields
-- Converting empty fields into Null Values to later populate columns

SELECT director, NULLIF(director, '') AS director_null
FROM prime_video;

SELECT cast, NULLIF(cast, '') AS cast_null
FROM prime_video;

SELECT country, NULLIF(country, '') AS country_null
FROM prime_video;

SELECT date_added, NULLIF(date_added, '') AS date_null
FROM prime_video;

SELECT rating, NULLIF(rating, '') AS rating_null
FROM prime_video;

UPDATE prime_video
SET director = NULLIF(director, ''),
cast = NULLIF(cast, ''),
country = NULLIF(country, ''),
date_added = NULLIF(date_added, ''),
rating = NULLIF(rating, '');

SELECT *
FROM prime_video;

-- Finding total number of Null values across all columns

WITH NullCounts AS (
SELECT
	COUNT(CASE WHEN show_id IS NULL THEN 1 END) AS id_null,
    COUNT(CASE WHEN type IS NULL THEN 1 END) AS type_null,
    COUNT(CASE WHEN title IS NULL THEN 1 END) AS title_null,
    COUNT(CASE WHEN director IS NULL THEN 1 END) AS director_null,
    COUNT(CASE WHEN cast IS NULL THEN 1 END) AS cast_null,
    COUNT(CASE WHEN country IS NULL THEN 1 END) AS country_null,
    COUNT(CASE WHEN date_added IS NULL THEN 1 END) AS date_null,
    COUNT(CASE WHEN release_year IS NULL THEN 1 END) AS year_null,
    COUNT(CASE WHEN rating IS NULL THEN 1 END) AS rating_null,
    COUNT(CASE WHEN duration IS NULL THEN 1 END) AS duration_null,
    COUNT(CASE WHEN listed_in IS NULL THEN 1 END) AS listed_null,
    COUNT(CASE WHEN description IS NULL THEN 1 END) AS description
FROM prime_video
)
SELECT * FROM NullCounts;    

-- director: 2075 null values
-- cast: 1233 null values
-- country: 8943 null values 
-- date added: 9460 null values
-- rating: 335 null values

SELECT *
FROM prime_video;

-- Populating director column by finding correlation between director and cast

SELECT pv.cast, pv.director, pv2.cast, pv2.director, COALESCE(pv.director, pv2.director)
FROM prime_video as pv
JOIN prime_video as pv2
	ON pv.cast = pv2.cast
    AND pv.show_id <> pv2.show_id
WHERE pv.director IS NULL;


UPDATE prime_video AS pv
JOIN prime_video as pv2
	ON pv.cast = pv2.cast
    AND pv.show_id <> pv2.show_id
SET pv.director = pv2.director
WHERE pv.director IS NULL
	AND pv2.director IS NOT NULL;


SELECT pv.listed_in, pv.director, pv2.listed_in, pv2.director, COALESCE(pv.director, pv2.director)
FROM prime_video as pv
JOIN prime_video as pv2
	ON pv.listed_in = pv2.listed_in
    AND pv.show_id <> pv2.show_id
WHERE pv.director IS NULL
	AND pv2.director IS NOT NULL
	AND (pv.director <> pv2.director OR pv.director IS NULL);

-- Genre of show/film has strong correlation with director
-- Using listed_in column to further populate director column

UPDATE prime_video AS pv
JOIN prime_video as pv2
	ON pv.listed_in = pv2.listed_in
    AND pv.show_id <> pv2.show_id
SET pv.director = pv2.director
WHERE pv.director IS NULL
	AND pv2.director IS NOT NULL;

-- director: 196 nulls


-- Populating country column

SELECT pv.director, pv.country, pv2.director, pv2.country, COALESCE(pv.country, pv2.country)
FROM prime_video as pv
JOIN prime_video as pv2
	ON pv.director = pv2.director
    AND pv.show_id <> pv2.show_id
WHERE pv.country IS NULL
	AND pv2.country IS NOT NULL
	AND (pv.country <> pv2.country OR pv.country IS NULL);
    

UPDATE prime_video AS pv
JOIN prime_video AS pv2
  ON pv.director = pv2.director
 AND pv.show_id <> pv2.show_id
SET pv.country = pv2.country
WHERE pv.country IS NULL
  AND pv2.country IS NOT NULL;

-- Determining whether country column can further be populated using cast column

SELECT pv.cast, pv.country, pv2.cast, pv2.country, COALESCE(pv.country, pv2.country)
FROM prime_video as pv
JOIN prime_video as pv2
	ON pv.cast = pv2.cast
    AND pv.show_id <> pv2.show_id
WHERE pv.country IS NULL
	AND pv2.country IS NOT NULL
	AND (pv.country <> pv2.country OR pv.country IS NULL);

UPDATE prime_video AS pv
JOIN prime_video AS pv2
  ON pv.cast = pv2.cast
 AND pv.show_id <> pv2.show_id
SET pv.country = pv2.country
WHERE pv.country IS NULL
  AND pv2.country IS NOT NULL;

-- country: 7541 nulls


-- Populating rating column using director column

SELECT pv.director, pv.rating, pv2.director, pv2.rating, COALESCE(pv.rating, pv2.rating)
FROM prime_video as pv
JOIN prime_video as pv2
	ON pv.director = pv2.director
    AND pv.show_id <> pv2.show_id
WHERE pv.rating IS NULL
	AND pv2.rating IS NOT NULL
	AND (pv.rating <> pv2.rating OR pv.rating IS NULL);

UPDATE prime_video AS pv
JOIN prime_video AS pv2
	ON pv.director = pv2.director
    AND pv.show_id <> pv2.show_id
SET pv.rating = pv2.rating
WHERE pv.rating IS NULL
AND pv2.rating IS NOT NULL;

-- Populating rating column using cast column

SELECT pv.cast, pv.rating, pv2.cast, pv2.rating, COALESCE(pv.rating, pv2.rating)
FROM prime_video as pv
JOIN prime_video as pv2
	ON pv.cast = pv2.cast
    AND pv.show_id <> pv2.show_id
WHERE pv.rating IS NULL
	AND pv2.rating IS NOT NULL
	AND (pv.rating <> pv2.rating OR pv.rating IS NULL);

UPDATE prime_video AS pv
JOIN prime_video AS pv2
	ON pv.cast = pv2.cast
    AND pv.show_id <> pv2.show_id
SET pv.rating = pv2.rating
WHERE pv.rating IS NULL
AND pv2.rating IS NOT NULL;

-- Populating rating column using listed_in column

SELECT pv.listed_in, pv.rating, pv2.listed_in, pv2.rating, COALESCE(pv.rating, pv2.rating)
FROM prime_video as pv
JOIN prime_video as pv2
	ON pv.listed_in = pv2.listed_in
    AND pv.show_id <> pv2.show_id
WHERE pv.rating IS NULL
	AND pv2.rating IS NOT NULL
	AND (pv.rating <> pv2.rating OR pv.rating IS NULL);

UPDATE prime_video AS pv
JOIN prime_video AS pv2
	ON pv.listed_in = pv2.listed_in
    AND pv.show_id <> pv2.show_id
SET pv.rating = pv2.rating
WHERE pv.rating IS NULL
AND pv2.rating IS NOT NULL;

SELECT *
FROM prime_video;

-- rating: 2 null values

-- Dropping unnecessary columns

ALTER TABLE prime_video
DROP COLUMN cast,
DROP COLUMN date_added,
DROP COLUMN description;

SELECT country
FROM prime_video;

-- Some fields in country column contain multiple countries
-- Cleaning up country column to state primary country show/film was filmed in

WITH prim_country AS (
    SELECT 
	show_id,
	SUBSTRING_INDEX(country, ',', 1) AS primary_country
    FROM prime_video
)
UPDATE prime_video pv
JOIN prim_country pc ON pv.show_id = pc.show_id
SET pv.country = pc.primary_country;

-- Setting the leftover null values as 'Unknown'

UPDATE prime_video
SET 
director = CASE WHEN director IS NULL THEN 'Unknown' ELSE director END,
country = CASE WHEN country IS NULL THEN 'Unknown' ELSE country END,
rating = CASE WHEN rating IS NULL THEN 'Unknown' ELSE rating END;

-- Comparing between raw data and cleaned up data

SELECT *
FROM amazon_prime_titles;

SELECT *
FROM prime_video;



