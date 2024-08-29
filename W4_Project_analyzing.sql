USE biking;

SELECT * FROM biking.bike_sharing_data;

SELECT * FROM biking.season LIMIT 20;

SELECT * FROM biking.weather_type LIMIT 20;

-- joining all tables together
SELECT bsd.dteday, bsd.registered, bsd.casual, s.name, w.category FROM biking.bike_sharing_data AS bsd
JOIN biking.season AS s
ON bsd.season=s.season_id
JOIN biking.weather_type AS w
ON bsd.weathersit=w.weather_type_id;

-- No matter the weather or day of the week, there is minimal impact on registered bike users’ behavior.
-- over 2 years high demand month (where max(users)) select average humidity and average windspeed and average temperature
SELECT DATE_FORMAT(dteday,'%Y %M') AS 'year_month', SUM(cnt) AS users_number FROM biking.bike_sharing_data
GROUP BY DATE_FORMAT(dteday,'%Y %M')
ORDER BY MAX(cnt) DESC;
-- best month in terms of total users is 2012 September

-- over 2 years low demand month (where min(users)) select average humidity and average windspeed and average temperature (LUCIE)
SELECT DATE_FORMAT(dteday,'%Y %M'), SUM(cnt) FROM biking.bike_sharing_data
GROUP BY DATE_FORMAT(dteday,'%Y %M')
ORDER BY SUM(cnt);
-- worst month in terms of total users is January 2011

SELECT DATE_FORMAT(dteday,'%Y %M'), (AVG(temp)*41), (AVG(hum)*100), (AVG(windspeed)*67) FROM biking.bike_sharing_data AS bsd
JOIN biking.weather_type AS w
ON bsd.weathersit=w.weather_type_id
WHERE DATE_FORMAT(dteday,'%Y %M') = '2011 January'
OR DATE_FORMAT(dteday,'%Y %M') = '2012 September'
GROUP BY DATE_FORMAT(dteday,'%Y %M');
-- windspeed unit is mph

SELECT DATE_FORMAT(dteday, '%Y-%m'), w.category, COUNT(w.category) AS count_per_category FROM biking.bike_sharing_data AS bsd
JOIN biking.weather_type AS w
ON bsd.weathersit=w.weather_type_id
WHERE dteday LIKE '2012-09-%' OR dteday LIKE '2011-01-%'
GROUP BY DATE_FORMAT(dteday, '%Y-%m'), w.category
ORDER BY DATE_FORMAT(dteday, '%Y-%m'), w.category;
-- In September 2012, there were 22 days of clear weather, 8 days of mist and cloudy weather
-- In January 2011, there were 17 days of clear weather, 13 days of mist and cloudy weather, and 1 days of light snow and rain

SELECT DATE_FORMAT(dteday, '%Y'), w.category, COUNT(dteday) FROM biking.bike_sharing_data AS bsd
JOIN biking.weather_type AS w
ON bsd.weathersit=w.weather_type_id
WHERE w.category LIKE '%rain%'
GROUP BY DATE_FORMAT(dteday, '%Y'),w.category;
-- 15 rainy days in 2011, 6 rainy days in 2012


-- Bana part
-- >Count of Type of Users (Registered/Casual) Grouped by Weather Type
SELECT 
    wt.category AS weather_type, 
    SUM(bsd.registered) AS total_registered,  
    SUM(bsd.casual) AS total_casual  
FROM 
    biking.weather_type AS wt  
LEFT JOIN 
    biking.bike_sharing_data AS bsd ON bsd.weathersit = wt.weather_type_id  
GROUP BY 
    wt.category;  -- > 4 : Heavy Rain + Ice Pallets + Thunderstorm + Mist, Snow + Fog is null 
   

--  >Count of Type of Users (Registered/Casual) Grouped by Day of the Week (Weekday/Weekend)
   SELECT 
    'Weekday' AS day_type, 
    SUM(bsd.registered) AS total_registered,  
    SUM(bsd.casual) AS total_casual  
FROM 
    biking.bike_sharing_data AS bsd  
WHERE 
    bsd.weekday NOT IN (0, 6); -- > 7 days so i rigth 0 to 6 

    
-- > Count of Users When There is Rain (weather_type.category) Grouped by Type of Users
SELECT 
    SUM(bsd.registered) AS total_registered,  
    SUM(bsd.casual) AS total_casual  
FROM 
    biking.bike_sharing_data AS bsd  
JOIN 
    biking.weather_type AS wt ON bsd.weathersit = wt.weather_type_id  
WHERE 
    bsd.weathersit IN (3, 4);  -- > to have only rain 

-- // for introduction :
 
-- average of temperature in the year
SELECT AVG(temp)*41
FROM  biking.bike_sharing_data as bsd;

-- 2011
SELECT AVG(temp)*41
FROM  biking.bike_sharing_data as bsd
WHERE bsd.yr = 0;

-- 2012

SELECT AVG(temp)*41
FROM  biking.bike_sharing_data as bsd
WHERE bsd.yr = 1;
 
 
--  average of temperature per season

SELECT 
		s.name as season_name, 
		AVG(temp) as average_temperature
FROM  
		bike_sharing_data bsd
JOIN
	season s on bsd.season = s.season_id
GROUP BY
	s.name
ORDER BY
average_temperature ASC;


-- count of total users by season 

SELECT 
    s.name AS season_name,
    SUM(bsd.casual) AS total_casual_users,
    SUM(bsd.registered) AS total_registered_users,
    SUM(bsd.casual + bsd.registered) AS total_users
FROM 
    bike_sharing_data bsd
JOIN 
    season s ON bsd.season = s.season_id
GROUP BY 
    s.name;
 
 -- // HYPOTHESIS 1 count of total users grouping (spring + summer / fall + winter)

SELECT 
    CASE
        WHEN s.name IN ('spring', 'summer') THEN 'spring + summer'
        WHEN s.name IN ('fall', 'winter') THEN 'fall + winter'
    END AS season_group,
    SUM(bsd.casual) AS total_casual_users,
    SUM(bsd.registered) AS total_registered_users,
    SUM(bsd.casual + bsd.registered) AS total_users
FROM 
    bike_sharing_data bsd
JOIN 
    season s ON bsd.season = s.season_id
GROUP BY 
    season_group;



-- // HYPOTHESIS 1

-- Number of users by month for graph

SELECT 
    CASE 
        WHEN mnth = 1 THEN 'January'
        WHEN mnth = 2 THEN 'February'
        WHEN mnth = 3 THEN 'March'
        WHEN mnth = 4 THEN 'April'
        WHEN mnth = 5 THEN 'May'
        WHEN mnth = 6 THEN 'June'
        WHEN mnth = 7 THEN 'July'
        WHEN mnth = 8 THEN 'August'
        WHEN mnth = 9 THEN 'September'
        WHEN mnth = 10 THEN 'October'
        WHEN mnth = 11 THEN 'November'
        WHEN mnth = 12 THEN 'December'
    END AS month,
    SUM(casual + registered) AS total_users
FROM 
    bike_sharing_data
GROUP BY 
    mnth
ORDER BY 
    mnth;

