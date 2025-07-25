-- 09_subqueries_basic.sql
-- Goal: Learn how to use basic subqueries in SELECT, FROM and WHERE clauses
-- Note: These are non-correlated subqueries — they are self-contained and do not reference the outer query


-- Sample table: employees
-- Columns:
--   id, name, age, department, department_id, job_title,
--   salary, hire_date, email, manager_id

-- Sample table: departments  
-- Columns: id, name


-- 1. Get names of employees who earn more than the average salary
SELECT name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);

-- 2. Get departments where the highest salary is greater than 100000
-- Subquery finds department_ids with MAX(salary) > 100000, then outer query gets department names
SELECT name
FROM departments
WHERE id IN (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    HAVING MAX(salary) > 100000
);

-- 3. Show each employee’s name along with their department name (using subquery in SELECT)
SELECT
    name,
    (SELECT name FROM departments WHERE id = employees.department_id) AS department_name
FROM employees;

-- 4. Use subquery in FROM clause to get avg salary per department and filter
SELECT *
FROM (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) AS dept_avg
WHERE avg_salary > 90000;

-- 5. Find employees who work in the same department as 'Alice'
SELECT name
FROM employees
WHERE department_id = (
    SELECT department_id
    FROM employees
    WHERE name = 'Alice'
);
