-- 07_joins_basics.sql
-- Goal: Learn how to use INNER JOIN and LEFT JOIN to combine data from multiple tables

-- Sample table: employees
-- Columns:
--   id, name, age, department, department_id, job_title,
--   salary, hire_date, email, manager_id

-- Sample table: departments  
-- Columns: id, name

-- 1. INNER JOIN: Get employee names with their department names
SELECT e.name AS employee_name, d.name AS department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.id;

-- 2. LEFT JOIN: Get all employees with their department names (NULL if no department)
SELECT e.name AS employee_name, d.name AS department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.id;

-- 3. INNER JOIN: Show employees and their department names where salary > 60000
SELECT e.name, e.salary, d.name AS department
FROM employees e
INNER JOIN departments d ON e.department_id = d.id
WHERE e.salary > 60000;

-- 4. LEFT JOIN: Find employees who are not assigned to any department
SELECT e.name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.id
WHERE d.id IS NULL;

-- 5. INNER JOIN: Get department name along with number of employees (useful for future GROUP BY)
SELECT d.name AS department_name, COUNT(e.id) AS employee_count
FROM departments d
INNER JOIN employees e ON e.department_id = d.id
GROUP BY d.name;
