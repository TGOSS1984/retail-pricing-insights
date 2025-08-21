-- master.sql (SQLite)
-- Rebuilds the database from scratch and runs all analysis scripts.

-- Safety: turn on FKs
PRAGMA foreign_keys = ON;

-- 1) Core schema + seed
.read sql/01_schema.sql
.read sql/02_seed.sql

-- 2) Analysis queries (these just run; comment out any you don’t want)
.read sql/10_pricing.sql
.read sql/20_margin.sql
.read sql/30_stock_risk.sql
.read sql/40_rfm.sql
.read sql/50_cohort.sql
