-- 03_order_by_limit_offset.sql
-- Goal: Learn how to sort and paginate query results using ORDER BY, LIMIT, and OFFSET

-- Sample table: employees
-- Columns:
--   id, name, age, department, department_id, job_title,
--   salary, hire_date, email, manager_id, phone

-- 1. Sort all employees by salary in ascending order
SELECT id, name, salary
FROM employees
ORDER BY salary ASC;

-- 2. Sort employees by hire date in descending order
SELECT name, hire_date
FROM employees
ORDER BY hire_date DESC;

-- 3. Get top 5 highest-paid employees
SELECT name, salary
FROM employees
ORDER BY salary DESC
LIMIT 5;

-- 4. Get the 6th to 10th highest-paid employees (pagination using OFFSET)
-- Explanation: OFFSET 5 skips the top 5 rows (highest-paid),
-- then LIMIT 5 selects the next 5 rows (i.e., 6th to 10th highest-paid)
SELECT name, salary
FROM employees
ORDER BY salary DESC
LIMIT 5 OFFSET 5;

-- 5. List employees sorted by department, then by name within each department
SELECT name, department
FROM employees
ORDER BY department ASC, name ASC;

-- 6. Use LIMIT without ORDER BY (not recommended in real-world scenarios)
-- This just picks any 3 rows, order is not guaranteed
SELECT *
FROM employees
LIMIT 3;

-- 7. Combine WHERE and ORDER BY
SELECT name, salary
FROM employees
WHERE department = 'Engineering'
ORDER BY salary DESC;

-- 8. Get last 5 hired employees in Marketing
SELECT name, hire_date
FROM employees
WHERE department = 'Marketing'
ORDER BY hire_date DESC
LIMIT 5;
