-- 02 Department penetration, spend share and spend per buyer (static panel, unweighted)
-- Penetration = % of static households that bought the department at least once in the year
WITH static_hh AS (
    SELECT household_key FROM households WHERE static = 1
),
dept AS (
    SELECT t.department,
           COUNT(DISTINCT t.household_key) AS buyers,
           SUM(t.sales_value)              AS sales
    FROM transactions t
    JOIN static_hh s ON s.household_key = t.household_key
    GROUP BY t.department
)
SELECT department,
       buyers,
       ROUND(100.0 * buyers / (SELECT COUNT(*) FROM static_hh), 1) AS penetration_pct,
       ROUND(sales, 0)                                              AS sales,
       ROUND(100.0 * sales / SUM(sales) OVER (), 2)                 AS share_of_sales_pct,
       ROUND(sales / buyers, 1)                                     AS spend_per_buyer
FROM dept
ORDER BY sales DESC
LIMIT 15;
