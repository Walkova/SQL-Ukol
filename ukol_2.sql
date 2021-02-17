USE ROLE ROLE_CZECHITA_WALKOVAM;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE COURSES;
USE SCHEMA SCH_CZECHITA_WALKOVAM;

create or replace temporary table netflix_imdb_pom as 
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




create or replace  table netflix_imdb_pom1 as
    select *, row_number () over (partition by title, release_year, type order by title) as rown
        from  netflix_imdb_pom 
            qualify rown = 1;
            
            select * from netflix_imdb_pom1;

            
alter table netflix_imdb_pom1 add column netflix_date_added date;
alter table  netflix_imdb_pom1 add column movie_duration_min int;


update netflix_imdb_pom1 set date_added = TRIM(date_added);

update netflix_imdb_pom1 set netflix_date_added=
    (TO_DATE(
      CONCAT(
        SPLIT_PART(date_added, ' ', 3),
        '-',
        SUBSTR(SPLIT_PART(date_added, ' ', 1), 0, 3),
        '-',
        TRIM(SPLIT_PART(date_added, ' ', 2), ',')
      ),
      'YYYY-MON-DD'));


update netflix_imdb_pom1 set movie_duration_min = 
case 
        when type='Movie' then split_part(duration, ' ',1) 
        when type='TV Show' then null
    end;
    
select * from netflix_imdb_pom1;
    





