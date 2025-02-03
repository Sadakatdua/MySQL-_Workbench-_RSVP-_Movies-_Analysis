USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:
 
 
-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT COUNT(*) AS  total_director_mapping FROM director_mapping;
-- total_director_mapping 3867

SELECT COUNT(*) AS total_genre FROM genre;
-- total_genre 14662

SELECT COUNT(*) AS total_movie FROM movie;
-- total_movie 7997

SELECT COUNT(*) AS total_names FROM names;
-- total_names 25735

SELECT COUNT(*) AS total_ratings FROM ratings;
-- total_ratings 7997

SELECT COUNT(*) AS total_role_mapping FROM role_mapping;
-- total_role_mapping 15615

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
 -- we can solve this problem by using SUM OR COUNT funtions
 -- 1st method
 
SELECT 
		SUM(CASE 
				WHEN id IS NULL THEN 1 
                ELSE 0 END) AS id_null_count,
		SUM(CASE
				WHEN title IS NULL THEN 1
                ELSE 0 END) AS title_null_count,
		SUM(CASE
				WHEN year IS NULL THEN 1
                ELSE 0 END) AS year_null_count,
		SUM(CASE
				WHEN date_published IS NULL THEN 1
                ELSE 0 END) AS date_published_null_count,
		SUM(CASE
				WHEN duration IS NULL THEN 1
                ELSE 0 END) AS duration_null__count,
		SUM(CASE
				WHEN country IS NULL THEN 1
                ELSE 0 END) AS country_null_count,
		SUM(CASE
				WHEN worlwide_gross_income IS NULL THEN 1
                ELSE 0 END) AS worlwide_gross_income_null_count,
		SUM(CASE
				WHEN languages IS NULL THEN 1
                ELSE 0 END) AS languages_null_count,
		SUM(CASE
				WHEN production_company IS NULL THEN 1
                ELSE 0 END) AS production_company_null_count
FROM movie;

-- SELECT COUNT(*) AS row_count FROM movie;
-- 2nd method

SELECT 
		COUNT(CASE WHEN id IS NULL THEN 1 END) AS id_null_count,
		COUNT(CASE WHEN title IS NULL THEN 1 END) AS title_null_count,
		COUNT(CASE WHEN year IS NULL THEN 1 END) AS year_null_count,
		COUNT(CASE WHEN date_published IS NULL THEN 1 END) AS date_published_null_count,
		COUNT(CASE WHEN duration IS NULL THEN 1 END) AS duration_null__count,
		COUNT(CASE WHEN country IS NULL THEN 1 END) AS country_null_count,
		COUNT(CASE WHEN worlwide_gross_income IS NULL THEN 1 END) AS worlwide_gross_income_null_count,
		COUNT(CASE WHEN languages IS NULL THEN 1 END) AS languages_null_count,
		COUNT(CASE WHEN production_company IS NULL THEN 1 END) AS production_company_null_count
FROM movie;

-- results
-- Here are NULL values in the some columns in below;
--  country = 20
--  worlwide_gross_income = 3724
--  languages = 194
--  production_company = 528

-- Now as you can see four columns of the movie table that has null values. Let's look at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

-- first part
SELECT year , COUNT(id) AS no_of_movies
FROM movie 
GROUP BY year;
-- 2nd part
-- in this part we will apply EXTRACT funtion 
SELECT  
	EXTRACT(MONTH FROM date_published) AS month_num,
    COUNT(id) AS no_of_movies
FROM movie
GROUP BY month_num
ORDER BY no_of_movies DESC;

-- 2nd method
SELECT Month(date_published) AS month_num,
       Count(id) AS number_of_movies
FROM   movie
GROUP  BY month_num
ORDER  BY number_of_movies ASC;

-- AS per the analysis
-- march has highest number of movies released 
-- and december has least number of movie released

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT COUNT(id) AS  number_of_movies, year 
FROM movie
WHERE (country LIKE '%India%' OR country LIKE '%USA%')
AND year = 2019;


/* USA and India produced more than a thousand movies(1059) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT COUNT(movie_id) AS movie_id_count , genre
FROM genre
GROUP BY genre
ORDER BY genre DESC;

-- here the unique list of genres in below:
-- Drama
-- Fantasy
-- Comedy
-- Family
-- Romance
-- Adventure
-- Action
-- Sci-Fi
-- Crime
-- Mystery
-- Others
/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT g.genre  , COUNT(m.id) AS total_movies 
FROM genre g
INNER JOIN movie m
ON m.id = g.movie_id
GROUP BY genre
ORDER BY  total_movies DESC
LIMIT 1;

-- SO here DRAMA  has highet number movies produced that is 4285.


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH movies_with_one_genre
     AS (SELECT movie_id
         FROM   genre
         GROUP  BY movie_id
         HAVING Count(DISTINCT genre) = 1)
SELECT Count(*) AS movies_with_one_genre
FROM   movies_with_one_genre; 

/* There are 3289 movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

SELECT ROUND(AVG(duration),2) AS avg_duration_of_movie , genre
FROM movie m
INNER JOIN genre g
ON g.movie_id = m.id
GROUP BY genre
ORDER BY avg_duration_of_movie DESC;

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)

WITH thriller_genre_rank
     AS (SELECT g.genre,
                COUNT(m.id) AS movie_count,
                Dense_rank () OVER (ORDER BY COUNT(m.id) DESC) AS genre_rank
                FROM genre AS g
                INNER JOIN movie AS m
				ON g.movie_id = m.id
				GROUP  BY genre)
SELECT * FROM   thriller_genre_rank
WHERE  genre = 'thriller'; 

-- SO the result is 3rd rank with 1484 number of movies

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/


-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		1.0		|		10.0		|	       100		  |	   725138	    	 |		1	       |	10			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/

SELECT MIN(avg_rating) AS min_avg_rating,
       MAX(avg_rating) AS max_avg_rating ,
       MIN(total_votes) AS min_total_votes,
       MAX(total_votes) AS max_total_votes,
       MIN(median_rating) AS min_median_rating,
       MAX(median_rating) AS max_median_rating
FROM ratings;

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

-- first method
 
WITH top_10_movies
					AS( SELECT m.id AS movies, m.title AS title, r.avg_rating AS avg_rating,
						DENSE_RANK() OVER(ORDER BY r.avg_rating DESC) AS movie_rank
                        FROM ratings AS r
                        INNER JOIN movie AS m
                        ON r.movie_id = m.id
                        GROUP BY m.id
                        ORDER BY avg_rating DESC)
SELECT * FROM top_10_movies
LIMIT 10  ;  

-- 2nd method
SELECT title , avg_rating ,
					DENSE_RANK() OVER(ORDER BY  avg_rating DESC) AS movie_rank
	FROM movie AS m
    INNER JOIN ratings AS r
    ON m.id = r.movie_id
    LIMIT 10 ;
    
  /* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/      

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT r.median_rating , COUNT(m.id) AS movie_count
FROM ratings AS r
INNER JOIN movie AS m
ON r.movie_id = m.id
GROUP BY median_rating
ORDER BY COUNT(id) DESC;

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company AS production_company , COUNT(m.id) AS movie_count ,
	DENSE_RANK() OVER(ORDER BY COUNT(m.id) DESC) AS pro_company_rank
		FROM movie AS m
		INNER JOIN ratings AS r
		ON m.id = r.movie_id
	WHERE avg_rating > 8
		AND production_company IS NOT NULL
	GROUP BY production_company;
   
-- AS per the analysis DREAM WARRIOR PICTURES and NATIONAL THEATRE LIVE production both have the most number of hit movies that are 3 movies and the rating > 8

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre AS genre , 
		COUNT(m.id) AS movie_count
FROM genre AS g
		INNER JOIN movie AS m
				ON m.id = g.movie_id
        INNER JOIN ratings AS r
				ON m.id = r.movie_id
WHERE m.year = 2017
		AND MONTH(m.date_published) = 3
        AND m.country LIKE '%USA%'
        AND r.total_votes > 1000
GROUP BY genre
ORDER BY movie_count DESC;

-- In the genre DRAMA movies is released mostly that is 24 and FAMILY is the least 1.

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.title AS title , r.avg_rating AS avg_rating , g.genre AS genre
		FROM movie AS m
		INNER JOIN genre AS g
				ON m.id = g.movie_id
		INNER JOIN ratings AS r
				ON m.id = r.movie_id
WHERE title REGEXP '^The'
		AND avg_rating > 8
ORDER BY avg_rating DESC;

-- median_rating
SELECT m.title AS title , r.median_rating AS median_rating , g.genre AS genre
		FROM movie AS m
		INNER JOIN genre AS g
				ON m.id = g.movie_id
		INNER JOIN ratings AS r
				ON m.id = r.movie_id
WHERE title REGEXP '^The'
		AND median_rating > 8
ORDER BY median_rating DESC;

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.


-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
             
SELECT COUNT(m.id) AS movie_count, r.median_rating AS no_of_movies_released
		FROM movie AS m
			INNER JOIN ratings AS r
		ON m.id = r.movie_id
WHERE m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
		AND r.median_rating = 8
GROUP BY r.median_rating;

-- as we have done there are 361 movies that was released between 1 april 2018 and 1 april 2019 and median rating is 8
        
-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT m.country , 
			SUM(r.total_votes) AS total_no_of_votes
FROM movie AS m
			INNER JOIN ratings AS r
            ON m.id = r.movie_id
WHERE LOWER(m.country) = 'germany'
	  OR LOWER(m.country) = 'italy'
GROUP BY m.country
ORDER BY total_no_of_votes DESC;
  
-- AS we can see the results that German movies(106710) have more votes compared to Italian movies(77965)
-- Germany = 106710
-- Italian = 77965

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
		SUM(CASE WHEN name IS NULL 
				THEN 1 ELSE 0 END) AS name_nulls,
		SUM(CASE WHEN height IS NULL 
				THEN 1 ELSE 0 END) AS height_nulls,
		SUM(CASE WHEN date_of_birth IS NULL 
				THEN 1 ELSE 0 END) AS date_of_birth__nulls,
		SUM(CASE WHEN known_for_movies IS NULL
				THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;


-- Here are the null values in the columns name in below:
-- There are no Null value in the column 'name'
-- height_nulls = 17335
-- date_of_birth_nulls = 13431
-- known_for_movies_null = 15226



/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


WITH top_three_directors AS 
(
SELECT genre ,
			COUNT(g.movie_id) AS movie_count,
			DENSE_RANK() OVER(ORDER BY COUNT(g.movie_id) DESC) AS genre_rank
FROM genre AS g
			INNER JOIN ratings AS r
			ON g.movie_id = r.movie_id
WHERE avg_rating >8
GROUP BY genre
LIMIT 3
)
SELECT n.name AS director_name ,
			COUNT(dm.movie_id) AS movie_count
FROM director_mapping AS dm
			INNER JOIN genre AS g USING (movie_id)
            INNER JOIN names AS n
				ON dm.name_id = n.id
			INNER JOIN top_three_directors USING (genre)
			INNER JOIN ratings USING (movie_id)
WHERE avg_rating >8
GROUP BY n.name
ORDER BY movie_count
LIMIT 3;
            
                   -- AS per the analysis top 3 directors with moves are below:
-- 'Arjun Prabhakaran', '1'
-- 'Ivo van Hove', '1'
-- 'Vipul Mehta', '1'

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

             
 -- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:                   
SELECT n.name AS actor_name,
				COUNT(rm.movie_id) AS movie_count
FROM role_mapping AS rm
				INNER JOIN movie AS m
					ON m.id = rm.movie_id
				INNER JOIN ratings AS r USING(movie_id)
                INNER JOIN names AS n
					ON n.id = rm.name_id
WHERE r.median_rating >= 8
		AND category = "actor"
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2;
           
-- Here are the top 2 actor and their number of movies in below:
-- Mammootty = 8
-- Mohanlal  = 5             
                    
 /* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/                   
                    
-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:      
SELECT m.production_company AS production_company, SUM(total_votes) AS vote_count , 
			DENSE_RANK() OVER(ORDER BY SUM(total_votes) DESC) AS pro_comp_rank
FROM movie AS m
			INNER JOIN ratings AS r
				ON m.id = r.movie_id
GROUP BY production_company
ORDER BY vote_count DESC
LIMIT 3;

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH rank_actors AS 
( SELECT 
	name AS actor_name, 
    Sum(total_votes) AS total_votes, 
    Count(rm.movie_id) AS movie_count, 
    Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actor_avg_rating 
FROM role_mapping as rm 
	INNER JOIN 
		names as n 
		ON rm.name_id = n.id 
    INNER JOIN 
		ratings as r 
		ON rm.movie_id = r.movie_id 
    INNER JOIN 
		movie as m
        ON rm.movie_id = m.id 
WHERE category = 'actor' AND country LIKE '%India%' 
GROUP BY name_id, name 
HAVING Count(DISTINCT rm.movie_id) >= 5)
SELECT *, 
DENSE_Rank() OVER (ORDER BY actor_avg_rating DESC) AS actor_rank 
FROM rank_actors
LIMIT 3;             
                    
 -- Top actor is Vijay Sethupathi
               
 -- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:                  
SELECT n.name AS actress_name,
			SUM(total_votes) AS total_votes,
            COUNT(m.id) AS movie_count,
            ROUND(SUM(avg_rating * total_votes)/SUM(total_votes) , 2) AS actress_avg_rating,
            DENSE_RANK() OVER(ORDER BY ROUND(SUM(avg_rating * total_votes)/SUM(total_votes) , 2) DESC) AS actress_rank
FROM names AS n
			INNER JOIN role_mapping AS rm
				ON n.id = rm.name_id
			INNER JOIN movie AS m
				ON m.id = rm.movie_id
			INNER JOIN ratings AS r
				ON m.id = r.movie_id
WHERE rm.category ='ACTRESS'
			AND m.languages LIKE '%Hindi%'
            AND m.country ='INDIA'
GROUP BY n.name
HAVING COUNT(m.id) >=3
LIMIT 5;
			
/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/            
            
 /* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:           
	
SELECT m.title AS movie_name,
			avg_rating ,
					CASE 
						WHEN avg_rating >= 8 THEN "Superhit movies"
						WHEN avg_rating BETWEEN 7 AND 8 THEN "Hit movies"
                        WHEN avg_rating BETWEEN 5 AND 7 THEN "One-time-watch movies"
                        ELSE "Flop movies"
					END AS avg_rating_catecary
FROM movie AS m
					INNER JOIN genre AS g
						ON m.id = g.movie_id
					INNER JOIN ratings AS r
						ON r.movie_id = m.id
WHERE genre= "thriller"; 
		
 /* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/
 
-- Segment 4: 
 
 -- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
 
SELECT genre,
       ROUND(AVG(duration),2) AS avg_duration,
        SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
        AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS 10 PRECEDING) AS moving_avg_duration
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
GROUP  BY genre;

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of mo
WITH top_3_genre AS
(
	SELECT   genre,
				Count(movie_id) AS movie_count,
				Rank() OVER(ORDER BY Count(movie_id) DESC) AS genre_rank
	FROM     genre
    GROUP BY genre limit 3 
), 
find_rank AS
(
	SELECT     genre,
				year,
				title AS movie_name,
				worlwide_gross_income,
				DENSE_Rank() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
	FROM       movie AS m
         INNER JOIN genre AS g
				ON m.id=g.movie_id
	WHERE      genre IN
						(SELECT genre
                             FROM   top_3_genre) )
SELECT *
FROM   find_rank
WHERE  movie_rank<=5;
 
-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below: 
 SELECT     production_company,
           Count(id)                                  AS movie_count,
           Row_number() OVER(ORDER BY Count(id) DESC) AS prod_comp_rank
FROM       movie m
INNER JOIN ratings r
ON         m.id = r.movie_id
WHERE      median_rating>=8
AND        production_company IS NOT NULL
AND        position(',' IN languages)>0
GROUP BY   production_company limit 2;
 
 -- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language
 
 -- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
 
 SELECT     name AS actress_name,
           Sum(total_votes) AS total_votes,
           Count(rm.movie_id) AS movie_count,
           Round(Sum(avg_rating * total_votes)/Sum(total_votes),2) AS actress_avg_rating,
           Dense_rank() OVER(ORDER BY Count(rm.movie_id) DESC) AS actress_rank
FROM       names n
	INNER JOIN role_mapping rm
		ON n.id = rm.name_id
	INNER JOIN ratings r
		ON r.movie_id = rm.movie_id
	INNER JOIN genre g
		ON g.movie_id = r.movie_id
WHERE      category="actress" AND avg_rating > 8
			AND g.genre="Drama"
GROUP BY   NAME 
limit 3;
 
 /* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
 WITH t_date_summary AS
(
	SELECT     d.name_id,
				name,
				d.movie_id,
				duration,
                r.avg_rating,
                total_votes,
                m.date_published,
                Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
    FROM       director_mapping    AS d
		INNER JOIN names           AS n
           ON         n.id = d.name_id
		INNER JOIN movie AS m
           ON         m.id = d.movie_id
		INNER JOIN ratings AS r
           ON         r.movie_id = m.id 
), 
top_director_summary AS
(
	SELECT *,
              Datediff(next_date_published, date_published) AS date_difference
	FROM   t_date_summary )
SELECT   name_id AS director_id,
         name AS director_name,
         Count(movie_id) AS number_of_movies,
         Round(Avg(date_difference),2) AS avg_inter_movie_days,
         Round(Avg(avg_rating),2) AS avg_rating,
         Sum(total_votes)AS total_votes,
         Min(avg_rating) AS min_rating,
         Max(avg_rating) AS max_rating,
         Sum(duration)   AS total_duration
FROM     top_director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;
 
 ----------------------------------------------- THANK YOU --------------------------------------------------------