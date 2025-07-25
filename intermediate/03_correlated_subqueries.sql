-- 03_correlated_subqueries.sql
-- Goal: Learn how to use correlated subqueries for comparisons and with EXISTS/NOT EXISTS
-- Note: These are correlated subqueries — they reference columns from the outer query.

-- Sample table: employees
-- Columns:
--   id, name, age, department, department_id, job_title,
--   salary, hire_date, email, manager_id, phone


-- 1. Get employees whose salary is above the average salary in their own department
-- For each employee, the subquery computes the average salary of employees in the same department.
SELECT 
  id, name, department_id, salary
FROM employees e
WHERE salary > (
  SELECT AVG(salary)
  FROM employees
  WHERE department_id = e.department_id
);


-- 2. Get employees whose age is greater than the average age of all employees hired in the same year
-- This uses a correlated subquery on hire_date to find the average age per year.
-- For each employee, the subquery calculates the average age of employees hired in that same year.
SELECT 
  id, name, age, hire_date
FROM employees e
WHERE age > (
  SELECT AVG(age)
  FROM employees
  WHERE EXTRACT(YEAR FROM hire_date) = EXTRACT(YEAR FROM e.hire_date)
);

-- 3. Get employees who manage at least one person earning more than 100000
-- EXISTS checks if there is any employee whose manager_id is this employee's id and salary is > 100000.
SELECT 
  id, name
FROM employees e
WHERE EXISTS (
  SELECT 1
  FROM employees s
  WHERE s.manager_id = e.id AND s.salary > 100000
);


-- 4. Get employees who do not manage anyone and earn more than 70000
-- NOT EXISTS checks that there is no employee whose manager_id equals this employee's id.
-- In other words, the employee does not manage anyone.
SELECT 
  id, name
FROM employees e
WHERE NOT EXISTS (
  SELECT 1
  FROM employees s
  WHERE s.manager_id = e.id
)
AND salary > 70000;