{% macro kpi_table(source_model, date_col='omni_date', conv_value=100) %}
WITH
  base AS (
    SELECT
      {{ date_col }} AS date,
      spend,
      conversions,
      (conversions * {{ conv_value }}) AS revenue
    FROM {{ source_model }}
  ),
  max_date AS (
    SELECT
      MAX(date) AS max_date_value
    FROM base
  ),
  last_30 AS (
    SELECT
      SUM(spend) AS spend,
      SUM(conversions) AS conversions,
      SUM(revenue) AS revenue
    FROM base
    WHERE
      date BETWEEN DATE_SUB((SELECT max_date_value FROM max_date), INTERVAL 30 DAY) AND (SELECT max_date_value FROM max_date)
  ),
  prev_30 AS (
    SELECT
      SUM(spend) AS spend,
      SUM(conversions) AS conversions,
      SUM(revenue) AS revenue
    FROM base
    WHERE
      date BETWEEN DATE_SUB((SELECT max_date_value FROM max_date), INTERVAL 60 DAY) AND DATE_SUB((SELECT max_date_value FROM max_date), INTERVAL 31 DAY)
  )
SELECT
  -- Spend
  l.spend AS last30_spend,
  p.spend AS prev30_spend,
  ROUND(100 * (l.spend - p.spend) / NULLIF(p.spend, 0), 2) AS spend_delta_pct,

  -- Conversions
  l.conversions AS last30_conversions,
  p.conversions AS prev30_conversions,
  ROUND(100 * (l.conversions - p.conversions) / NULLIF(p.conversions, 0), 2) AS conv_delta_pct,

  -- CAC
  SAFE_DIVIDE(l.spend, NULLIF(l.conversions, 0)) AS last30_cac,
  SAFE_DIVIDE(p.spend, NULLIF(p.conversions, 0)) AS prev30_cac,
  ROUND(
    100 * (
      SAFE_DIVIDE(l.spend, NULLIF(l.conversions, 0)) - SAFE_DIVIDE(p.spend, NULLIF(p.conversions, 0))
    ) / NULLIF(SAFE_DIVIDE(p.spend, NULLIF(p.conversions, 0)), 0),
    2
  ) AS cac_delta_pct,

  -- ROAS
  SAFE_DIVIDE(l.revenue, NULLIF(l.spend, 0)) AS last30_roas,
  SAFE_DIVIDE(p.revenue, NULLIF(p.spend, 0)) AS prev30_roas,
  ROUND(
    100 * (
      SAFE_DIVIDE(l.revenue, NULLIF(l.spend, 0)) - SAFE_DIVIDE(p.revenue, NULLIF(p.spend, 0))
    ) / NULLIF(SAFE_DIVIDE(p.revenue, NULLIF(p.spend, 0)), 0),
    2
  ) AS roas_delta_pct
FROM last_30 l, prev_30 p
{% endmacro %}