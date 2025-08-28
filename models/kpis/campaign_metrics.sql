WITH metrics AS (
    SELECT
        SUM(spend) AS total_spend,
        SUM(conversions) AS total_conversions,
        SUM(conversions) * 100 AS revenue
    FROM `demorag-462121.DevTestAIDataEngineerRole.ads_spend`
    WHERE date >= '{{ var("start_date") }}'
      AND date <= '{{ var("end_date") }}'
)
SELECT
    total_spend,
    total_conversions,
    total_spend / NULLIF(total_conversions, 0) AS cac,
    revenue / NULLIF(total_spend, 0) AS roas
FROM metrics
