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



-- 6. Calculate average number of classes per member
-- TODO: Write a query to calculate average number of classes per member