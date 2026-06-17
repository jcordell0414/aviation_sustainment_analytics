-- Aviation Sustainment Analytics SQL Project
-- Author: Jace Cordell
-- Tools: MySQL Workbench


-- CREATE DATABASE

CREATE DATABASE aviation_analytics;

USE aviation_analytics;


-- CREATE TABLE

CREATE TABLE maintenance_data (
    maintenance_id INT,
    aircraft_id VARCHAR(50),
    aircraft_model VARCHAR(50),
    base_location VARCHAR(100),
    maintenance_type VARCHAR(100),
    supplier_name VARCHAR(100),
    event_date VARCHAR(50),
    downtime_hours FLOAT,
	supplier_delay_days FLOAT,
    maintenance_status VARCHAR(50),
    maintenance_cost FLOAT,
    readiness_score FLOAT,
    month VARCHAR(50),
    year VARCHAR(50),
    total_delay FLOAT,
    risk_level VARCHAR(50)
);


-- =====================================================
-- LOAD CSV DATA
-- =====================================================

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/aviation_maintenance_cleaned_csv.csv'
INTO TABLE maintenance_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
maintenance_id ,
    aircraft_id ,
    aircraft_model ,
    base_location ,
    maintenance_type ,
    supplier_name ,
    event_date ,
    downtime_hours ,
	supplier_delay_days ,
    maintenance_status ,
    maintenance_cost ,
    readiness_score ,
    month,
    year,
    total_delay ,
    risk_level
    );

-- VERIFY DATA IMPORT

SELECT *
FROM maintenance_data
LIMIT 10;


-- MAINTENANCE DOWNTIME ANALYSIS
-- This query generates the average downtime by maintenance type
SELECT
	maintenance_type,
    ROUND(AVG(downtime_hours),2) As avg_downtime,
    COUNT(maintenance_id) as total_events
FROM
	maintenance_data
GROUP BY
	maintenance_type
ORDER BY
	AVG(downtime_hours) DESC;



-- SUPPLIER DELAY ANALYSIS
-- This query shows the highest delays by supplier
SELECT
	supplier_name,
    AVG(supplier_delay_days) as avg_delay
FROM
	maintenance_data
GROUP BY
	supplier_name
ORDER BY
	avg_delay DESC;


-- MONTHLY DOWNTIME TRENDS
-- This query shows the monthly downtime trends
SELECT
	CASE
		WHEN month = 1 THEN 'January'
        WHEN month = 2 THEN 'February'
        WHEN month = 3 THEN 'March'
        WHEN month = 4 THEN 'April'
        WHEN month = 5 THEN 'May'
        WHEN month = 6 THEN 'June'
        WHEN month = 7 THEN 'July'
        WHEN month = 8 THEN 'August'
        WHEN month = 9 THEN 'September'
        WHEN month = 10 THEN 'October'
        WHEN month = 11 THEN 'November'
        WHEN month = 12 THEN 'December'
    END as month_,
    ROUND(AVG(downtime_hours),2) as avg_downtime
FROM
	maintenance_data
GROUP BY
	month
ORDER BY
	month;
    
    

-- READINESS RISK ANALYSIS
-- This query generates a readiness risk analysis
SELECT
	aircraft_model,
    ROUND(AVG(readiness_score),2) as avg_score
FROM
	maintenance_data
GROUP BY
	aircraft_model
ORDER BY
	avg_score DESC;
    
-- MAINTENANCE COST KPIs
   -- This query generates the average and total maintenance cost 
SELECT
	maintenance_type,
    ROUND(AVG(maintenance_cost),2) as avg_cost,
    ROUND(SUM(maintenance_cost),2) as total_cost
FROM
	maintenance_data
GROUP BY
	maintenance_type
    
-- HIGH RISK EVENTS
-- This query identifies high risk maintenance events
SELECT
	maintenance_id,
    aircraft_model,
    maintenance_type,
    downtime_hours, 
    readiness_score
FROM
	maintenance_data
WHERE
	readiness_score < 70
ORDER BY
	downtime_hours DESC;
    

-- TOP FINDINGS
-- This query shows the top operational findings
SELECT
	maintenance_type,
    COUNT(*) as total_events,
    ROUND(AVG(downtime_hours),2) as avg_downtime,
    ROUND(SUM(maintenance_cost),2) as total_cost
FROM
	maintenance_data
GROUP BY
	maintenance_type
ORDER BY
	avg_downtime DESC;
