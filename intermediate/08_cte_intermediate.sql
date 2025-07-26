-- 08_cte_intermediate.sql
-- Goal: Learn intermediate use cases of Common Table Expressions (CTEs),
--       including chaining CTEs, combining them with joins, aggregations and window functions.
-- Note: Make sure to complete window functions and basic CTEs before starting.

-- Sample table: employees
-- Columns:
--   id, name, age, department, department_id, job_title,
--   salary, hire_date, email, manager_id, phone

-- 1. Use a CTE to compute average salary per department and salary difference
-- Then join it with the employees table to compare each employee's salary
WITH dept_avg AS (
  SELECT department_id, AVG(salary) AS avg_salary
  FROM employees
  GROUP BY department_id
)
SELECT 
  e.name,
  e.salary,
  d.avg_salary,
  e.salary - d.avg_salary AS salary_diff
FROM employees e
JOIN dept_avg d
  ON e.department_id = d.department_id;


-- 2. Use a window function in a CTE to compute average salary per department and salary difference
-- This avoids the need for a separate JOIN, simplifying the query
WITH employee_with_avg AS (
  SELECT 
    name,
    salary,
    department_id,
    AVG(salary) OVER (PARTITION BY department_id) AS avg_salary
  FROM employees
)
SELECT 
  name,
  salary,
  avg_salary,
  salary - avg_salary AS salary_diff
FROM employee_with_avg;


-- 3. Chain two CTEs: 
-- First, filter employees earning above 80,000.
-- Then rank them within each department using ROW_NUMBER.
WITH high_earners AS (
  SELECT * 
  FROM employees
  WHERE salary > 80000
),
ranked_employees AS (
  SELECT 
    name,
    department,
    salary,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS rank_in_dept
  FROM high_earners
)
SELECT * FROM ranked_employees;


-- 4. Use a CTE with the LAG window function to compare each employee's salary
-- to the previous employee (ordered by salary) in the same department.
WITH salary_comparison AS (
  SELECT 
    id,
    name,
    department,
    salary,
    LAG(salary, 1) OVER (PARTITION BY department ORDER BY salary DESC) AS previous_salary
  FROM employees
)
SELECT 
  *,
  salary - previous_salary AS diff_from_previous
FROM salary_comparison;