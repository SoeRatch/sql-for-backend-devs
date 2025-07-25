-- 11_math_functions.sql
-- Goal: Practice basic SQL mathematical and numeric functions

-- Sample table: employees
-- Columns:
--   id, name, age, department, department_id, job_title,
--   salary, hire_date, email, manager_id, phone

-- Functions covered:
--   ROUND, CEIL, FLOOR, ABS, POWER, SQRT, MOD, RANDOM, SETSEED

-- 1. Round each employee's salary to the nearest thousand
-- Example: 55325 becomes 55000
SELECT 
  id, 
  name,
  salary,
  ROUND(salary, -3) AS salary_rounded_to_1000
FROM employees;

-- 2. Round salary up and down to the nearest integer
SELECT 
  id,
  salary,
  CEIL(salary) AS salary_ceil,
  FLOOR(salary) AS salary_floor
FROM employees;

-- 3. Get the absolute difference between salary and a benchmark
-- Useful for comparing deviations
SELECT 
  id,
  salary,
  ABS(salary - 50000) AS deviation_from_50k
FROM employees;

-- 4. Square and square root of salary
-- Demonstrates use of POWER and SQRT
SELECT 
  id,
  salary,
  POWER(salary, 2) AS salary_squared,
  SQRT(salary) AS salary_sqrt
FROM employees;

-- 5. Get remainder of salary when divided by 10000
-- MOD returns remainder of division
SELECT 
  id,
  salary,
  MOD(salary, 10000) AS remainder_in_10k_bands
FROM employees;

-- 6. Generate a random bonus percentage up to 10%, rounded to 2 decimals
-- RANDOM returns a value between 0 and 1 (exclusive)
SELECT 
  id,
  name,
  salary,
  ROUND(RANDOM() * 0.10, 2) AS random_bonus_pct  -- Up to 10%
FROM employees;

-- 7. Generate reproducible random values (for testing/demo)
-- SETSEED sets the seed for RANDOM() to make results deterministic
-- NOTE: This applies to the session, so SETSEED affects future calls
SELECT SETSEED(0.5);  -- Optional: run before a query for consistent random values

-- Then run the query again to see consistent results
SELECT 
  id,
  ROUND(RANDOM(), 3) AS seeded_random
FROM employees;