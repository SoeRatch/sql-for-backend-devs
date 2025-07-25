-- 02_conditional_aggregation.sql
-- Goal: Learn how to use conditional aggregation with CASE statements inside aggregate functions

-- Sample table: employees
-- Columns:
--   id, name, age, department, department_id, job_title,
--   salary, hire_date, email, manager_id

-- 1. Count employees by department
SELECT department_id, COUNT(*) AS total_employees
FROM employees
GROUP BY department_id;

-- 2. Count employees per department, broken down by job title
-- We use CASE inside COUNT to include only specific job titles.
-- COUNT ignores NULLs, so CASE returns 1 for the job title we want and NULL otherwise.
SELECT 
  department_id,
  COUNT(*) AS total_employees,
  COUNT(CASE WHEN job_title = 'Engineer' THEN 1 END) AS engineers,
  COUNT(CASE WHEN job_title = 'Manager' THEN 1 END) AS managers,
  COUNT(CASE WHEN job_title = 'Analyst' THEN 1 END) AS analysts
FROM employees
GROUP BY department_id;

-- 3. Sum of salaries by department and job title
-- We use CASE inside SUM to conditionally add salary based on job title.
-- CASE returns salary if the condition is met, otherwise 0.
SELECT 
  department_id,
  SUM(CASE WHEN job_title = 'Engineer' THEN salary ELSE 0 END) AS engineer_salary,
  SUM(CASE WHEN job_title = 'Manager' THEN salary ELSE 0 END) AS manager_salary,
  SUM(CASE WHEN job_title = 'Analyst' THEN salary ELSE 0 END) AS analyst_salary
FROM employees
GROUP BY department_id;
