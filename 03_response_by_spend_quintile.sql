-- 03 Who has demographics? Response rate by spend quintile (static panel)
-- NTILE(5) splits households into 5 equal groups by annual spend (1 = lightest, 5 = heaviest)
-- If the response rate rises with spend, the demographic sample over-represents heavy shoppers
WITH ranked AS (
    SELECT household_key, has_demo, annual_spend,
           NTILE(5) OVER (ORDER BY annual_spend) AS spend_quintile
    FROM households
    WHERE static = 1
)
SELECT spend_quintile,
       COUNT(*)                                   AS households,
       SUM(has_demo)                              AS with_demographics,
       ROUND(100.0 * SUM(has_demo) / COUNT(*), 1) AS response_rate_pct,
       ROUND(MIN(annual_spend), 0)                AS min_spend,
       ROUND(MAX(annual_spend), 0)                AS max_spend,
       ROUND(AVG(annual_spend), 0)                AS avg_spend
FROM ranked
GROUP BY spend_quintile
ORDER BY spend_quintile;
