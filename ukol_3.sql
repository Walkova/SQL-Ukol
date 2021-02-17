USE ROLE ROLE_CZECHITA_WALKOVAM;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE COURSES;
USE SCHEMA SCH_CZECHITA_WALKOVAM;

SELECT * FROM sch_czechita.netflix_TITLES;
SELECT * FROM sch_czechita.IMDB_TITLES ; 
SELECT * FROM sch_czechita.IMDB_RATINGS;



CREATE or REPLACE Temporary Table NETFLIX_IMDB AS
(SELECT * FROM sch_czechita.netflix_TITLES as a 
JOIN sch_czechita.IMDB_TITLES as b 
ON a.title=b.primarytitle
and a.release_year=b.startyear);

SELECT * FROM NETFLIX_IMDB;


CREATE or REPLACE Table VYSLEDEK_UKOL2 as (
SELECT tit.*, rat.AVERAGERATING, rat.NUMVOTES 
FROM  NETFLIX_IMDB as tit
JOIN sch_czechita.IMDB_RATINGS as rat
ON tit.tconst=rat.tconst);

SELECT * FROM VYSLEDEK_UKOL2; 

SELECT count(*), count (DISTINCT tconst) FROM VYSLEDEK_UKOL2;
SELECT count(*), count (DISTINCT show_id) FROM VYSLEDEK_UKOL2; //zde vzniklo 43 duplicitních řádků

//vyfiltrovala bych si, které show_ID se vyskytují více než jednou 
SELECT DISTINCT show_id, count(show_id) FROM VYSLEDEK_UKOL2 GROUP BY 1 ORDER BY  2 desc ;

//a podívala bych se, zda jsou to duplicity, pokud ano, smazala bych 

create or replace temporary table netflix_imdb_pom as -- pom znamená pomocná tabulka
select it.*, 
       ir.averageRating, 
       ir.numVotes,
       nt.*
from (select *, case 
                  when titletype in ('movie', 'tvMovie', 'tvShort', 'short')  then 'Movie'
                  when titletype in ('tvMiniSeries', 'tvSeries') then 'TV Show'
                  else 'unwanted'
                 end as type_new_cat
      from sch_czechita.imdb_titles) as it
inner join sch_czechita.imdb_ratings as ir
on it.tconst=ir.tconst
inner join sch_czechita.netflix_titles as nt
on lower(trim(it.primaryTitle)) = lower(trim(nt.title))
and it.startyear::int = nt.release_year::int
and it.type_new_cat = nt.type;

SELECT * FROM  netflix_imdb_pom ;


SELECT *, row_number () over (order by title) from (
SELECT DISTINCT  title, release_year, type, count(title) FROM  netflix_imdb_pom GROUP BY 1,2, 3 ORDER BY  4 desc);





