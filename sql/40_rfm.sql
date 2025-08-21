WITH cust_orders AS (
  SELECT
    c.customer_id,
    MAX(s.sale_date)                           AS last_order_date,
    COUNT(*)                                   AS frequency,
    SUM(s.unit_price * s.qty)                  AS monetary
  FROM customers c
  JOIN sales s ON s.customer_id = c.customer_id
  GROUP BY c.customer_id
),
recency AS (
  SELECT
    customer_id,
    CAST (julianday((SELECT MAX(sale_date) FROM sales)) - julianday(last_order_date) AS INTEGER) AS recency_days,
    frequency,
    monetary
  FROM cust_orders
),
scored AS (
  SELECT
    customer_id,
    recency_days,
    frequency,
    monetary,
    CASE
      WHEN recency_days <= 7 THEN 5
      WHEN recency_days <= 14 THEN 4
      WHEN recency_days <= 30 THEN 3
      WHEN recency_days <= 60 THEN 2
      ELSE 1
    END AS R,
    CASE
      WHEN frequency >= 5 THEN 5
      WHEN frequency >= 3 THEN 4
      WHEN frequency >= 2 THEN 3
      WHEN frequency >= 1 THEN 2
      ELSE 1
    END AS F,
    CASE
      WHEN monetary >= 300 THEN 5
      WHEN monetary >= 150 THEN 4
      WHEN monetary >= 75 THEN 3
      WHEN monetary >= 25 THEN 2
      ELSE 1
    END AS M
  FROM recency
)
SELECT
  customer_id,
  recency_days, frequency, monetary,
  R||F||M AS rfm_score,
  CASE
    WHEN R>=4 AND F>=4 AND M>=4 THEN 'Champion'
    WHEN R>=4 AND F>=3 THEN 'Loyal'
    WHEN R<=2 AND F<=2 THEN 'At Risk'
    ELSE 'Potential'
  END AS segment
FROM scored
ORDER BY monetary DESC;
