-- 04_subquery_vs_join_performance.sql
-- Topic: Subquery vs JOIN Performance
-- Goal: Understand when subqueries are faster/slower than joins


/*
Subqueries and joins often produce the same results — but performance can differ.
This script shows when subqueries can outperform joins and when JOINs are better.
*/


-- -----------------------------------------
-- 1. Correlated Subquery vs JOIN (Filtering)
-- -----------------------------------------

-- BAD: Correlated subquery runs once per row (slow on large tables)
SELECT *
FROM orders o
WHERE EXISTS (
    SELECT 1
    FROM customers c
    WHERE c.customer_id = o.customer_id
      AND c.status = 'ACTIVE'
);

-- GOOD: Join lets DB optimize filtering in bulk
SELECT o.*
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE c.status = 'ACTIVE';


--  Prefer JOIN over correlated subquery for filtering — better performance on large datasets


-- -----------------------------------------
-- 2. IN / NOT IN vs LEFT JOIN / IS NULL
-- -----------------------------------------

-- Subqueries can sometimes be **faster** when:
-- - Result set is small
-- - Indexed column used in IN clause

-- Example: Find orders from inactive customers

-- GOOD: Subquery (efficient when inner query is small & indexed)
SELECT *
FROM orders
WHERE customer_id IN (
    SELECT customer_id FROM customers WHERE status = 'INACTIVE'
);

-- Alternative using JOIN:
SELECT o.*
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.status = 'INACTIVE';

-- Both are similar here, but subquery avoids join memory overhead


-- -----------------------------------------
-- 3. Aggregation Subquery vs JOIN + GROUP BY
-- -----------------------------------------

-- Subquery can be cleaner and sometimes faster when doing aggregates

-- Using subquery:
SELECT customer_id,
       (SELECT COUNT(*) FROM orders o WHERE o.customer_id = c.customer_id) AS order_count
FROM customers c;

-- Same with JOIN + GROUP BY:
SELECT c.customer_id, COUNT(o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

--  Use GROUP BY for large datasets — DB can better optimize with hash/group aggregates
--  Use scalar subqueries when result is needed per row and join overhead is high


-- -----------------------------------------
-- 4. EXISTS vs IN: Which is faster?
-- -----------------------------------------

-- EXISTS: Stops at first match → faster when subquery returns many rows
-- IN: Materializes full list → good if subquery returns small list

-- Example:
-- Check if customers placed any orders

-- EXISTS → Better for large orders table
SELECT *
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id
);

-- IN → Better for small orders table
SELECT *
FROM customers
WHERE customer_id IN (
    SELECT customer_id FROM orders
);


-- -----------------------------------------
-- 5. When Subqueries Are Better
-- -----------------------------------------

--  Filtering with small static sets (e.g., IN on 10 items)
--  Simplifying logic when outer query doesn't need join columns
--  Avoiding memory overhead of JOINs in large results

--  Avoid correlated subqueries inside SELECT or WHERE for large tables → run per row


-- -----------------------------------------
-- Summary
-- -----------------------------------------

/*
 JOIN
- Use when you need columns from both tables
- Generally faster for filtering large datasets
- Preferred for complex filtering and grouping

 SUBQUERY
- Better when subquery returns small result
- Cleaner when you don’t need extra columns
- EXISTS > IN when inner table is large
- Avoid correlated subqueries for big tables
*/


/*
 Practice Tasks:
1. Convert a correlated subquery to a JOIN and compare EXPLAIN plans.
2. Try rewriting a subquery using EXISTS and observe execution time difference.
3. Compare GROUP BY vs scalar subquery for aggregate calculations.
*/
