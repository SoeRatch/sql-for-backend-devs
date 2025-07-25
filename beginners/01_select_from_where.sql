-- 01_select_from_where.sql
-- Basic SELECT and WHERE usage

-- Sample table: employees
-- Columns: id, name, age, department, salary

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