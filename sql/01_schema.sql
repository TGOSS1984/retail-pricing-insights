-- Drop order helps re-runs
DROP TABLE IF EXISTS inventory_snapshots;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS stores;
DROP TABLE IF EXISTS products;

CREATE TABLE products (
  product_id    INTEGER PRIMARY KEY,
  category      TEXT NOT NULL,
  brand         TEXT NOT NULL,
  product_name  TEXT NOT NULL,
  cost_price    NUMERIC NOT NULL CHECK (cost_price >= 0),
  list_price    NUMERIC NOT NULL CHECK (list_price >= 0)
);

CREATE TABLE stores (
  store_id   INTEGER PRIMARY KEY,
  region     TEXT NOT NULL,
  store_name TEXT NOT NULL
);

CREATE TABLE customers (
  customer_id  INTEGER PRIMARY KEY,
  signup_date  DATE NOT NULL
);

CREATE TABLE sales (
  sale_id      INTEGER PRIMARY KEY,
  sale_date    DATE NOT NULL,
  store_id     INTEGER NOT NULL REFERENCES stores(store_id),
  product_id   INTEGER NOT NULL REFERENCES products(product_id),
  customer_id  INTEGER REFERENCES customers(customer_id),
  unit_price   NUMERIC NOT NULL CHECK (unit_price >= 0),
  qty          INTEGER NOT NULL CHECK (qty > 0),
  discount_pct NUMERIC NOT NULL DEFAULT 0 CHECK (discount_pct BETWEEN 0 AND 1)
);

CREATE TABLE inventory_snapshots (
  snapshot_date DATE NOT NULL,
  store_id      INTEGER NOT NULL REFERENCES stores(store_id),
  product_id    INTEGER NOT NULL REFERENCES products(product_id),
  on_hand_qty   INTEGER NOT NULL CHECK (on_hand_qty >= 0),
  PRIMARY KEY (snapshot_date, store_id, product_id)
);

-- Helpful indexes for analytics
CREATE INDEX idx_sales_date ON sales(sale_date);
CREATE INDEX idx_sales_store ON sales(store_id);
CREATE INDEX idx_sales_product ON sales(product_id);
CREATE INDEX idx_sales_customer ON sales(customer_id);
