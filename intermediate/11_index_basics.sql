-- 11_index_basics.sql
-- Goal: Understand how indexes work, when they help, and their limitations

-- Sample table: employees
-- Columns:
--   id, name, age, department, department_id, job_title,
--   salary, hire_date, email, manager_id, phone

-- Sample table: departments  
-- Columns: id, name


-- 1. What is an Index?
-- An index is a data structure that improves query speed by allowing faster lookups.
-- Think of it like a book index that lets you jump to the right page instead of reading the whole book.

-- 2. Without Index: Full table scan
-- This query will scan every row to find matches.
SELECT * FROM employees WHERE email = 'alice@example.com';

-- 3. With Index: Fast lookup
-- Create an index to speed up lookups on the 'email' column.
CREATE INDEX idx_employees_email ON employees(email);

-- Now the query uses the index and performs faster.
SELECT * FROM employees WHERE email = 'alice@example.com';

-- 4. Composite Indexes
-- Index on multiple columns can help with queries that filter by more than one column.
CREATE INDEX idx_employees_dept_mgr ON employees(department_id, manager_id);

-- This index will be used if both department_id and manager_id are filtered together.
SELECT * FROM employees 
WHERE department_id = 2 AND manager_id = 5;

-- 5. Index Prefix Matching Rule
-- The composite index can also be used for filtering on the first column (department_id),
-- but not when filtering only by the second column (manager_id).
SELECT * FROM employees WHERE department_id = 2;      -- Uses index
SELECT * FROM employees WHERE manager_id = 5;         -- May not use index

-- 6. Indexes don’t help much with LIKE '%something'
-- Indexes work well when the pattern starts from the beginning.
SELECT * FROM employees WHERE email LIKE 'a%';        -- Can use index
SELECT * FROM employees WHERE email LIKE '%example';  -- Can’t use index efficiently

-- 7. Indexes add overhead on writes (INSERT/UPDATE/DELETE)
-- Avoid creating too many indexes; they slow down data modification.

-- 8. Use EXPLAIN to see if index is being used
-- Most SQL engines support the EXPLAIN keyword to show query plans.
EXPLAIN SELECT * FROM employees WHERE email = 'alice@example.com';
