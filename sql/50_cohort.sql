WITH orders AS (
  SELECT
    c.customer_id,
    date(strftime('%Y-%m-01', c.signup_date)) AS cohort_month,
    date(strftime('%Y-%m-01', s.sale_date))   AS order_month
  FROM customers c
  JOIN sales s ON s.customer_id = c.customer_id
),
flags AS (
  SELECT cohort_month, order_month, customer_id
  FROM orders
  GROUP BY cohort_month, order_month, customer_id
)
SELECT
  cohort_month,
  order_month,
  COUNT(DISTINCT customer_id) AS active_customers
FROM flags
GROUP BY cohort_month, order_month
ORDER BY cohort_month, order_month;
