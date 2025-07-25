-- 04_ctes.sql
-- Goal: Learn basic Common Table Expressions (CTEs) with the WITH clause
-- Note: CTEs help make queries more readable and reusable by giving subqueries a name

-- Sample table: employees
-- Columns:
--   id, name, age, department, department_id, job_title,
--   salary, hire_date, email, manager_id, phone

-- 1. Create a CTE to get employees with salary > 100000
WITH high_earners AS (
  SELECT id, name, salary, department_id
  FROM employees
  WHERE salary > 100000
)
SELECT *
FROM high_earners;

-- 2. Use a CTE to calculate average salary per department
WITH dept_avg_salary AS (
  SELECT department_id, AVG(salary) AS avg_salary
  FROM employees
  GROUP BY department_id
)
SELECT 
  e.name, e.department_id, e.salary, d.avg_salary
FROM employees e
JOIN dept_avg_salary d
  ON e.department_id = d.department_id;

-- 3. Chain two CTEs: filter by age, then find high earners among them
WITH older_employees AS (
  SELECT *
  FROM employees
  WHERE age > 40
),
high_earners_over_40 AS (
  SELECT name, salary
  FROM older_employees
  WHERE salary > 90000
)
SELECT *
FROM high_earners_over_40;
