#!/usr/bin/env python3
"""
Export key analysis queries to CSV files in ./data using pandas + SQLAlchemy.

Usage:
  python scripts/export_all.py                # export all queries
  python scripts/export_all.py --rebuild      # rebuild DB via master.sql, then export all
  python scripts/export_all.py --only pricing stock_risk  # export selected queries only
"""

import argparse
import sys
from pathlib import Path
import pandas as pd
from sqlalchemy import create_engine, text

DB_PATH = "retail.db"
MASTER_SQL = Path("master.sql")
DATA_DIR = Path("data")

# Map nice names -> SQL files (keep in sync with your /sql folder)
QUERIES = {
    "pricing":      Path("sql/10_pricing.sql"),
    "margin":       Path("sql/20_margin.sql"),
    "stock_risk":   Path("sql/30_stock_risk.sql"),
    "rfm":          Path("sql/40_rfm.sql"),
    "cohort":       Path("sql/50_cohort.sql"),
}

def rebuild_database():
    """
    Executes master.sql (schema, seed, and all queries).
    Uses sqlite3 via SQLAlchemy's raw connection.
    """
    if not MASTER_SQL.exists():
        print(f"[ERROR] {MASTER_SQL} not found. Are you in the repo root?")
        sys.exit(1)
    sql_text = MASTER_SQL.read_text(encoding="utf-8")
    # Use stdlib sqlite3 execute script through pandas/engine connection
    import sqlite3
    with sqlite3.connect(DB_PATH) as conn:
        conn.executescript(sql_text)
    print("[OK] Database rebuilt from master.sql")

def export_query(engine, key: str, sql_file: Path):
    if not sql_file.exists():
        print(f"[WARN] Skipping '{key}': {sql_file} not found")
        return
    sql = sql_file.read_text(encoding="utf-8")
    with engine.connect() as conn:
        df = pd.read_sql(text(sql), conn)
    out_path = DATA_DIR / f"{key}.csv"
    df.to_csv(out_path, index=False)
    print(f"[OK] Exported {key:<10} → {out_path} ({len(df):,} rows)")

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--rebuild", action="store_true", help="Run master.sql before exporting")
    parser.add_argument("--only", nargs="+", choices=QUERIES.keys(), help="Export only these keys")
    args = parser.parse_args()

    # Ensure data dir exists
    DATA_DIR.mkdir(parents=True, exist_ok=True)

    if args.rebuild:
        rebuild_database()

    # Create engine and export
    engine = create_engine(f"sqlite:///{DB_PATH}")

    keys = args.only if args.only else QUERIES.keys()
    for k in keys:
        export_query(engine, k, QUERIES[k])

    print("[DONE] Exports complete.")

if __name__ == "__main__":
    main()
