-- 04 Demographic profile of the weighting sample (static households with demographics)
-- Window function SUM() OVER (PARTITION BY variable) gives the % within each variable
WITH profile AS (
    SELECT 'age' AS variable, age AS category, COUNT(*) AS n
    FROM households WHERE static = 1 AND has_demo = 1 GROUP BY age
    UNION ALL
    SELECT 'income', income, COUNT(*)
    FROM households WHERE static = 1 AND has_demo = 1 GROUP BY income
    UNION ALL
    SELECT 'hh_size', hh_size, COUNT(*)
    FROM households WHERE static = 1 AND has_demo = 1 GROUP BY hh_size
)
SELECT variable,
       category,
       n,
       ROUND(100.0 * n / SUM(n) OVER (PARTITION BY variable), 1) AS pct
FROM profile
ORDER BY variable, category;
