INSERT INTO products (product_id, category, brand, product_name, cost_price, list_price) VALUES
  (1,'Jackets','Regatta','StormGuard Jacket',35,80),
  (2,'Jackets','Regatta','TrailShell Jacket',28,65),
  (3,'Fleece','Craghoppers','ThermoFleece 200',12,35),
  (4,'Footwear','Regatta','HikePro Boot',30,75);

INSERT INTO stores (store_id, region, store_name) VALUES
  (10,'North','Manchester City'),
  (11,'North','Leeds Trinity'),
  (20,'South','London West'),
  (21,'South','Bristol Cabot');

INSERT INTO customers (customer_id, signup_date) VALUES
  (1001,'2025-06-01'), (1002,'2025-06-10'), (1003,'2025-07-05');

INSERT INTO sales (sale_id, sale_date, store_id, product_id, customer_id, unit_price, qty, discount_pct) VALUES
  (1,'2025-07-01',10,1,1001,72,1,0.10),
  (2,'2025-07-02',10,3,1002,35,2,0.00),
  (3,'2025-07-08',11,1,1001,68,1,0.15),
  (4,'2025-07-09',11,2,NULL,60,1,0.08),
  (5,'2025-07-15',20,4,1003,75,1,0.00),
  (6,'2025-07-16',21,3,NULL,33,3,0.05),
  (7,'2025-07-22',20,1,1002,70,1,0.12),
  (8,'2025-07-23',10,2,1001,58,1,0.11),
  (9,'2025-07-29',21,4,NULL,70,1,0.07),
  (10,'2025-08-05',10,1,1003,64,1,0.20);

INSERT INTO inventory_snapshots (snapshot_date, store_id, product_id, on_hand_qty) VALUES
  ('2025-07-01',10,1,20), ('2025-07-08',10,1,18), ('2025-07-15',10,1,17), ('2025-07-22',10,1,15), ('2025-07-29',10,1,12),
  ('2025-07-01',20,1,12), ('2025-07-08',20,1,11), ('2025-07-15',20,1,10), ('2025-07-22',20,1, 9), ('2025-07-29',20,1, 8);
