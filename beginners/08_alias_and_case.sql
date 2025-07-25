-- 08_alias_and_case.sql
-- Goal: Learn how to use aliases (AS) for columns and tables, and how to write conditional logic using CASE

-- Sample table: employees
-- Columns:
--   id, name, age, department, department_id, job_title,
--   salary, hire_date, email, manager_id

-- 1. Rename column output using AS
SELECT name AS employee_name, salary AS monthly_salary
FROM employees;

-- 2. Alias table name
SELECT e.name, e.salary
FROM employees AS e;

-- 3. Use CASE to categorize salary levels
SELECT
    name,
    salary,
    CASE
        WHEN salary >= 100000 THEN 'High'
        WHEN salary >= 50000 THEN 'Medium'
        ELSE 'Low'
    END AS salary_level
FROM employees;

-- 4. Use CASE to check if the employee is a manager or not
-- manager_id is NULL means they don't report to anyone
SELECT
    name,
    CASE
        WHEN manager_id IS NULL THEN 'Manager'
        ELSE 'Employee'
    END AS role
FROM employees;

-- 5. Nested CASE for job title assignment based on department
SELECT
    name,
    department,
    CASE
        WHEN department = 'Engineering' THEN 'Engineer'
        WHEN department = 'HR' THEN 'HR Specialist'
        WHEN department = 'Sales' THEN 'Sales Rep'
        ELSE 'Other'
    END AS job_title_label
FROM employees;
