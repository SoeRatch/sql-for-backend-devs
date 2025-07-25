-- 10_union_intersect_except.sql
-- Goal: Learn how to combine multiple SELECT query results using UNION, INTERSECT, and EXCEPT

-- Sample table: employees
-- Columns:
--   id, name, age, department, department_id, job_title,
--   salary, hire_date, email, manager_id, phone

-- Table: contractors
-- Columns: id, name, department_id, hourly_rate

-- 1. UNION: Get a combined list of employee and contractor names (removes duplicates)
SELECT name FROM employees
UNION
SELECT name FROM contractors;

-- 2. UNION ALL: Get all names from employees and contractors (including duplicates)
SELECT name FROM employees
UNION ALL
SELECT name FROM contractors;

-- 3. INTERSECT: Get names that appear in both employees and contractors
SELECT name FROM employees
INTERSECT
SELECT name FROM contractors;

-- 4. EXCEPT (also called MINUS in some databases): Get employee names that are not in contractors
SELECT name FROM employees
EXCEPT
SELECT name FROM contractors;

-- 5. Combine multiple columns: Get department_id and name from both employees and contractors
SELECT department_id, name FROM employees
UNION
SELECT department_id, name FROM contractors;
