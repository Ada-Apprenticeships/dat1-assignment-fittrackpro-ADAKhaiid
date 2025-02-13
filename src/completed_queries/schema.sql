-- FitTrack Pro Database Schema

-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Create your tables here
-- Example:
-- CREATE TABLE table_name (
--     column1 datatype,
--     column2 datatype,
--     ...
-- ); 

CREATE TABLE locations (
    location_id          INTEGER PRIMARY KEY AUTOINCREMENT,
    name                 VARCHAR(50) NOT NULL,
    address              VARCHAR(100) NOT NULL,
    phone_number         VARCHAR(15) NOT NULL,
    email                VARCHAR(50) NOT NULL,
    opening_hours        TEXT NOT NULL
);

CREATE TABLE members (
    member_id                INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name               VARCHAR(30) NOT NULL,
    last_name                VARCHAR(30) NOT NULL,
    email                    VARCHAR(50) NOT NULL,
    phone_number             VARCHAR(15) NOT NULL,
    date_of_birth            DATE NOT NULL,
    join_date                DATE NOT NULL,
    emergency_contact_name   VARCHAR(50) NOT NULL,
    emergency_contact_phone  VARCHAR(15) NOT NULL
);

CREATE TABLE staff (
    staff_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name     VARCHAR(30) NOT NULL,
    last_name      VARCHAR(30) NOT NULL,
    email          VARCHAR(50) NOT NULL,
    phone_number   VARCHAR(15) NOT NULL,
    position       VARCHAR(20) CHECK (position IN ('Trainer', 'Manager', 'Receptionist', 'Maintenance')) NOT NULL,
    hire_date      DATE NOT NULL,
    location_id    INTEGER,
    
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE SET NULL
);

CREATE TABLE equipment (
    equipment_id          INTEGER PRIMARY KEY AUTOINCREMENT,
    name                  VARCHAR(50) NOT NULL,
    type                  VARCHAR(20) CHECK (type IN ('Cardio', 'Strength')) NOT NULL,
    purchase_date         DATE NOT NULL,
    last_maintenance_date DATE,
    next_maintenance_date DATE,
    location_id           INTEGER,
    
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE SET NULL
);

CREATE TABLE classes (
    class_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    name          VARCHAR(50) NOT NULL,
    description   TEXT NOT NULL,
    capacity      INTEGER NOT NULL CHECK (capacity > 0),
    duration      INTEGER NOT NULL CHECK (duration > 0),
    location_id   INTEGER,
    
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE
);

CREATE TABLE class_schedule (
    schedule_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    class_id      INTEGER NOT NULL,
    staff_id      INTEGER NOT NULL,
    start_time    TIMESTAMP NOT NULL,
    end_time      TIMESTAMP NOT NULL,
    
    FOREIGN KEY (class_id) REFERENCES classes(class_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE SET NULL
);

CREATE TABLE memberships (
    membership_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id       INTEGER NOT NULL,
    type            VARCHAR(20) NOT NULL,
    start_date      DATE NOT NULL,
    end_date        DATE,
    status          VARCHAR(10) CHECK (status IN ('Active', 'Inactive')) NOT NULL,
    
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

CREATE TABLE attendance (
    attendance_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id       INTEGER NOT NULL,
    location_id     INTEGER NOT NULL,
    check_in_time   TIMESTAMP NOT NULL,
    check_out_time  TIMESTAMP,
    
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE
);

CREATE TABLE class_attendance (
    class_attendance_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    schedule_id           INTEGER NOT NULL,
    member_id             INTEGER NOT NULL,
    attendance_status     VARCHAR(15) CHECK (attendance_status IN ('Registered', 'Attended', 'Unattended')) NOT NULL,
    
    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

CREATE TABLE payments (
    payment_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id       INTEGER NOT NULL,
    amount          DECIMAL(10,2) NOT NULL,
    payment_date    DATE NOT NULL,
    payment_method  VARCHAR(20) CHECK (payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash')) NOT NULL,
    payment_type    VARCHAR(30) CHECK (payment_type IN ('Monthly membership fee', 'Day pass')) NOT NULL,
    
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

CREATE TABLE personal_training_sessions (
    session_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id      INTEGER NOT NULL,
    staff_id       INTEGER NOT NULL,
    session_date   DATE NOT NULL,
    start_time     TIME NOT NULL,
    end_time       TIME NOT NULL,
    notes          TEXT,
    
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE SET NULL
);

CREATE TABLE member_health_metrics (
    metric_id           INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id           INTEGER NOT NULL,
    measurement_date    DATE NOT NULL,
    weight              DECIMAL(5,2),
    body_fat_percentage DECIMAL(5,2),
    muscle_mass         DECIMAL(5,2),
    bmi                 DECIMAL(5,2),
    
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

CREATE TABLE equipment_maintenance_log (
    log_id             INTEGER PRIMARY KEY AUTOINCREMENT,
    equipment_id       INTEGER NOT NULL,
    maintenance_date   DATE NOT NULL,
    description        TEXT NOT NULL,
    staff_id           INTEGER,
    
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE SET NULL
);

-- TODO: Create the following tables:
-- 1. locations
-- 2. members
-- 3. staff
-- 4. equipment
-- 5. classes
-- 6. class_schedule
-- 7. memberships
-- 8. attendance
-- 9. class_attendance
-- 10. payments
-- 11. personal_training_sessions
-- 12. member_health_metrics
-- 13. equipment_maintenance_log

-- After creating the tables, you can import the sample data using:
-- `.read data/sample_data.sql` in a sql file or `npm run import` in the terminal