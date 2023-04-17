
--Sign up for a free Snowfalke trial account using link provided in the Readme file


-- Create a new Snowflake warehouse , database and schema
CREATE WAREHOUSE LIGHTSPEED_WH;
CREATE DATABASE STAR_WARS_DB;
CREATE SCHEMA SW_DATA;

-- Create an internal stage to upload the csv files
Create or replace stage my_stage;

/*You can download SnowSQL from the link provided in the Readme file and 
then connect to your Snowflake account by running the following command in the terminal*/

snowsql -a <account_name> -u <username>


-- Upload the csv into stage by running the below command in SnowSQL(CLI)
PUT file:///<path_to_local_file>/Star_wars_characters.csv @my_stage;
PUT file:///<path_to_local_file>/star_wars_movie_ratings.csv @my_stage;
PUT file:///<path_to_local_file>/star_wars_survey.csv @my_stage;
--Note: You would need to replace <path_to_local_file> with the actual path to the star_wars_characters.csv file on your local machine.

--Run the below commands in SnowSQL

use database STAR_WARS_DB;
use schema SW_DATA;


--This command is used to list the files in the internal stage named my_stage.
list @my_stage;


-- Create a table to store Star Wars character information
CREATE OR REPLACE TABLE STAR_WARS_DB.SW_DATA.CHARACTERS
(
name varchar(10000),
height varchar(1000),
mass varchar(1000),
hair_color varchar(1000),
skin_color varchar(1000),
eye_color varchar(1000),
birth_year varchar(1000),
gender varchar(1000),
homeworld varchar(1000),
species varchar(10000)
);


-- Create a table to store movie ratings information
CREATE OR REPLACE TABLE STAR_WARS_DB.SW_DATA.MOVIE_RATING (
Year INT,
Title VARCHAR(255),
Rated VARCHAR(10),
Released DATE,
Runtime INT,
Director VARCHAR(255),
Awards VARCHAR(255),
Metascore INT,
imdbVotes INT,
imdbRating DECIMAL(3,1),
RottenTomatoScore DECIMAL(3,2),
Globalboxoffice_revenue number
);

-- Create a table to store Star Wars survey data
CREATE OR REPLACE TABLE STAR_WARS_DB.SW_DATA.Star_wars_survey (
RespondentID varchar(1000),
Have_you_seen_any_of_the_6_films_in_the_Star_Wars_franchise varchar(1000),
Do_you_consider_yourself_to_be_a_fan_of_the_Star_Wars_film_franchise varchar(1000),
Episode_1 varchar(1000),
Episode_2 varchar(1000),
Episode_3 varchar(1000),
Episode_4 varchar(1000),
Episode_5 varchar(1000),
Episode_6 varchar(1000),
Rating_Episode_1 varchar(1000),
Rating_Episode_2 varchar(1000),
Rating_Episode_3 varchar(1000),
Rating_Episode_4 varchar(1000),
Rating_Episode_5 varchar(1000),
Rating_Episode_6 varchar(1000),
Rate_Han_Solo varchar(1000),
Rate_Luke_Skywalker varchar(1000),
Rate_Princess_Leia_Organa varchar(1000),
Rate_Anakin_Skywalker varchar(1000),
Rate_Obi_Wan_Kenobi varchar(1000),
Rate_Emperor_Palpatine varchar(1000),
Rate_Darth_Vader varchar(1000),
Rate_Lando_Calrissian varchar(1000),
Rate_Boba_Fett varchar(1000),
rate_C_3P0 varchar(1000),
Rate_R2_D2 varchar(1000),
Rate_Jar_Jar_Binks varchar(1000),
Rate_Padme_Amidala varchar(1000),
Rate_Yoda varchar(1000),
Do_you_consider_yourself_to_be_a_fan_of_the_Star_Trek_franchise varchar(1000),
Gender varchar(1000),
Age varchar(1000),
Education varchar(1000)
);

-- Copy data from the CSV files to the MOVIE_RATING table
COPY INTO STAR_WARS_DB.SW_DATA.MOVIE_RATING
FROM @my_stage/star_wars_movie_ratings.csv
FILE_FORMAT = (TYPE = CSV, FIELD_DELIMITER = ',', SKIP_HEADER = 1)
ON_ERROR = 'CONTINUE';

-- Verify if the MOVIE_RATING table was loaded successfully
SELECT * FROM STAR_WARS_DB.SW_DATA.MOVIE_RATING;

-- Copy data from the CSV files to the CHARACTERS table
COPY INTO STAR_WARS_DB.SW_DATA.CHARACTERS
FROM @my_stage/Star_wars_characters.csv
FILE_FORMAT = (TYPE = CSV, FIELD_DELIMITER = ',', SKIP_HEADER = 1)
ON_ERROR = 'CONTINUE';

-- Verify if the CHARACTERS table was loaded successfully
SELECT * FROM STAR_WARS_DB.SW_DATA.CHARACTERS;

-- Copy data from the CSV files to the Star_wars_survey table
COPY INTO STAR_WARS_DB.SW_DATA.STAR_WARS_SURVEY
FROM @my_stage/star_wars_survey.csv
FILE_FORMAT = (TYPE = CSV, FIELD_DELIMITER = ',',SKIP_HEADER = 1)
ON_ERROR = 'CONTINUE';

-- Verify if the STAR_WARS_SURVEY table was loaded successfully
SELECT * FROM STAR_WARS_DB.SW_DATA.CHARACTERS;


--- These queries were used to build a dashboard that displays data related to Star Wars movies and characters 

--- Query 1: Returns the total count of characters in the characters table.
---Represented as First scorecard in dashboard
select count(name) from characters;

--- Query 2: Calculates the average global box office revenue for all Star Wars movies.
---Represented as second scorecard in dashboard
select round(avg(globalboxoffice_revenue), 2) as Avg_revenue from movie_rating;
--after adding filter
select round(avg(globalboxoffice_revenue), 2) as Avg_revenue
from movie_rating where title = :title;

--- Query 3: Calculates the average runtime for all Star Wars movies.
--- Represented as third scorecard in dashboard
select round(avg(runtime),2) as avg_runtime  from movie_rating;
--after filter
select round(avg(runtime),2) as avg_runtime  from movie_rating where title=:title;

--Query 4 : This query returns the release year and title of all Star Wars movies
--represented as table in dashboard
select year,TITLE as Movie from movie_rating order by year;


--- Query 5 :Returns the year, IMDB rating, Rotten Tomatoes score and metascore for each of the Star Wars movie,
--- Represented as line chart in dashboard
select year,
(imdbrating*10) as imdbrating,
(rottentomatoscore*100) as rottentomatoscore, 
metascore as metascore 
from movie_rating order by year;

----Query 6: Returns movie title , globalboxoffice_revenue_in_millions and awards won by each movie
--- Represented as bar chart in dashboard
select title as movie, globalboxoffice_revenue as globalboxoffice_revenue_in_millions,AWARDS from movie_rating 
order by globalboxoffice_revenue,AWARDS;

--after filter
select title as movie, globalboxoffice_revenue as globalboxoffice_revenue_in_millions,AWARDS from movie_rating 
where title=:title
order by globalboxoffice_revenue,AWARDS;


---Query 7 : This query calculates the average Metascore and total number of movies directed by each director in the movie_rating table
--- Represented as a heatgrid on dashboard
WITH CTE AS (
    SELECT
        DIRECTOR,
        AVG(METASCORE) AS AVG_METASCORE,
        COUNT(DIRECTOR) as total_movies_directed
    FROM
        MOVIE_RATING
    GROUP BY
        DIRECTOR
)
SELECT
    TITLE,
    M.DIRECTOR,
    AVG_METASCORE,
    total_movies_directed
FROM
    MOVIE_RATING M
    LEFT JOIN CTE C ON M.DIRECTOR = C.DIRECTOR
    
    

--Query 8 : This query returns the name, homeworld, and species for all Star Wars characters in the
--Represented as a table in dashboard
select name,homeworld,species from characters;
--after filter
select name,homeworld,species from characters  where species=:species and homeworld=:homeworld

---Query 9 : This query counts the number of characters belonging to a specific species and living on a specific homeworld
select count(name),homeworld,species from characters  
and species<>'NA' and homeworld<>'NA'
group by homeworld,species;

--after filter
select count(name),homeworld,species from characters where species=:species and homeworld=:homeworld
and species<>'NA' and homeworld<>'NA'
group by homeworld,species;

--Query 10 :  This query returns the average mass and average height for each Star Wars character in the characters table
--Represented as scatter plot in dashboard
SELECT name, ROUND(AVG(mass),2) AS avg_mass,round(AVG(HEIGHT),2) AS avg_height
FROM characters 
GROUP BY name 
order by avg_height desc;

--Query 11:This query calculates the number of "very favorable" ratings for each Star Wars character based on responses from a survey.
SELECT 
  character_name, 
  SUM(CASE WHEN rating = 'Very favorably' THEN 1 ELSE 0 END) AS very_favorable
FROM (
  SELECT 'Luke Skywalker' AS character_name, RATE_LUKE_SKYWALKER AS rating FROM star_wars_survey
  UNION ALL SELECT 'Han Solo', RATE_HAN_SOLO FROM star_wars_survey
  UNION ALL SELECT 'Princess Leia', RATE_PRINCESS_LEIA_ORGANA FROM star_wars_survey
  UNION ALL SELECT 'Anakin Skywalker', RATE_ANAKIN_SKYWALKER FROM star_wars_survey
  UNION ALL SELECT 'Obi Wan', RATE_OBI_WAN_KENOBI FROM star_wars_survey
  UNION ALL SELECT 'Darth Vader', RATE_DARTH_VADER FROM star_wars_survey
  UNION ALL SELECT 'C3PO', RATE_C_3P0 FROM star_wars_survey
  UNION ALL SELECT 'R2_D2', RATE_R2_D2 FROM star_wars_survey
  UNION ALL SELECT 'Yoda', RATE_YODA FROM star_wars_survey
  UNION ALL SELECT 'Jar Jar Binks', RATE_JAR_JAR_BINKS FROM star_wars_survey
) AS character_ratings
WHERE rating IS NOT NULL
GROUP BY character_name;












