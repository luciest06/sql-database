CREATE DATABASE IF NOT EXISTS biking;
USE biking;

DROP TABLE IF EXISTS bike_sharing_data;

CREATE TABLE bike_sharing_data (
    instant INT PRIMARY KEY,
    dteday DATE,
    season INT,
    yr INT,
    mnth INT,
    holiday INT,
    weekday INT,
    workingday INT,
    weathersit INT,
    temp FLOAT,
    atemp FLOAT,
    hum FLOAT,
    windspeed FLOAT,
    casual INT,
    registered INT,
    cnt INT,
    FOREIGN KEY (season) REFERENCES season(season_id),
    FOREIGN KEY (weathersit) REFERENCES weather_type(weather_type_id)
);

-- ALTER TABLE biking.bike_sharing_data DROP COLUMN hr;

DROP TABLE IF EXISTS season;

CREATE TABLE season (
	season_id INT PRIMARY KEY,
    name VARCHAR(10)
);

DROP TABLE IF EXISTS weather_type;

CREATE TABLE weather_type (
	weather_type_id INT PRIMARY KEY,
    category VARCHAR(200)
);

-- Removing previous values in season table
TRUNCATE TABLE season;

-- Insert values into season table
INSERT INTO season (season_id, name) VALUES
('1', 'winter'),
('2', 'spring'),
('3', 'summer'),
('4', 'fall');

-- Insert values into weather_type table
INSERT INTO weather_type (weather_type_id, category) VALUES
('1', 'Clear, Few clouds, Partly cloudy, Partly cloudy'),
('2', 'Mist + Cloudy, Mist + Broken clouds, Mist + Few clouds, Mist'),
('3', 'Light Snow, Light Rain + Thunderstorm + Scattered clouds, Light Rain + Scattered clouds'),
('4', 'Heavy Rain + Ice Pallets + Thunderstorm + Mist, Snow + Fog');

