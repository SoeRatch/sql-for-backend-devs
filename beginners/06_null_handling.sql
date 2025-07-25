-- 06_null_handling.sql
-- Goal: Learn how to handle NULL values in queries
-- Covers: IS NULL, IS NOT NULL, COALESCE, NULLIF

-- Sample tables:
-- employees: id, name, department, job_title, salary, hire_date, email, manager_id
-- bonuses: employee_id, bonus, target

-- 1. Find employees who don’t have a manager
SELECT name, department
FROM employees
WHERE manager_id IS NULL;

-- 2. Find employees who have an email address
SELECT name, email
FROM employees
WHERE email IS NOT NULL;

-- 3. Use COALESCE to replace NULL email with placeholder
SELECT name, COALESCE(email, 'no-email@company.com') AS contact_email
FROM employees;

-- 4. Show salary, or 0 if salary is NULL
SELECT name, COALESCE(salary, 0) AS adjusted_salary
FROM employees;

-- 5. Use NULLIF to avoid division by zero (from bonuses table)
SELECT employee_id, bonus, target,
       bonus / NULLIF(target, 0) AS performance_ratio
FROM bonuses;
-- This prevents the query from crashing when target is zero by returning NULL instead
-- Explanation:
--    NULLIF(target, 0) returns NULL when target is 0
--    Division by NULL does NOT throw an error; it returns NULL
--    So bonus / NULLIF(target, 0) avoids division-by-zero errors


-- 6. Count how many employees have missing emails
SELECT COUNT(*) AS missing_email_count
FROM employees
WHERE email IS NULL;

-- 7. Sort employees by salary (NULLs last)
SELECT name, salary
FROM employees
ORDER BY salary DESC NULLS LAST;

-- 8. Filter out rows where salary is not NULL and calculate average
SELECT AVG(salary) AS avg_salary
FROM employees
WHERE salary IS NOT NULL;
