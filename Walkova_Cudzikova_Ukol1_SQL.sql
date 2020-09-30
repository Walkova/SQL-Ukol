--UKOL1:
SELECT  DATE_FROM_PARTS(iyear, imonth, iday) as DATE, 
        country_txt as Country,
        count(*) as pocet_utoku, 
        sum(nkill) as pocet_obeti,
        sum(nkillter) as pocet_zabitych_teroristu,
        sum(nwound) as pocet_zranenych
     
FROM teror
WHERE country_txt IN ('Iraq', 'Somalia') and iyear=2014 
GROUP BY 1,2
HAVING count(*)>=5
ORDER BY 2, 1;

--UKOL2:

SELECT vzdalenost_od_prahy
        , COUNT(*)
    FROM(
    SELECT 
   
         haversine(50.0755, 14.4378, latitude, longitude) as praha,
         case
                when (praha >=0 and praha<100) then '0-99km'
                when (praha >=100.0 and praha<500) then '100-499km'
                when (praha >=500.0 and praha<1000) then '500-999 km'
                when praha >=1000 then '1000+ km'
            else 'exact location unknown'
            end  as vzdalenost_od_prahy
         
    FROM TEROR
 )
 GROUP by vzdalenost_od_prahy
 ORDER BY count(*) desc;
 


--UKOL 3:

                                                            

SELECT  eventid
        , iyear
        , country_txt
        , city
        , attacktype1_txt
        , targtype1_txt
        , gname
        , weaptype1_txt
        , nkill
FROM teror
WHERE country_txt in ('Syria', 'Nigeria','Afghanistan') and (targtype1_txt!='Military' or gname='Islamic State of Iraq and the Levant (ISIL)') 
ORDER BY nkill desc nulls last
LIMIT 10;

