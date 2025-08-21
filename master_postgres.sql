-- master_postgres.sql (Postgres)
-- Rebuild and run all queries. Assumes the target database already exists.

-- 1) Core schema + seed
\i sql/01_schema.sql
\i sql/02_seed.sql

-- 2) Analysis queries (comment out to skip)
\i sql/10_pricing.sql
\i sql/20_margin.sql
\i sql/30_stock_risk.sql
\i sql/40_rfm.sql
\i sql/50_cohort.sql
