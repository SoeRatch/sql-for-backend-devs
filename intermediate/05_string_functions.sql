-- 05_string_functions.sql
-- Goal: Practice commonly used SQL string functions for text manipulation

-- Sample table: employees
-- Columns:
--   id, name, age, department, department_id, job_title,
--   salary, hire_date, email, manager_id, phone, first_name, last_name

-- String functions covered:
--   - SUBSTRING
--   - POSITION
--   - REPLACE
--   - TRIM, LTRIM, RTRIM
--   - LOWER
--   - CONCAT, CONCAT_WS
--   - ILIKE
--   - LEFT, RIGHT
--   - SPLIT_PART (PostgreSQL)

-- 1. Extract the domain from each employee's email address
-- Uses SUBSTRING and POSITION to locate the '@' symbol
SELECT 
  id, 
  email,
  SUBSTRING(email FROM POSITION('@' IN email) + 1) AS domain
FROM employees;

-- 2. Get the first name of each employee
-- Assumes names are stored as 'First Last' and splits on the first space
-- SUBSTRING starts at position 1 and ends just before the first space (that's why we subtract 1)
SELECT 
  id, 
  name,
  SUBSTRING(name FROM 1 FOR POSITION(' ' IN name) - 1) AS first_name
FROM employees;

-- 3. Replace dashes in phone numbers with spaces
-- REPLACE(string, from_substring, to_substring)
SELECT 
  id, 
  phone,
  REPLACE(phone, '-', ' ') AS cleaned_phone
FROM employees;

-- 4. Standardize job titles by trimming whitespace and converting to lowercase
-- Uses TRIM and LOWER
SELECT 
  id, 
  job_title,
  LOWER(TRIM(job_title)) AS standardized_title
FROM employees;

-- 5. Example of LTRIM and RTRIM
-- Removes spaces from left, right, or both ends
SELECT 
  '   hello   ' AS original,
  LTRIM('   hello   ') AS left_trimmed,
  RTRIM('   hello   ') AS right_trimmed,
  TRIM('   hello   ') AS fully_trimmed;

-- 6. Concatenate name and email in a formatted string
-- Uses CONCAT and string literals
SELECT 
  id,
  CONCAT(name, ' (', email, ')') AS display_name
FROM employees;

-- 7. Concatenate first and last names with a space in between
-- Uses CONCAT_WS which adds the separator (space here) only between non-null values
SELECT 
  id,
  first_name,
  last_name,
  CONCAT_WS(' ', first_name, last_name) AS full_name
FROM employees;

-- 8. Find employees whose email starts with 'a' (case-insensitive)
-- Uses ILIKE and pattern matching
SELECT 
  id, 
  email
FROM employees
WHERE email ILIKE 'a%';

-- 9. Get the first 5 characters of each employee's email
-- Uses LEFT(string, n)
SELECT 
  id, 
  email, 
  LEFT(email, 5) AS email_prefix
FROM employees;

-- 10. Get the last 3 characters of the job title
-- Uses RIGHT(string, n)
SELECT 
  id, 
  job_title, 
  RIGHT(job_title, 3) AS title_suffix
FROM employees;

-- 11. Extract domain using SPLIT_PART (PostgreSQL only)
-- Alternative to SUBSTRING + POSITION
SELECT 
  id, 
  email, 
  SPLIT_PART(email, '@', 2) AS domain_alt
FROM employees;
