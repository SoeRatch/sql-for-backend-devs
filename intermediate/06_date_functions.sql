-- 06_date_functions.sql
-- Goal: Practice commonly used SQL date and time functions for temporal analysis

-- Sample table: employees
-- Columns:
--   id, name, age, department, department_id, job_title,
--   salary, hire_date, email, manager_id, phone

-- Functions covered:
--   CURRENT_DATE, CURRENT_TIMESTAMP, AGE, EXTRACT, DATE_TRUNC,
--   NOW(), TO_CHAR, INTERVAL, +, -, DATE_PART

-- 1. Get today's date and current timestamp
SELECT 
  CURRENT_DATE AS today,
  CURRENT_TIMESTAMP AS now;

-- 2. Calculate how long ago each employee was hired
-- AGE returns the difference between two dates as a full interval
SELECT 
  id, 
  name, 
  hire_date,
  AGE(CURRENT_DATE, hire_date) AS time_since_hired
FROM employees;

-- 3. Number of days since each employee was hired
SELECT 
  id, 
  name, 
  hire_date,
  CURRENT_DATE - hire_date AS days_since_hired
FROM employees;

-- 4. Extract year, month, and day from hire_date
SELECT 
  id, 
  hire_date,
  EXTRACT(YEAR FROM hire_date) AS hire_year,
  EXTRACT(MONTH FROM hire_date) AS hire_month,
  EXTRACT(DAY FROM hire_date) AS hire_day
FROM employees;

-- 5. Get the first day of the month in which the employee was hired
-- DATE_TRUNC with 'month' resets the day to the 1st of the month
-- e.g., '2023-03-18' becomes '2023-03-01'
SELECT 
  id, 
  hire_date,
  DATE_TRUNC('month', hire_date) AS hire_month_start
FROM employees;

-- 6. Add and subtract time intervals from hire_date
-- INTERVAL lets us work with durations like '1 year', '6 months', etc.
SELECT 
  id,
  hire_date,
  hire_date + INTERVAL '1 year' AS one_year_later,
  hire_date - INTERVAL '6 months' AS six_months_earlier
FROM employees;

-- 7. Format hire_date in a custom readable format
-- TO_CHAR converts date to string using format codes
-- e.g., '2025-07-25' becomes '25 Jul 2025'
SELECT 
  id, 
  hire_date,
  TO_CHAR(hire_date, 'DD Mon YYYY') AS formatted_date
FROM employees;

-- 8. Extract hour and minute from current timestamp
-- Simulating login time extraction using CURRENT_TIMESTAMP
SELECT 
  id,
  CURRENT_TIMESTAMP AS current_time,
  EXTRACT(HOUR FROM CURRENT_TIMESTAMP) AS current_hour,
  EXTRACT(MINUTE FROM CURRENT_TIMESTAMP) AS current_minute
FROM employees;
