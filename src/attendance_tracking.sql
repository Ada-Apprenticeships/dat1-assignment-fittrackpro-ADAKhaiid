-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Attendance Tracking Queries

-- 1. Record a member's gym visit
INSERT INTO attendance (member_id, location_id, check_in_time)
VALUES (7, 1, datetime('now'));

-- 2. Retrieve a member's attendance history
SELECT 
    CASE strftime('%w', check_in_time)
        WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        WHEN '6' THEN 'Saturday'
    END AS day_of_week,
    COUNT(*) AS visit_count
FROM 
    attendance
GROUP BY 
    day_of_week
ORDER BY 
    visit_count DESC
LIMIT 1;


-- 4. Calculate average daily attendance per location
SELECT 
    l.name,
    ROUND(AVG(visit_count), 2) AS avg_daily_attendance
FROM (
    SELECT 
        location_id, 
        strftime('%w', check_in_time) AS day_of_week, 
        COUNT(*) AS visit_count
    FROM 
        attendance
    GROUP BY 
        location_id, day_of_week
) AS vc
INNER JOIN 
    locations AS l 
ON 
    l.location_id = vc.location_id
GROUP BY 
    l.name;