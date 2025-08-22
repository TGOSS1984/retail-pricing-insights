-- export_all.sql
-- Exports all key analysis queries as CSVs into the data/ folder

.mode csv
.headers on

-- 1) Pricing & margin by week/region
.output data/pricing.csv
.read sql/10_pricing.sql

-- 2) Margin / elasticity proxy
.output data/margin.csv
.read sql/20_margin.sql

-- 3) Stock risk
.output data/stock_risk.csv
.read sql/30_stock_risk.sql

-- 4) RFM segmentation
.output data/rfm.csv
.read sql/40_rfm.sql

-- 5) Cohort retention
.output data/cohort.csv
.read sql/50_cohort.sql

-- Reset output to console
.output stdout
