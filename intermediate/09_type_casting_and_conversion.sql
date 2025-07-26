-- 09_type_casting_and_conversion.sql
-- Goal: Understand explicit type casting (CAST, CONVERT) and implicit type coercion in SQL.

-- 1. Explicit Casting with CAST
SELECT 
  CAST('123' AS INTEGER) AS int_val,          -- 123
  CAST(123.456 AS VARCHAR(10)) AS str_val,    -- '123.456'
  CAST(12.75 AS INT) AS truncated_int,        -- 12
  CAST('2024-07-25' AS DATE) AS converted_date;

-- 2. Using CONVERT (Only in MySQL / SQL Server)
-- SQL Server: SELECT CONVERT(INT, '123');
-- MySQL:      SELECT CONVERT('123', SIGNED INTEGER);
-- Note: Use CAST for cross-database compatibility.

-- 3. Implicit Type Conversion
-- SQL will often try to convert types automatically when needed.
SELECT '10' + 5 AS result;         -- Output: 15 (string '10' is converted to int)

-- But implicit conversion can fail:
SELECT 'abc' + 1;                  -- MySQL: NULL | PostgreSQL: ERROR

-- 4. Comparisons Between Different Types
SELECT 
  CASE 
    WHEN '100' = 100 THEN 'Equal'             -- MySQL: 'Equal' | PostgreSQL: 'Not Equal'
    ELSE 'Not Equal'
  END AS implicit_comparison;

-- It's safer to cast explicitly:
SELECT 
  CASE 
    WHEN CAST('100' AS INT) = 100 THEN 'Equal'
    ELSE 'Not Equal'
  END AS explicit_comparison;

-- 5. Casting Timestamps
-- NOW() returns a full timestamp; casting to DATE removes the time part.
SELECT 
  NOW() AS full_timestamp,               -- e.g., 2025-07-25 13:45:00
  CAST(NOW() AS DATE) AS date_only;      -- e.g., 2025-07-25

-- 6. Date & Time Conversions
SELECT 
  CAST('2025-01-01' AS DATE) AS cast_date,                -- 2025-01-01
  CAST('13:45:00' AS TIME) AS cast_time,                  -- 13:45:00
  CAST('2025-01-01 10:30:00' AS TIMESTAMP) AS cast_ts,    -- 2025-01-01 10:30:00
  CAST(NOW() AS DATE) AS current_date;

-- 7. Invalid Format Casting
-- PostgreSQL: Raises ERROR | MySQL: Returns NULL
-- SELECT CAST('abc' AS DATE);

-- 8. Implicit Comparison Coercion (Varies by SQL dialect)
SELECT 
  '100' = 100 AS coerced_result;         -- MySQL: true | PostgreSQL: false

-- 9. Float to Integer Casting
SELECT 
  CAST(123.987 AS INTEGER) AS truncated; -- 123

-- 10. Rounding and Decimal Precision
SELECT
  CAST(123.4567 AS DECIMAL(5,2)) AS cast_decimal,  -- 123.46
  ROUND(123.4567, 1) AS round_1dp,                 -- 123.5
  ROUND(123.4567, 0) AS round_0dp;                 -- 123

-- 11. Boolean Casting
-- PostgreSQL: TRUE::INT → 1
-- MySQL: TRUE → 1, FALSE → 0

-- 12. Invalid Casts
-- PostgreSQL: ERROR | MySQL: Returns 0
-- SELECT CAST('abc' AS INTEGER);

-- 13. Real-World Example: Avoiding Implicit Casting
-- Table: users(id INT, name VARCHAR, age INT)

-- When user input is a string, use CAST to match column type:
SELECT * FROM users WHERE age = CAST('25' AS INT);
-- Helps avoid implicit conversion and improves index usage.

-- 14. NULL Handling in Casting
SELECT 
  CAST(NULL AS VARCHAR) AS null_casted,         -- NULL
  CAST('NULL' AS INT) AS casted_string_null;    -- 0 (MySQL) | ERROR (PostgreSQL)
