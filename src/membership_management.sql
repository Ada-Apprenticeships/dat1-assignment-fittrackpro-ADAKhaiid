-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Membership Management Queries

-- 1. List all active memberships
-- TODO: Write a query to list all active memberships

SELECT 
    ms.member_id,
    m.first_name,
    m.last_name,
    ms.type AS membership_type,
    ms.start_date AS join_date
FROM
    memberships AS ms
INNER JOIN
    members AS m
ON
    ms.member_id = m.member_id
WHERE
    ms.status = 'Active';

-- 2. Calculate the average duration of gym visits for each membership type
SELECT
    memberships.type AS membership_type,
    ROUND(
    AVG((strftime('%s', attendance.check_out_time) - strftime('%s', attendance.check_in_time)) / 60.0)
    , 2) AS avg_visit_duration_minutes
FROM 
    attendance
JOIN 
    members 
ON 
    attendance.member_id = members.member_id
JOIN 
    memberships 
ON 
    members.member_id = memberships.member_id
WHERE 
    attendance.check_out_time IS NOT NULL
GROUP BY 
    memberships.type;

-- 3. Identify members with expiring memberships this year
SELECT
    m.member_id AS member_id,
    m.first_name AS first_name,
    m.last_name AS last_name,
    m.email AS email,
    ms.end_date AS end_date
FROM 
    members AS m
JOIN 
    memberships AS ms
ON  
    m.member_id = ms.member_id
WHERE 
    ms.end_date > CURRENT_DATE
    AND ms.end_date <= DATE(CURRENT_DATE, '+12 months');