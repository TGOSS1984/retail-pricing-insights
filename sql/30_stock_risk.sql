WITH last14 AS (
  SELECT
    product_id,
    store_id,
    SUM(qty) * 1.0 / 14.0 AS avg_daily_units
  FROM sales
  WHERE sale_date >= date((SELECT MAX(sale_date) FROM sales), '-13 days')
  GROUP BY product_id, store_id
),
latest_stock AS (
  SELECT i.*
  FROM inventory_snapshots i
  JOIN (
    SELECT store_id, product_id, MAX(snapshot_date) AS max_snap
    FROM inventory_snapshots
    GROUP BY store_id, product_id
  ) m ON m.store_id=i.store_id AND m.product_id=i.product_id AND m.max_snap=i.snapshot_date
)
SELECT
  st.region,
  p.product_name,
  ls.store_id,
  ls.on_hand_qty,
  ROUND(l14.avg_daily_units,2) AS avg_daily_units,
  CASE
    WHEN l14.avg_daily_units = 0 THEN NULL
    ELSE ROUND(ls.on_hand_qty / l14.avg_daily_units,1)
  END AS days_of_cover,
  CASE
    WHEN l14.avg_daily_units = 0 THEN 'No recent sales'
    WHEN ls.on_hand_qty / l14.avg_daily_units < 14 THEN '⚠️ At risk (<14 days)'
    ELSE 'OK'
  END AS risk_status
FROM latest_stock ls
JOIN stores st ON st.store_id = ls.store_id
JOIN products p ON p.product_id = ls.product_id
LEFT JOIN last14 l14 ON l14.product_id=ls.product_id AND l14.store_id=ls.store_id
ORDER BY risk_status DESC, days_of_cover NULLS LAST;
