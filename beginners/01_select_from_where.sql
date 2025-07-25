-- 01_select_from_where.sql
-- Goal: Learn how to write basic SELECT statements and filter data using WHERE

-- Sample table: employees
-- Columns:
--   id, name, age, department, department_id, job_title,
--   salary, hire_date, email, manager_id, phone

-- 1. Select all employees
SELECT *
FROM employees;

-- 2. Select specific columns
SELECT name, salary
FROM employees;

-- 3. Filter employees older than 30
SELECT name, age
FROM employees
WHERE age > 30;

-- 4. Filter employees not in HR department
SELECT name, department
FROM employees
WHERE department != 'HR';