-- Goal: Learn how to filter data using different operators in WHERE clause
-- Covers: IN, BETWEEN, LIKE, IS NULL, IS NOT NULL, DISTINCT

-- Sample table: employees
-- Columns: id, name, department, salary, hire_date, email

-- 1. Find employees in either 'Sales', 'HR', or 'Marketing' department
SELECT *
FROM employees
WHERE department IN ('Sales', 'HR', 'Marketing');

-- 2. Get employees with salary between 50,000 and 80,000
SELECT name, salary
FROM employees
WHERE salary BETWEEN 50000 AND 80000;

-- 3. List employees whose name starts with 'A'
SELECT id, name
FROM employees
WHERE name LIKE 'A%';

-- 4. Find employees whose email ends with 'company.com'
SELECT name, email
FROM employees
WHERE email LIKE '%@company.com';

-- 5. Get employees whose department is not mentioned (NULL)
SELECT id, name
FROM employees
WHERE department IS NULL;

-- 6. Get employees whose department is filled (NOT NULL)
SELECT id, name, department
FROM employees
WHERE department IS NOT NULL;

-- 7. List all unique departments in the company
SELECT DISTINCT department
FROM employees;

-- 8. Find employees not in 'Engineering' or 'Product'
SELECT name, department
FROM employees
WHERE department NOT IN ('Engineering', 'Product');

-- 9. Employees with salary not between 40,000 and 90,000
SELECT name, salary
FROM employees
WHERE salary NOT BETWEEN 40000 AND 90000;

-- 10. Employees whose name contains 'son'
SELECT id, name
FROM employees
WHERE name LIKE '%son%';

-- 💡 TIP: LIKE is case-insensitive in some SQL dialects (like MySQL), but not in others (like Postgres).
