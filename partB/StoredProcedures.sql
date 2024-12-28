-- stored procedure 1
DELIMITER $$
DROP PROCEDURE IF EXISTS new_movie$$
CREATE PROCEDURE new_movie(
	IN new_movie_name varchar(100),
    IN new_movie_year int,
    IN new_movie_genre varchar(100),
    IN new_movie_country varchar(100),
    IN new_movie_actor varchar(100),
    IN new_movie_comp varchar(100))
    
BEGIN
	DECLARE temp int; -- declare variable
    START TRANSACTION; -- transation start
	IF new_movie_name IS NULL THEN -- if wrong value
		SELECT "Enter the name of the movie!";
    ELSEIF new_movie_genre NOT IN(SELECT genre_name FROM genre) THEN -- if wrong value
		SELECT "Not valid!";
	ELSEIF new_movie_country NOT IN(SELECT country_name FROM country) THEN -- if wrong value
		SELECT "Not valid!";
	ELSEIF new_movie_actor NOT IN(SELECT actor_name FROM actor) THEN -- if wrong value
		SELECT "Not valid!";
	ELSEIF new_movie_comp NOT IN(SELECT company_name FROM company) THEN -- if wrong value
		SELECT "Not valid!";
	ELSE                     -- if has working values
		INSERT INTO movie(movie_name, movie_year, movie_genre, movie_country, movie_main_actor, production_company) -- insert value
			VALUES(new_movie_name,new_movie_year,new_movie_genre,new_movie_country,new_movie_actor,new_movie_comp);
		SELECT num_movies INTO temp FROM genre      -- use variable
			WHERE genre_name = new_movie_genre;
		UPDATE genre                                -- update other tables by adding 1 to number of movies
			SET num_movies = temp+1
            WHERE genre_name = new_movie_genre;
		SELECT num_movie INTO temp FROM actor        -- use variable
			WHERE actor_name = new_movie_actor;
		UPDATE actor                                -- update other tables by adding 1 to number of movies
			SET num_movie = temp+1
            WHERE actor_name = new_movie_actor;
		SELECT num_movie INTO temp FROM company         -- use variable
			WHERE company_name = new_movie_comp;
		UPDATE company                                -- update other tables by adding 1 to number of movies
			SET num_movie = temp+1
            WHERE company_name = new_movie_comp;
		SELECT * 
			FROM movie
            WHERE movie_name=new_movie_name; -- show result
	COMMIT;
	END IF;
END;
$$
DELIMITER ;

SET @new_movie_name := "Random good thing";
SET @new_movie_year := 2010;
SET @new_movie_genre := "Adventure";
SET @new_movie_country := "Afghanistan";
SET @new_movie_actor := "Tom Hanks";
SET @new_movie_comp := "Paramount Pictures";
-- test with correct value(all used line 1)
CALL new_movie(@new_movie_name,@new_movie_year,@new_movie_genre,@new_movie_country,@new_movie_actor,@new_movie_comp);

SET @new_movie_name := "Random bad thing";
SET @new_movie_year := 2010;
SET @new_movie_genre := "Boring!";
SET @new_movie_country := "somewhere";
SET @new_movie_actor := "who is that again";
SET @new_movie_comp := "there should be one... maybe?";
-- test with wrong value
CALL new_movie(@new_movie_name,@new_movie_year,@new_movie_genre,@new_movie_country,@new_movie_actor,@new_movie_comp);




DELIMITER $$
DROP PROCEDURE IF EXISTS movie_update$$
CREATE PROCEDURE movie_update(
	IN movie_title varchar(100),
    IN num_viewers int,
    IN box_office int,
    IN trash int)
BEGIN
	DECLARE temp int; -- declare variable
    START TRANSACTION; -- transation start
	IF movie_title NOT IN(SELECT movie_name FROM movie) THEN -- check for found movie
		SELECT "not found!"; -- not found
	ELSEIF movie_title IS NULL THEN
		SELECT "Enter the name of the movie!";
	ELSE
		IF trash = 1234567 THEN -- set to password in case of accident
			SELECT num_movies INTO temp FROM genre      -- use variable
				WHERE genre_name = (SELECT movie_genre FROM movie WHERE movie_name = movie_title);
			UPDATE genre                                -- update other tables by subtracting 1 to number of movies
				SET num_movies = temp-1
				WHERE genre_name = (SELECT movie_genre FROM movie WHERE movie_name = movie_title);
			SELECT num_movie INTO temp FROM actor        -- use variable
				WHERE actor_name = (SELECT movie_main_actor FROM movie WHERE movie_name = movie_title);
			UPDATE actor                                -- update other tables by subtracting 1 to number of movies
				SET num_movie = temp-1
				WHERE actor_name = (SELECT movie_main_actor FROM movie WHERE movie_name = movie_title);
			SELECT num_movie INTO temp FROM company         -- use variable
				WHERE company_name = (SELECT production_company FROM movie WHERE movie_name = movie_title);
			UPDATE company                                -- update other tables by subtracting 1 to number of movies
				SET num_movie = temp-1
				WHERE company_name = (SELECT production_company FROM movie WHERE movie_name = movie_title);
			SELECT * 
			FROM movie
            WHERE movie_name=movie_title; -- show result
			DELETE FROM movie
				WHERE movie_title = movie_name; -- delete
		ELSE
			IF movie_viewers >0 AND box_office > 0 THEN -- if working
				UPDATE movie
					SET movie_viewers=num_viewers,
						box_office = box_office
                    WHERE movie_title = movie_name; -- update info
				SELECT * 
					FROM movie
					WHERE movie_name=movie_title; -- show result
            ELSE
				SELECT "Please provide valid data";-- NOT VALID
            END IF;
		END IF;
        COMMIT;
    END IF;
END;
$$
DELIMITER ;


SET @movie_title := "A Quiet Place Part II";
SET @num_viewers := 8000000;
SET @box_office := 200000000;
SET @trash := 0;
-- test with correct value
CALL movie_update(@movie_title,@num_viewers,@box_office,@trash);


SET @movie_title := "not a movie name ---- not";
SET @num_viewers := 8000000;
SET @box_office := 200000000;
SET @trash := 0;
-- test with wrong value
CALL movie_update(@movie_title,@num_viewers,@box_office,@trash);

SET @movie_title := "Random good thing";
SET @num_viewers := 1000000;
SET @box_office := 5000000000;
SET @trash := 0;
-- I wonder is this works
CALL movie_update(@movie_title,@num_viewers,@box_office,@trash);
