-- 01 Panel KPIs per 4-week period (weeks 51-102 = periods 1-13)
-- Question: is the panel stable over the analysis year?
SELECT
    t.period,
    COUNT(DISTINCT t.household_key)                         AS active_households,
    COUNT(DISTINCT CASE WHEN h.static = 1 THEN t.household_key END) AS active_static_households,
    COUNT(DISTINCT t.basket_id)                             AS baskets,
    ROUND(SUM(t.sales_value), 0)                            AS sales,
    ROUND(SUM(t.sales_value) / COUNT(DISTINCT t.household_key), 1) AS sales_per_household,
    ROUND(1.0 * COUNT(DISTINCT t.basket_id) / COUNT(DISTINCT t.household_key), 1) AS baskets_per_household
FROM transactions t
JOIN households h ON h.household_key = t.household_key
GROUP BY t.period
ORDER BY t.period;
