-- sql/olap_task3.sql
-- Section 1 Task 3: OLAP queries against the retail data warehouse (SalesFact + dims)

PRAGMA foreign_keys = ON;

-- 1) ROLL-UP
-- Total sales by country and quarter (roll-up)
SELECT
  c.country                       AS country,
  t.year                          AS year,
  t.quarter                       AS quarter,
  SUM(s.total_sales)              AS total_sales,
  COUNT(DISTINCT s.invoice_no)    AS num_invoices
FROM SalesFact s
JOIN CustomerDim c ON s.customer_id = c.customer_id
JOIN TimeDim t     ON s.time_id = t.time_id
GROUP BY c.country, t.year, t.quarter
ORDER BY t.year, t.quarter, total_sales DESC;

-- 2) DRILL-DOWN
-- Sales details for a specific country by month. Replace 'United Kingdom' with your country of interest.
SELECT
  t.year,
  t.month,
  SUM(s.total_sales) AS total_sales,
  COUNT(DISTINCT s.invoice_no) AS num_invoices,
  COUNT(*) AS rows
FROM SalesFact s
JOIN CustomerDim c ON s.customer_id = c.customer_id
JOIN TimeDim t     ON s.time_id = t.time_id
WHERE c.country = 'United Kingdom'
GROUP BY t.year, t.month
ORDER BY t.year, t.month;

-- 3) SLICE
-- Total sales for the 'Electronics' product category (slice on ProductDim.category)
SELECT
  p.category,
  SUM(s.total_sales) AS total_sales,
  COUNT(DISTINCT s.invoice_no) AS num_invoices
FROM SalesFact s
JOIN ProductDim p ON s.product_id = p.product_id
WHERE p.category = 'Electronics'
GROUP BY p.category;