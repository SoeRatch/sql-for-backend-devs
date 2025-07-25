-- 01_joins_intermediate.sql
-- Goal: Learn more types of joins - RIGHT, FULL OUTER, CROSS, and SELF JOIN

-- Sample table: employees
-- Columns:
--   id, name, age, department, department_id, job_title,
--   salary, hire_date, email, manager_id

-- Sample table: departments  
-- Columns: id, name

-- 1. RIGHT JOIN: Get all departments and their employees (even if no employee is assigned)
SELECT d.id AS department_id, d.name AS department_name, e.name AS employee_name
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.id;

-- 2. FULL OUTER JOIN: Get all employees and all departments, even if no match exists
SELECT e.name AS employee_name, d.name AS department_name
FROM employees e
FULL OUTER JOIN departments d ON e.department_id = d.id;

-- 3. CROSS JOIN: Get every possible combination of employee and department
SELECT e.name AS employee_name, d.name AS department_name
FROM employees e
CROSS JOIN departments d;

-- 4. SELF JOIN: Get employee and their manager details
SELECT e.name AS employee_name, m.name AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.id;
