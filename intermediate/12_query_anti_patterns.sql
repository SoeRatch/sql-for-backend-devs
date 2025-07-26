-- 12_query_anti_patterns.sql
-- Goal: Understand common SQL anti-patterns to avoid in real-world queries

-- Sample table: employees
-- Columns:
--   id, name, age, department, department_id, job_title,
--   salary, hire_date, email, manager_id, phone

-- Sample table: departments  
-- Columns: id, name


-- 1. Anti-pattern: SELECT *
-- Problem: Fetches all columns unnecessarily, increases I/O and network load
SELECT * FROM employees;

-- Preferred:
SELECT name, job_title FROM employees;


-- 2. Anti-pattern: Redundant subquery
-- Problem: Unnecessary nesting increases complexity without benefit
SELECT * FROM (
  SELECT * FROM employees
) AS e;

-- Preferred:
SELECT * FROM employees;


-- 3. Anti-pattern: Scalar subqueries in SELECT (executed row-by-row)
-- Problem: Can cause performance issues on large datasets
SELECT 
  name,
  (SELECT d.name FROM departments d WHERE d.id = e.department_id) AS dept_name
FROM employees e;

-- Preferred: Use JOIN instead
SELECT 
  e.name,
  d.name AS dept_name
FROM employees e
JOIN departments d ON e.department_id = d.id;


-- 4. Anti-pattern: Using OR between different columns
-- Problem: OR across columns prevents index usage, causing full table scans and slow performance.
SELECT * FROM employees 
WHERE department_id = 1 OR manager_id = 5;

-- Preferred: Combine with UNION ALL if possible
-- Each query can use its respective index, improving performance.
SELECT * FROM employees WHERE department_id = 1
UNION ALL
SELECT * FROM employees WHERE manager_id = 5;
-- UNION ALL is also faster than UNION because it skips sorting and deduplication.
-- Use UNION only if removing duplicates is necessary.
-- In practice, duplicate rows are unlikely here (an employee usually matches only one condition).


-- 5. Anti-pattern: Function on indexed column in WHERE clause
-- Problem: Disables index, causes full table scan
SELECT * FROM employees 
WHERE YEAR(hire_date) = 2022;

-- Preferred: Rewrite to use range filtering
SELECT * FROM employees 
WHERE hire_date >= '2022-01-01' AND hire_date < '2023-01-01';


-- 6. Anti-pattern: Using NOT IN when subquery may return NULLs
-- Problem: SQL uses 3-valued logic (TRUE, FALSE, UNKNOWN)
-- and rewrites: dept_id NOT IN (1, NULL) as -> dept_id != 1 AND dept_id != NULL
-- The NULL check returns UNKNOWN so the second condition is never true, so the whole condition fails.
SELECT * FROM employees 
WHERE department_id NOT IN (SELECT department_id FROM departments WHERE name = 'HR');

-- Fix: Use NOT EXISTS to safely exclude matches, even with NULLs
SELECT * FROM employees e
WHERE NOT EXISTS (
  SELECT 1 FROM departments d 
  WHERE d.name = 'HR' AND d.id = e.department_id
);


-- 7. Anti-pattern: Implicit joins in WHERE clause
-- Problem: Harder to read, can cause accidental cross joins
SELECT e.name, d.name AS department
FROM employees e, departments d
WHERE e.department_id = d.id;

-- Preferred: Use explicit JOIN
SELECT e.name, d.name AS department
FROM employees e
JOIN departments d ON e.department_id = d.id;


-- 8. Anti-pattern: GROUP BY with non-aggregated, non-grouped columns (MySQL-specific)
-- Problem: In MySQL, this runs without error (if ONLY_FULL_GROUP_BY is disabled), but returns arbitrary values.
-- PostgreSQL or SQL Server would reject it as invalid.
SELECT department_id, name
FROM employees
GROUP BY department_id;

-- Preferred: Select only columns that are grouped or aggregated
-- This is standard SQL and gives consistent, portable results.
SELECT department_id, COUNT(*) AS num_employees
FROM employees
GROUP BY department_id;

