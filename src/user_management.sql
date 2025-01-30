-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA FOREIGN_KEY = ON;

-- User Management Queries

-- 1. Retrieve all members
-- TODO: Write a query to retrieve all members

SELECT 
    member_id,
    first_name,
    last_name,
    email,
    join_date
FROM members;

-- 2. Update a member's contact information
-- TODO: Write a query to update a member's contact informatio
UPDATE members
SET 
    email = 'emily.jones.updted@email.com',
    phone_number = '555-9876'
WHERE
    member_id = 5;
-- 3. Count total number of members
-- TODO: Write a query to count the total number of members
SELECT
COUNT(member_id)
FROM 
    members;
-- 4. Find member with the most class registrations
-- TODO: Write a query to find the member with the most class registrations

SELECT m.member_id, m.first_name, m.last_name, COUNT(ca.schedule_id) AS class_registrations
FROM members m
JOIN class_attendance ca ON m.member_id = ca.member_id
GROUP BY m.member_id, m.first_name, m.last_name
ORDER BY class_registrations DESC
LIMIT 1;


-- 5. Find member with the least class registrations
-- TODO: Write a query to find the member with the least class registrations

SELECT m.member_id, m.first_name, m.last_name, COUNT(ca.schedule_id) AS class_registrations
FROM members m
JOIN class_attendance ca ON m.member_id = ca.member_id
GROUP BY m.member_id, m.first_name, m.last_name
ORDER BY class_registrations ASC
LIMIT 1;

-- 6. Calculate the percentage of members who have attended at least one class
-- TODO: Write a query to calculate the percentage of members who have attended at least one class

WITH members_attended AS (
    SELECT DISTINCT member_id
    FROM class_attendance
    WHERE attendance_status = 'Attended'
)
SELECT 
    ROUND((COUNT(ma.member_id) * 100.0 / COUNT(m.member_id)), 2) AS attendance_percentage
FROM 
    members AS m
LEFT JOIN 
    members_attended AS ma ON m.member_id = ma.member_id;