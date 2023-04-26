## Environment Setup
Copy these SQL statements into a Snowflake Worksheet, select all and execute them 

``` sql
-- Create the Snowflake Custom role, warehouse ,database and schema 
USE ROLE ACCOUNTADMIN;
CREATE or replace WAREHOUSE LIGHTSPEED_WH;
CREATE or replace ROLE JEDI;

GRANT ROLE JEDI TO ROLE ACCOUNTADMIN;
GRANT USAGE ON WAREHOUSE LIGHTSPEED_WH TO ROLE JEDI;
-- Grant CREATE DATABASE privilege to my_custom_role
GRANT CREATE DATABASE ON ACCOUNT TO ROLE JEDI;

USE ROLE JEDI;
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

Insert data into the two tables
 ```sql
INSERT INTO STAR_WARS_DB.SW_DATA.CHARACTERS (name, height, mass, hair_color, skin_color, eye_color, birth_year, gender, homeworld, species)
VALUES
('Luke Skywalker','172','77','blond','fair','blue','19BBY','male','Tatooine','Human'),
('C-3PO','167','75','NA','gold','yellow','112BBY','NA','Tatooine','Droid'),
('R2-D2','96','32','NA','white & blue','red','33BBY','NA','Naboo','Droid'),
('Darth Vader','202','136','none','white','yellow','41.9BBY','male','Tatooine','Human'),
('Leia Organa','150','49','brown','light','brown','19BBY','female','Alderaan','Human'),
('Owen Lars','178','120','brown & grey','light','blue','52BBY','male','Tatooine','Human'),
('Beru Whitesun lars','165','75','brown','light','blue','47BBY','female','Tatooine','Human'),
('R5-D4','97','32','NA','white & red','red','NA','NA','Tatooine','Droid'),
('Biggs Darklighter','183','84','black','light','brown','24BBY','male','Tatooine','Human'),
('Obi-Wan Kenobi','182','77','auburn & white','fair','blue-gray','57BBY','male','Stewjon','Human'),
('Anakin Skywalker','188','84','blond','fair','blue','41.9BBY','male','Tatooine','Human'),
('Wilhuff Tarkin','180','75','auburn & grey','fair','blue','64BBY','male','Eriadu','Human'),
('Chewbacca','228','112','brown','NA','blue','200BBY','male','Kashyyyk','Wookiee'),
('Han Solo','180','80','brown','fair','brown','29BBY','male','Corellia','Human'),
('Greedo','173','74','NA','green','black','44BBY','male','Rodia','Rodian'),
('Wedge Antilles','170','77','brown','fair','hazel','21BBY','male','Corellia','Human'),
('Jek Tono Porkins','180','110','brown','fair','blue','NA','male','Bestine IV','Human'),
('Palpatine','170','75','grey','pale','yellow','82BBY','male','Naboo','Human'),
('Boba Fett','183','78.2','black','fair','brown','31.5BBY','male','Kamino','Human'),
('Bossk','190','113','none','green','red','53BBY','male','Trandosha','Trandoshan'),
('Lando Calrissian','177','79','black','dark','brown','31BBY','male','Socorro','Human'),
('Lobot','175','79','none','light','blue','37BBY','male','Bespin','Human'),
('Ackbar','180','83','none','brown mottle','orange','41BBY','male','Mon Cala','Mon Calamari'),
('Mon Mothma','150','60','auburn','fair','blue','48BBY','female','Chandrila','Human'),
('Wicket Systri Warrick','88','20','brown','brown','brown','8BBY','male','Endor','Ewok'),
('Nien Nunb','160','68','none','grey','black','NA','male','Sullust','Sullustan'),
('Nute Gunray','191','90','none','mottled green','red','NA','male','Cato Neimoidia','Neimodian'),
('Finis Valorum','170','65','blond','fair','blue','91BBY','male','Coruscant','Human'),
('Jar Jar Binks','196','66','none','orange','orange','52BBY','male','Naboo','Gungan'),
('Roos Tarpals','224','82','none','grey','orange','NA','male','Naboo','Gungan'),
('Rugor Nass','206','93','none','green','orange','NA','male','Naboo','Gungan'),
('Watto','137','62','black','blue & grey','yellow','NA','male','Toydaria','Toydarian'),
('Sebulba','112','40','none','grey & red','orange','NA','male','Malastare','Dug'),
('Shmi Skywalker','163','70','black','fair','brown','72BBY','female','Tatooine','Human'),
('Darth Maul','175','80','none','red','yellow','54BBY','male','Dathomir','Zabrak'),
('Bib Fortuna','180','110','none','pale','pink','NA','male','Ryloth','Twilek'),
('Ayla Secura','178','55','none','blue','hazel','48BBY','female','Ryloth','Twilek'),
('Dud Bolt','94','45','none','blue & grey','yellow','NA','male','Vulpter','Vulptereen'),
('Gasgano','122','50','none','white & blue','black','NA','male','Troiken','Xexto'),
('Ben Quadinaros','163','65','none','grey & green & yellow','orange','NA','male','Tund','Toong'),
('Mace Windu','188','84','none','dark','brown','72BBY','male','Haruun Kal','Human'),
('Ki-Adi-Mundi','198','82','white','pale','yellow','92BBY','male','Cerea','Cerean'),
('Kit Fisto','196','87','none','green','black','NA','male','Glee Anselm','Nautolan'),
('Eeth Koth','171','57','black','brown','brown','NA','male','Iridonia','Zabrak'),
('Adi Gallia','184','50','none','dark','blue','NA','female','Coruscant','Tholothian'),
('Saesee Tiin','188','67','none','pale','orange','NA','male','Iktotch','Iktotchi'),
('Yarael Poof','264','95','none','white','yellow','NA','male','Quermia','Quermian'),
('Plo Koon','188','80','none','orange','black','22BBY','male','Dorin','Kel Dor'),
('Mas Amedda','196','90','none','blue','blue','NA','male','Champala','Chagrian'),
('Gregar Typho','185','85','black','dark','brown','NA','male','Naboo','Human'),
('CordÃ©','157','55','brown','light','brown','NA','female','Naboo','Human'),
('Cliegg Lars','183','70','brown','fair','blue','82BBY','male','Tatooine','Human'),
('Poggle the Lesser','183','80','none','green','yellow','NA','male','Geonosis','Geonosian'),
('Luminara Unduli','170','56.2','black','yellow','blue','58BBY','female','Mirial','Mirialan'),
('Barriss Offee','166','50','black','yellow','blue','40BBY','female','Mirial','Mirialan'),
('DormÃ©','165','68','brown','light','brown','NA','female','Naboo','Human'),
('Dooku','193','80','white','fair','brown','102BBY','male','Serenno','Human'),
('Bail Prestor Organa','191','82','black','tan','brown','67BBY','male','Alderaan','Human'),
('Jango Fett','183','79','black','tan','brown','66BBY','male','Concord Dawn','Human'),
('Zam Wesell','168','55','blonde','fair & green & yellow','yellow','NA','female','Zolan','Clawdite'),
('Dexter Jettster','198','102','none','brown','yellow','NA','male','Ojom','Besalisk'),
('Lama Su','229','88','none','grey','black','NA','male','Kamino','Kaminoan'),
('Taun We','213','89','none','grey','black','NA','female','Kamino','Kaminoan'),
('Jocasta Nu','167','67','white','fair','blue','NA','female','Coruscant','Human'),
('Ratts Tyerell','79','18','none','grey & blue','NA','NA','male','Aleen Minor','Aleena'),
('Wat Tambor','193','48','none','green & grey','NA','NA','male','Skako','Skakoan'),
('San Hill','191','89','none','grey','gold','NA','male','Muunilinst','Muun'),
('Shaak Ti','178','57','none','red & blue & white','black','NA','female','Shili','Togruta'),
('Grievous','216','159','none','brown & white','green & yellow','NA','male','Kalee','Kaleesh'),
('Tarfful','234','136','brown','brown','blue','NA','male','Kashyyyk','Wookiee'),
('Raymus Antilles','188','79','brown','light','brown','NA','male','Alderaan','Human'),
('Tion Medon','206','80','none','grey','black','NA','male','Utapau','Pauan'),
('PadmÃ© Amidala','165','45','brown','light','brown','46BBY','female','Naboo','Human'),
('Yoda','66','17','white','green','brown','896BBY','male','NA','Yodas species'),
('IG-88','200','140','none','metal','red','15BBY','none','NA','Droid'),
('Qui-Gon Jinn','193','89','brown','fair','blue','92BBY','male','NA','Human'),
('R4-P17','96','36','none','silver & red','red & blue','NA','female','NA','NA'),
('Poe Dameron','178','79','brown','light','brown','NA','male','NA','Human'),
('BB8','96','32','none','none','black','NA','none','NA','Droid'),
('Finn','175','86','black','dark','dark','NA','male','NA','Human');
 ```
 
 ```sql
INSERT INTO STAR_WARS_DB.SW_DATA.MOVIE_RATING (
    Year, Title, Rated, Released, Runtime, Director, Awards, Metascore, imdbVotes,
    imdbRating, RottenTomatoScore, Globalboxoffice_revenue) 
    VALUES (
    1977, 'Star Wars: Episode IV - A New Hope', 'PG', '5/25/77', 121, 'George Lucas',
    'Won 6 Oscars. Another 52 wins & 28 nominations.', 90, 1181083, 8.6, 0.92, 848.75),
    (
    1980, 'Star Wars: Episode V - The Empire Strikes Back', 'PG', '6/20/80', 124, 'Irvin Kershner',
    'Won 1 Oscar. Another 24 wins & 20 nominations.', 82, 1109656, 8.7, 0.94, 538.38), 
    (
    1983, 'Star Wars: Episode VI - Return of the Jedi', 'PG', '5/25/83', 131, 'Richard Marquand',
    'Nominated for 4 Oscars. Another 22 wins & 16 nominations.', 58, 912250, 8.3, 0.82, 475.11), 
    (
    1999, 'Star Wars: Episode I - The Phantom Menace', 'PG', '5/19/99', 136, 'George Lucas',
    'Nominated for 3 Oscars. Another 26 wins & 65 nominations.', 51, 698744, 6.5, 0.53, 1056.06),
    (
    2002, 'Star Wars: Episode II - Attack of the Clones', 'PG', '5/16/02', 142, 'George Lucas',
    'Nominated for 1 Oscar. Another 19 wins & 63 nominations.', 54, 613768, 6.5, 0.65, 775.40),
    (
    2005, 'Star Wars: Episode III - Revenge of the Sith', 'PG-13', '5/19/05', 140, 'George Lucas',
    'Nominated for 1 Oscar. Another 26 wins & 61 nominations.', 68, 681075, 7.5, 0.8, 1027.04), 
    (
    2015, 'Star Wars: Episode VII - The Force Awakens', 'PG-13', '12/18/15', 138, 'J.J. Abrams',
    'Nominated for 5 Oscars. Another 62 wins & 125 nominations.', 80, 833706, 7.9, 0.93, 2068.22), 
    (
    2017, 'Star Wars: Episode VIII - The Last Jedi', 'PG-13', '12/15/17', 152, 'Rian Johnson',
    'Nominated for 4 Oscars. Another 22 wins & 88 nominations.', 85, 532835, 7, 0.91, 1332.54
    ),
    (2019,'Star Wars: Episode IX - The Rise of Skywalker','PG-13',	'12/20/19', 142	, 'J.J. Abrams',
    'Nominated for 3 Oscars. Another 7 wins & 35 nominations.', 53, 294411, 6.7, 0.52, 1074.15);

-- Verify if the STAR_WARS_SURVEY table was loaded successfully
SELECT * FROM STAR_WARS_DB.SW_DATA.CHARACTERS;

 ```

 ```
 ### Create custom filters using the below queries
  --homeworld filter
select distinct homeworld from characters;
--species filter
select distinct species from characters;
--movie_title
select distinct title from movie_rating;

  ```
 
 
 ### Queries  used to build the Snowsight dashboard 
Query 1: This query returns the total count of characters in the characters table.
   ```sql
---Represented as First scorecard in dashboard
--- Title: Total Characters in Dataset
select count(name) from STAR_WARS_DB.SW_DATA.characters;
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
        mode(METASCORE) AS HIGHEST_METASCORE,
        COUNT(DIRECTOR) as total_movies_directed
    FROM
        MOVIE_RATING
    GROUP BY
        DIRECTOR
)
SELECT
    TITLE,
    M.DIRECTOR,
    HIGHEST_METASCORE,
    total_movies_directed
FROM
    MOVIE_RATING M
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
select count(name),homeworld,species from STAR_WARS_DB.SW_DATA.characters where species=:species and homeworld=:homeworld
and species<>'NA' and homeworld<>'NA'
group by homeworld,species;
 ```
 
 Query 10 :  This query returns the average mass and average height for each Star Wars character in the characters table
  ```sql
--Represented as scatter plot in dashboard
--Title: Avg Height vs Mass
SELECT name, ROUND(AVG(mass),2) AS avg_mass,round(AVG(HEIGHT),2) AS avg_height
FROM STAR_WARS_DB.SW_DATA.characters 
GROUP BY name 
order by avg_height desc;
 ```
 
 ### Optional
 
 ## Execute these statements in Terminal

Note:
You need to replace <account_name> with the name of your Snowflake account 

You would need to replace <path_to_local_file> with the actual path to the star_wars_characters.csv file on your local machine

``` terminal
snowsql -a <account_name> -u <username>
use database STAR_WARS_DB;
use schema SW_DATA;
PUT file:///<path_to_local_file>/Star_wars_characters.csv @my_stage;
PUT file:///<path_to_local_file>/star_wars_movie_ratings.csv @my_stage;
PUT file:///<path_to_local_file>/star_wars_survey.csv @my_stage;

```
Copy these SQL statements into a Snowflake Worksheet and execute them one by one
 ```sql
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

 Create table Star_wars_survey and load data using the file Star_wars_survey
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
``` 
 Query 11: This query calculates the number of "very favorable" ratings for each Star Wars character based on responses from a survey.
  ```sql
-- Represented as bar chart in dashboard
--Title: Most Favorite Character
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
  UNION ALL SELECT 'Jar Jar Binks', RATE_JAR_JAR_BINKS FROM STAR_WARS_DB.SW_DATA.star_wars_survey
) AS character_ratings
WHERE rating IS NOT NULL
GROUP BY character_name;
 ```
 ### Code Cleanup
 
