-- 10_null_behavior_joins_aggregates.sql
-- Goal: Understand how NULLs affect joins and aggregation results in SQL

-- Sample table: employees
-- Columns:
--   id, name, age, department, department_id, job_title,
--   salary, hire_date, email, manager_id, phone

-- Sample table: departments  
-- Columns: id, name


-- 1. LEFT JOIN: rows with NULL foreign keys still appear
-- Show employees with their manager names. If no manager is found, shows NULL.
SELECT 
  e.name AS employee,
  m.name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.id;

-- 2. LEFT JOIN with GROUP BY: preserves departments even if they have no employees
-- Departments like 'Marketing' (with no employees) will still appear.
SELECT 
  d.name AS department,
  COUNT(e.id) AS num_employees
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
GROUP BY d.name;

-- 3. INNER JOIN: NULL foreign key causes the row to be excluded
SELECT 
  e.name AS employee,
  d.name AS department
FROM employees e
INNER JOIN departments d ON e.department_id = d.id;

-- 4. Aggregation: COUNT(*) vs COUNT(column)
-- COUNT(*) counts all rows, including those with NULLs.
-- COUNT(column) ignores rows where the column is NULL.
SELECT 
  COUNT(*) AS total_rows,
  COUNT(salary) AS non_null_salaries
FROM employees;

-- 5. SUM and AVG ignore NULL values
SELECT 
  SUM(salary) AS total_salary,
  AVG(salary) AS avg_salary
FROM employees;

-- 6. GROUP BY with NULLs
-- NULLs are treated as a single group
SELECT 
  department_id,
  COUNT(*) AS num_employees
FROM employees
GROUP BY department_id;

-- 7. Using COALESCE to provide default values
-- Replace NULL department_id with -1
SELECT 
  name,
  COALESCE(department_id, -1) AS dept_id
FROM employees;

-- 8. NULL-safe comparisons
-- Using '=' with NULL does not work: it yields UNKNOWN
SELECT * FROM employees WHERE department_id = NULL;  -- Incorrect: returns 0 rows

-- Correct approach: use IS NULL
SELECT * FROM employees WHERE department_id IS NULL;

-- 9. Filtering out NULLs before aggregation (common in practice)
SELECT 
  department_id,
  AVG(salary) AS avg_salary
FROM employees
WHERE salary IS NOT NULL
GROUP BY department_id;
