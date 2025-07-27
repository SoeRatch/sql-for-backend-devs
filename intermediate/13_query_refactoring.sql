-- 13_query_refactoring.sql
-- Goal: Learn to rewrite inefficient or hard-to-read queries using JOINs, CTEs, and derived tables
-- Focus: Refactoring subqueries or overly nested logic into cleaner and faster alternatives

-- Sample table: employees
-- Columns: id, name, age, department, department_id, job_title, salary, hire_date, email, manager_id, phone
-- Sample table: departments
-- Columns: id, name

-- 1. Refactor scalar subquery in SELECT to a JOIN
-- Anti-pattern: Scalar subquery in SELECT (runs once per row)
SELECT name,
       (SELECT d.name FROM departments d WHERE d.id = e.department_id) AS department_name
FROM employees e;

-- Refactored: Use JOIN instead (runs once per row, but JOIN is optimized and easier to maintain)
SELECT e.name, d.name AS department_name
FROM employees e
JOIN departments d ON e.department_id = d.id;


-- 2. Refactor repeated subquery using CTE
-- Anti-pattern: Repeating the same subquery multiple times
SELECT name,
       (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id) AS avg_dept_salary,
       salary - (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id) AS salary_diff
FROM employees e;

-- Refactored: Use CTE to compute the AVG once per department
WITH dept_avg AS (
  SELECT department_id, AVG(salary) AS avg_salary
  FROM employees
  GROUP BY department_id
)
SELECT e.name,
       d.avg_salary,
       e.salary - d.avg_salary AS salary_diff
FROM employees e
JOIN dept_avg d ON e.department_id = d.department_id;


-- 3. Refactor correlated subquery in WHERE to JOIN + CTE
-- Anti-pattern: Correlated subquery in WHERE (AVG recalculated per row)
SELECT name
FROM employees e
WHERE salary > (
  SELECT AVG(salary)
  FROM employees
  WHERE department_id = e.department_id
);

-- Refactored: Use CTE to precompute AVG per department, then join
WITH dept_avg AS (
  SELECT department_id, AVG(salary) AS avg_salary
  FROM employees
  GROUP BY department_id
)
SELECT e.name
FROM employees e
JOIN dept_avg d ON e.department_id = d.department_id
WHERE e.salary > d.avg_salary;


-- 4. Refactor nested aggregation
-- Anti-pattern: Subquery in FROM for simple aggregation
SELECT name
FROM (
  SELECT name, salary
  FROM employees
  WHERE salary = (SELECT MAX(salary) FROM employees)
) AS top_earners;

-- Refactored: Use CTE for clarity
WITH max_salary AS (
  SELECT MAX(salary) AS max_salary FROM employees
)
SELECT e.name
FROM employees e
JOIN max_salary m ON e.salary = m.max_salary;


-- 5. Use window function instead of subquery
-- Anti-pattern: Subquery for ranking or filtering
SELECT *
FROM employees e
WHERE salary = (
  SELECT MAX(salary)
  FROM employees
  WHERE department_id = e.department_id
);

-- Refactored: Use ROW_NUMBER window function to find top salary per department
WITH ranked AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rn
  FROM employees
)
SELECT name, salary, department_id
FROM ranked
WHERE rn = 1;
