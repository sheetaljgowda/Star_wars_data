## Environment Setup
Copy these SQL statements into a Snowflake Worksheet, select all and execute them 

``` sql
-- Create the database and schema 
--Note: For the sake of simplicity, the ACCOUNTADMIN role was used to create the database and schemas,
--although it is worth noting that typically the SYSADMIN role would be responsible for this task.

USE ROLE ACCOUNTADMIN;
CREATE OR REPLACE DATABASE STAR_WARS_DB;
CREATE OR REPLACE SCHEMA SW_DATA;
```
 
## Snowflake data load
 
 ```sql
-- Create two tables 
-- Table to store Star Wars character information
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

-- Table to store movie ratings information
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
 ```
Download the csv files from [here](star_wars_datasets/) and Load the data through snowsight by selecting the table and clicking on load data and selecting the file format

Note: Select the file format as CSV and don't forget to skip one line of the header

 ```sql

-- Verify if the CHARACTERS table was loaded successfully
SELECT * FROM STAR_WARS_DB.SW_DATA.CHARACTERS;

-- Verify if the MOVIE_RATING table was loaded successfully
SELECT * FROM STAR_WARS_DB.SW_DATA.MOVIE_RATING;

 ```
 ### Create custom filters using the below queries 
 These filters will be used in the Snowsight dashboard queries so make sure to name SQL Keyword correctly
 
 ```sql
 
  --homeworld filter
--SQL Keyword : homeworld  
select distinct homeworld from STAR_WARS_DB.SW_DATA.CHARACTERS;
 ```
 
 ```sql
--species filter
--SQL Keyword : species 
select distinct species from STAR_WARS_DB.SW_DATA.CHARACTERS;
 ```
 
  ```sql
--movie_title filter
--SQL Keyword : title 
select distinct title from STAR_WARS_DB.SW_DATA.movie_rating;

  ```
 
 
 ### Queries to build the Snowsight dashboard 
Note: Make sure to select warehouse LIGHTSPEED_WH and ROLE ACCOUNTADMIN before executing the below queries.
 
Query 1: This query returns the total count of characters in the characters table.
   ```sql
---Represented as First scorecard in dashboard
--- Title: Total Characters in Dataset
select count(name) AS Total from STAR_WARS_DB.SW_DATA.characters;
  ```
Query 2: This query calculates the average global box office revenue for all Star Wars movies.
  ```sql
---Represented as second scorecard in dashboard
--- Title: Avg Revenue in Million
select round(avg(globalboxoffice_revenue), 2) as Avg_revenue
from STAR_WARS_DB.SW_DATA.movie_rating where title = :title;
 ```

Query 3: This query calculates the average runtime for all Star Wars movies.
  ```sql
--- Represented as third scorecard in dashboard
--Title: Average Runtime in minutes
select round(avg(runtime),2) as avg_runtime  from STAR_WARS_DB.SW_DATA.movie_rating where title=:title;
 ```
 
Query 4 : This query returns the release year and title of all Star Wars movies
  ```sql
--represented as table in dashboard
--Title: Movie Release Year
select year,TITLE as Movie from STAR_WARS_DB.SW_DATA.movie_rating order by year;
 ```
 Query 5 : This query returns the year, IMDB rating, Rotten Tomatoes score and metascore for each of the Star Wars movie
  ```sql
--- Represented as line chart in dashboard
--Title: Movie rating trend(metascore,IMBD,Rotton tomato)
select year,
(imdbrating*10) as imdbrating,
(rottentomatoscore*100) as rottentomatoscore, 
metascore as metascore 
from STAR_WARS_DB.SW_DATA.movie_rating order by year;
 ```
 
Query 6: This query returns movie title , globalboxoffice_revenue_in_millions and awards won by each movie
  ```sql
--- Represented as bar chart in dashboard
--Title: Movie Revenue and Awards won
select title as movie, globalboxoffice_revenue as globalboxoffice_revenue_in_millions,AWARDS 
from STAR_WARS_DB.SW_DATA.movie_rating 
where title=:title
order by globalboxoffice_revenue,AWARDS;
 ```
 
 Query 7 : This query calculates the average Metascore and total number of movies directed by each director in the movie_rating table
  ```sql
--- Represented as a heatgrid on dashboard
--Title: No of movies directed and highest rating
WITH CTE AS (
    SELECT
        DIRECTOR,
        max(METASCORE) AS HIGHEST_METASCORE,
        COUNT(DIRECTOR) as total_movies_directed
    FROM
        STAR_WARS_DB.SW_DATA.MOVIE_RATING
    GROUP BY
        DIRECTOR
)
SELECT
    TITLE,
    M.DIRECTOR,
    HIGHEST_METASCORE,
    total_movies_directed
FROM
    STAR_WARS_DB.SW_DATA.MOVIE_RATING M
    LEFT JOIN CTE C ON M.DIRECTOR = C.DIRECTOR;
   ```
   
  Query 8 : This query returns the name, homeworld, and species for all Star Wars characters in the  
  ```sql
--Represented as a table in dashboard
--Title: Home world and species
select name,homeworld,species from STAR_WARS_DB.SW_DATA.characters  where species=:species and homeworld=:homeworld;
 ```
 Query 9 : This query counts the number of characters belonging to a specific species and living on a specific homeworld
  ```sql
--- Represented as stacked bar chart on dashboard
-- Title: Star Wars Characters by Species and Home Planet
select count(*) as total,homeworld,species from STAR_WARS_DB.SW_DATA.characters where species=:species and homeworld=:homeworld
and species<>'NA' and homeworld<>'NA'
group by homeworld,species;
 ```
 
 Query 10 :  This query returns the average mass and average height for each species in the characters table
  ```sql
--Represented as scatter plot in dashboard
--Title: Avg Height vs Mass
SELECT 
  species, 
  ROUND(AVG(mass),2) AS avg_mass,
  ROUND(AVG(HEIGHT),2) AS avg_height
FROM  STAR_WARS_DB.SW_DATA.characters where species<>'NA'
GROUP BY species 
order by avg_height desc;

 ```
 
 ### Optional
 
This code snippet is used to load a CSV file named "Star_wars_survey.csv" into a Snowflake database.
The data from the CSV file will be loaded into a third table called "Star_wars_survey"
note: you can download the file from [here](star_wars_datasets/star_wars_survey.csv)

Copy these SQL statements into a Snowflake Worksheet and execute them one by one

```sql

 -- Table to store Star Wars survey data 
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

Load the csv file by selecting the table and file format throught Snowsight 

-- Verify if the Star_wars_survey table was loaded successfully
SELECT * FROM STAR_WARS_DB.SW_DATA.Star_wars_survey;


SELECT 
  character_name, 
  SUM(CASE WHEN rating = 'Very favorably' THEN 1 ELSE 0 END) AS very_favorable
FROM (
  SELECT 'Luke Skywalker' AS character_name, RATE_LUKE_SKYWALKER AS rating FROM STAR_WARS_DB.SW_DATA.STAR_WARS_SURVEY
  UNION ALL SELECT 'Han Solo', RATE_HAN_SOLO FROM star_wars_survey
  UNION ALL SELECT 'Princess Leia', RATE_PRINCESS_LEIA_ORGANA FROM star_wars_survey
  UNION ALL SELECT 'Anakin Skywalker', RATE_ANAKIN_SKYWALKER FROM star_wars_survey
  UNION ALL SELECT 'Obi Wan', RATE_OBI_WAN_KENOBI FROM star_wars_survey
  UNION ALL SELECT 'Darth Vader', RATE_DARTH_VADER FROM star_wars_survey
  UNION ALL SELECT 'C3PO', RATE_C_3P0 FROM star_wars_survey
  UNION ALL SELECT 'R2_D2', RATE_R2_D2 FROM star_wars_survey
  UNION ALL SELECT 'Yoda', RATE_YODA FROM star_wars_survey
  UNION ALL SELECT 'Jar Jar Binks', RATE_JAR_JAR_BINKS FROM STAR_WARS_DB.SW_DATA.STAR_WARS_SURVEY
) AS character_ratings
WHERE rating IS NOT NULL
GROUP BY character_name;

 ```
 ### Code Cleanup
 
``` sql
 USE ROLE ACCOUNTADMIN;
 DROP DATABASE STAR_WARS_DB;

``` 
