-- 03_slow_query_debugging.sql
-- Diagnosing slow SQL queries
-- Concepts: Bottleneck detection, I/O cost, CPU cost


/*
Scenario:
You have a query that runs slow despite having indexes. How do you find the reason?
This script walks through how to debug such queries using tools like EXPLAIN, ANALYZE,
and understanding CPU vs. I/O bottlenecks.
*/

-- Step 1: Use EXPLAIN (or EXPLAIN ANALYZE) to inspect the execution plan
-- EXPLAIN shows how the query is executed: scan type, index usage, row estimates

-- Example:
EXPLAIN ANALYZE
SELECT order_id, total_amount
FROM orders
WHERE customer_id = 123;

-- Look for:
-- - Sequential Scan vs Index Scan
-- - Rows returned vs Rows planned
-- - Time taken at each step
-- - Cost breakdown (startup cost, total cost)

-- Sequential Scan on large tables = potential I/O bottleneck


-- Step 2: Watch for red flags in EXPLAIN output

-- 🔍 Common bottlenecks:
-- - Seq Scan → index missing or ignored
-- - High actual time vs expected rows
-- - Join type = Nested Loop with many rows (can be slow)
-- - Sort or Hash operations with large memory use
-- - Too many rows read vs returned → inefficient filtering

-- Example:
-- Query returns 100 rows, but EXPLAIN shows 1M rows read → investigate filter conditions


-- Step 3: Investigate I/O vs. CPU cost

-- I/O-bound queries:
-- - Reading large tables from disk
-- - No or poor indexing
-- - Large joins or full scans
-- → Solution: Add/select better indexes, filter earlier, reduce joins

-- CPU-bound queries:
-- - Complex expressions in WHERE, JOIN, GROUP BY
-- - Functions or casting on indexed columns
-- - Large sorts or aggregations
-- → Solution: Simplify expressions, use raw columns, avoid functions on indexed fields


-- Step 4: Avoid functions on indexed columns (breaks index usage)

-- BAD: Function applied on indexed column → index ignored
SELECT * FROM orders WHERE DATE(order_date) = '2023-08-01';

-- GOOD: Use range filter to preserve index usage
SELECT * FROM orders
WHERE order_date >= '2023-08-01'
  AND order_date < '2023-08-02';


-- Step 5: Check for implicit casting

-- BAD: Comparing integer column to string value → index not used
SELECT * FROM orders WHERE customer_id = '123';

-- GOOD: Match data types
SELECT * FROM orders WHERE customer_id = 123;


-- Step 6: Consider LIMIT for large result sets

-- BAD: Fetches all matching rows, even if only top results are needed
SELECT * FROM orders WHERE status = 'SHIPPED' ORDER BY order_date;

-- GOOD: LIMIT reduces rows fetched → improves response time
SELECT * FROM orders
WHERE status = 'SHIPPED'
ORDER BY order_date DESC
LIMIT 100;


-- Step 7: Profile query using tools (PostgreSQL examples)
-- - EXPLAIN (costs only)
-- - EXPLAIN ANALYZE (actual run time)
-- - pg_stat_statements (track slow queries over time)
-- - auto_explain (logs slow queries with plans)

-- Tip: Use EXPLAIN ANALYZE only on safe queries (e.g., SELECT),
-- as it runs the query and shows real execution stats.


/*
🧪 Practice Task:
1. Run EXPLAIN ANALYZE on a slow query and identify the scan type and cost.
2. Rewrite a query that uses functions on indexed columns to make it index-friendly.
3. Try using LIMIT in a slow query and compare execution time.
*/
