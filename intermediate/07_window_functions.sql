-- 07_window_functions.sql
-- Goal: Learn how to use SQL window functions for tasks like ranking, running totals, partitions, and percentile grouping.
-- Note: Window functions operate over a *window* (set of related rows) without collapsing results like GROUP BY.

-- Sample table: employees
-- Columns:
--   id, name, age, department, department_id, job_title,
--   salary, hire_date, email, manager_id, phone

-- 1. Assign a unique row number to each employee within their department, ordered by salary (highest first)
SELECT 
  id,
  name,
  department,
  salary,
  ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_rank
FROM employees;

-- 2. Assign a rank to each employee by salary within their department (ties get the same rank; gaps are left)
SELECT 
  id,
  name,
  department,
  salary,
  RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rank
FROM employees;

-- 3. Assign a dense rank to employees by salary within department (ties get same rank; no gaps)
SELECT 
  id,
  name,
  department,
  salary,
  DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dense_rank
FROM employees;

-- 4. Compute a running total of salaries across all employees ordered by hire date
SELECT 
  id,
  name,
  salary,
  hire_date,
  SUM(salary) OVER (ORDER BY hire_date) AS running_total_salary
FROM employees;

-- 5. Compute a running total of salaries within each department ordered by salary
SELECT 
  id,
  name,
  department,
  salary,
  SUM(salary) OVER (PARTITION BY department ORDER BY salary) AS running_total
FROM employees;

-- 6. Calculate average salary within each department (repeated for each row)
SELECT 
  id,
  name,
  department,
  salary,
  AVG(salary) OVER (PARTITION BY department) AS dept_avg_salary
FROM employees;

-- 7. Show difference between each employee’s salary and the department average
SELECT 
  id,
  name,
  department,
  salary,
  salary - AVG(salary) OVER (PARTITION BY department) AS diff_from_avg
FROM employees;

-- 8. Divide employees into salary quartiles (4 equal groups) using NTILE
-- NTILE assigns a bucket number (1 to N) based on order
SELECT 
  id,
  name,
  salary,
  NTILE(4) OVER (ORDER BY salary DESC) AS salary_quartile
FROM employees;

-- 9. Show the salary of the next lower-paid employee in the same department
-- LEAD looks forward (next row) within each department, ordered by salary descending
SELECT 
  id,
  name,
  department,
  salary,
  LEAD(salary, 1) OVER (PARTITION BY department ORDER BY salary DESC) AS next_lower_salary
FROM employees;

-- 10. Show the salary of the previous higher-paid employee in the same department
-- LAG looks backward (previous row) within each department, ordered by salary descending
SELECT 
  id,
  name,
  department,
  salary,
  LAG(salary, 1) OVER (PARTITION BY department ORDER BY salary DESC) AS previous_higher_salary
FROM employees;

-- 11. Show the next salary in department, default to 0 if none
-- This avoids NULLs at the end of each department group
SELECT 
  id,
  name,
  department,
  salary,
  LEAD(salary, 1, 0) OVER (PARTITION BY department ORDER BY salary DESC) AS next_lower_salary_or_0
FROM employees;

-- 12. Find the top earner in each department using a CTE with ROW_NUMBER
WITH ranked_employees AS (
  SELECT 
    *,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS rn
  FROM employees
)
SELECT 
  id,
  name,
  department,
  salary
FROM ranked_employees
WHERE rn = 1;
