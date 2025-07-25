-- 04_aggregate_functions.sql
-- Goal: Learn how to use aggregate functions to compute summary statistics over result sets
-- Covers: COUNT, SUM, AVG, MIN, MAX (without GROUP BY)

-- Sample table: employees
-- Columns: id, name, department, job_title, salary, hire_date, email

-- 1. Count total number of employees
SELECT COUNT(*) AS total_employees
FROM employees;

-- 2. Count number of employees with a non-null department
SELECT COUNT(department) AS dept_employees
FROM employees;

-- 3. Count distinct job titles
SELECT COUNT(DISTINCT job_title) AS unique_job_titles
FROM employees;

-- 4. Find the total salary paid to all employees
SELECT SUM(salary) AS total_salary
FROM employees;

-- 5. Find the average salary
SELECT AVG(salary) AS average_salary
FROM employees;

-- 6. Find the highest and lowest salary
SELECT 
  MAX(salary) AS max_salary,
  MIN(salary) AS min_salary
FROM employees;

-- 7. Get the sum and average salary of only engineers
SELECT 
  SUM(salary) AS total_engineer_salary,
  AVG(salary) AS avg_engineer_salary
FROM employees
WHERE job_title LIKE '%Engineer%';
