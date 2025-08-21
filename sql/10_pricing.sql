-- 1) Revenue & margin by week and region (with moving average)
WITH line_value AS (
  SELECT
    s.sale_date,
    st.region,
    p.category,
    (s.unit_price * s.qty)               AS revenue,
    ((s.unit_price - p.cost_price)*s.qty) AS margin
  FROM sales s
  JOIN stores st ON st.store_id = s.store_id
  JOIN products p ON p.product_id = s.product_id
),
wk AS (
  SELECT
    strftime('%Y-%W', sale_date) AS year_week,
    region,
    category,
    SUM(revenue) AS revenue,
    SUM(margin)  AS margin
  FROM line_value
  GROUP BY 1,2,3
)
SELECT
  year_week,
  region,
  category,
  revenue,
  margin,
  ROUND(AVG(revenue) OVER (PARTITION BY region, category ORDER BY year_week ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS revenue_ma_3wk
FROM wk
ORDER BY year_week, region, category;

-- 2) Price outlier detection vs. category average
WITH price_stats AS (
  SELECT
    p.category,
    p.product_name,
    AVG(s.unit_price) AS avg_paid_price
  FROM sales s
  JOIN products p ON p.product_id = s.product_id
  GROUP BY 1,2
),
cat_stats AS (
  SELECT
    category,
    AVG(avg_paid_price) AS cat_avg
  FROM price_stats
  GROUP BY 1
)
SELECT
  ps.category,
  ps.product_name,
  ROUND(ps.avg_paid_price,2) AS avg_paid,
  ROUND(cs.cat_avg,2)        AS cat_avg,
  ROUND((ps.avg_paid_price - cs.cat_avg)/cs.cat_avg*100,2) AS pct_diff_from_cat
FROM price_stats ps
JOIN cat_stats cs USING (category)
WHERE ABS(ps.avg_paid_price - cs.cat_avg)/cs.cat_avg > 0.15
ORDER BY ABS((ps.avg_paid_price - cs.cat_avg)/cs.cat_avg) DESC;
