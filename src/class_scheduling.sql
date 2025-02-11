-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Class Scheduling Queries

-- 1. List all classes with their instructors
-- TODO: Write a query to list all classes with their instructors

SELECT 
    cs.class_id,
    c.name AS class_name,
    s.first_name || ' ' || s.last_name AS class_instructor
FROM 
    class_schedule AS cs
INNER JOIN
    staff AS s
ON 
    cs.staff_id = s.staff_id
INNER JOIN
    classes AS c
ON 
    cs.class_id = c.class_id;

-- 2. Find available classes for a specific date
-- TODO: Write a query to find available classes for a specific date

WITH slots_available AS (
    SELECT 
        cs.schedule_id,
        c.capacity - COUNT(ca.attendance_status) AS available_slots
    FROM
        class_attendance AS ca
    INNER JOIN 
        class_schedule AS cs
    ON 
        ca.schedule_id = cs.schedule_id
    INNER JOIN 
        classes AS c
    ON  
        cs.class_id = c.class_id
    WHERE 
        ca.attendance_status = 'Registered' 
    GROUP BY cs.schedule_id, c.capacity
)

SELECT 
    cs.class_id,
    c.name AS class_name,
    cs.start_time,
    cs.end_time,
    sa.available_slots
FROM 
    class_schedule AS cs
INNER JOIN
    classes AS c
ON 
    cs.class_id = c.class_id
INNER JOIN 
    slots_available AS sa
ON 
    cs.schedule_id = sa.schedule_id
WHERE
    cs.start_time LIKE '2025-02-01%'; 

-- 3. Register a member for a class
-- TODO: Write a query to register a member for a class

/* INSERT INTO class_attendance (schedule_id, member_id, attendance_status)
VALUES 
    (7, 11, 'Registered'); */

-- 4. Cancel a class registration
-- TODO: Write a query to cancel a class registration

/* DELETE FROM class_attendance
WHERE
    class_attendance_id = 15; */

-- 5. List top 3 most popular classes
-- TODO: Write a query to list top 5 most popular classes

WITH class_registrations AS (
    SELECT 
        cs.schedule_id,
        cs.class_id,
        COUNT(ca.attendance_status) AS registration_count
    FROM 
        class_schedule AS cs
    INNER JOIN 
        class_attendance AS ca
    ON 
        ca.schedule_id = cs.schedule_id 
    GROUP BY 
        cs.schedule_id, cs.class_id
) 

SELECT 
    c.name AS class_name,
    c.class_id,
    COALESCE(cr.registration_count, 0) AS registration_count 
FROM 
    classes AS c
LEFT JOIN 
    class_registrations AS cr
ON 
    c.class_id = cr.class_id
ORDER BY 
    registration_count DESC
LIMIT 3;

-- 6. Calculate average number of classes per member
-- TODO: Write a query to calculate average number of classes per member

WITH classes_count AS (
    SELECT 
        COUNT(class_id) AS total_classes
    FROM
        classes
)

SELECT 
    (cc.total_classes * 1.0) / COUNT(DISTINCT m.member_id) AS average_classes_per_member
FROM
    members AS m
JOIN
    classes_count AS cc


