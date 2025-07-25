-- 05_groupby_having.sql
-- Goal: Learn how to group data and filter aggregated results using GROUP BY and HAVING
-- Covers: GROUP BY, aggregate functions with grouping, HAVING clause

-- Sample table: employees
-- Columns: id, name, department, job_title, salary, hire_date, email

-- 1. Count number of employees in each department
SELECT department, COUNT(*) AS total_employees
FROM employees
GROUP BY department;

-- 2. Find the average salary in each department
SELECT department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department;

-- 3. Find total salary paid per job title
SELECT job_title, SUM(salary) AS total_salary
FROM employees
GROUP BY job_title;

-- 4. Get departments with more than 5 employees (using HAVING)
SELECT department, COUNT(*) AS total_employees
FROM employees
GROUP BY department
HAVING COUNT(*) > 5;

-- 5. Get job titles where average salary is more than 80,000
SELECT job_title, AVG(salary) AS avg_salary
FROM employees
GROUP BY job_title
HAVING AVG(salary) > 80000;

-- 6. Get departments with maximum salary more than 100,000
SELECT department, MAX(salary) AS max_salary
FROM employees
GROUP BY department
HAVING MAX(salary) > 100000;

-- 7. Combine GROUP BY with WHERE: Only consider employees hired after 2020
SELECT department, COUNT(*) AS total_employees
FROM employees
WHERE hire_date >= '2020-01-01'
GROUP BY department;
