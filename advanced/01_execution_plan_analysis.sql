-- 01_execution_plan_analysis.sql
-- Goal: Learn how to read and interpret EXPLAIN and EXPLAIN ANALYZE output
-- Focus: Query plan steps, costs, rows estimation, indexes, sequential scans, etc.

-- Sample Table: orders
-- id (PK), user_id (FK), product_id (FK), order_date, quantity, price

-- Step 1: Basic SELECT
EXPLAIN
SELECT * FROM orders
WHERE order_date >= '2023-01-01';

-- Step 2: Add ANALYZE to measure actual performance
EXPLAIN ANALYZE
SELECT * FROM orders
WHERE order_date >= '2023-01-01';

-- Step 3: Filter on indexed vs non-indexed column (assume index on order_date)
-- Observe the difference in plan (Seq Scan vs Index Scan)
EXPLAIN ANALYZE
SELECT * FROM orders
WHERE order_date = '2023-06-01';

-- Step 4: Analyze a JOIN
-- Sample Table: users (id, name, email)
EXPLAIN ANALYZE
SELECT u.name, o.order_date, o.quantity
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.order_date >= '2023-01-01';

-- Step 5: Using functions on filter columns disables index usage
EXPLAIN ANALYZE
SELECT * FROM orders
WHERE DATE(order_date) = '2023-06-01';  -- Likely forces Seq Scan

-- Step 6: LIMIT and OFFSET effects on plan
EXPLAIN ANALYZE
SELECT * FROM orders
ORDER BY order_date DESC
LIMIT 10 OFFSET 1000;

-- Step 7: Filter with range and index
EXPLAIN ANALYZE
SELECT * FROM orders
WHERE order_date BETWEEN '2023-01-01' AND '2023-12-31';

-- Step 8: Force planner to show detailed cost
EXPLAIN (ANALYZE, VERBOSE, BUFFERS, FORMAT TEXT)
SELECT * FROM orders
WHERE quantity > 10;

-- Step 9: Bad estimation example — use statistics update
ANALYZE orders;

-- Step 10: Nested loop vs Hash Join (large datasets)
EXPLAIN ANALYZE
SELECT *
FROM orders o
JOIN products p ON o.product_id = p.id;

-- Notes:
-- - Rows: estimated vs actual row count
-- - Loops: how many times each node is executed
-- - Buffers: I/O cost, if using BUFFERS option
-- - Index Scan: faster if filtered column is indexed
-- - Seq Scan: full table scan
-- - Join Method: Nested Loop, Hash Join, Merge Join depending on size and join keys
-- - Misuse of functions, type casting can prevent index usage

-- Pro Tips:
-- - Use `EXPLAIN (ANALYZE, BUFFERS)` regularly in testing
-- - Always compare estimated and actual rows to catch planning issues
-- - Beware of "rows removed by filter" – signals inefficient scans
-- - Use `pg_stat_statements` in production for slow query tracking (PostgreSQL)
