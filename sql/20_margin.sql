-- 3) Simple “price elasticity proxy” for product_id=1
WITH by_day AS (
  SELECT sale_date, AVG(unit_price) AS avg_price, SUM(qty) AS total_qty
  FROM sales
  WHERE product_id = 1
  GROUP BY sale_date
)
SELECT
  COUNT(*) AS days,
  AVG(avg_price) AS avg_price,
  AVG(total_qty) AS avg_qty
FROM by_day;
