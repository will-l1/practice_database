-- 1
SELECT movie_name, movie_year, movie_viewers, box_office, 
	ROUND(movie_viewers/box_office,2) AS "money per person"
    FROM movie
    WHERE movie_year>2000;    
    
-- 2
SELECT a.actor_name, a.home_country, c.continent_name
	FROM actor a INNER JOIN country c ON (a.home_country=c.country_name)
    WHERE continent_name='N. America';
    
-- 3
SELECT COUNT(a.actor_name), c.continent_name
	FROM actor a INNER JOIN country c ON (a.home_country=c.country_name)
    GROUP BY c.continent_name;
    
-- 4
SELECT m.movie_name, m.movie_year, m.movie_viewers, m.box_office, a.actor_name, tp.genre_name
	FROM (SELECT genre_name FROM genre ORDER BY num_movies DESC LIMIT 3)tp
    INNER JOIN movie m ON (tp.genre_name = m.movie_genre)
    INNER JOIN actor a ON (m.movie_main_actor = a.actor_name)
    WHERE m.movie_year>2000
    LIMIT 50;
    
-- 5
CREATE VIEW most_successful_actor AS(
SELECT m.movie_name, m.movie_year,
	ROUND(m.movie_viewers/m.box_office,2) AS "money per person",
    a.actor_name, a.home_country, c.continent_name
    FROM movie m INNER JOIN actor a ON (a.actor_name = m.movie_main_actor)
    INNER JOIN country c ON (a.home_country=c.country_name)
    WHERE m.movie_year>2000 
    ORDER BY m.movie_viewers/m.box_office DESC
    LIMIT 50
);

SELECT * FROM most_successful_actor;

UPDATE movie
SET movie_year = 1999
WHERE movie_name IN (SELECT movie_name FROM movie 
	WHERE movie_year>2000 ORDER BY movie_viewers/box_office DESC
    LIMIT 50);

SELECT * FROM most_successful_actor;
