-- Minimal initial schema; extend per detailed spec.
CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE IF NOT EXISTS trend_data(
  doc_id TEXT PRIMARY KEY,
  source TEXT,
  retrieved_at TIMESTAMPTZ DEFAULT now(),
  lang TEXT,
  sentiment REAL,
  topics JSONB,
  vector vector(1536)
);

CREATE TABLE IF NOT EXISTS genre_insights(
  genre TEXT,
  window DATE DEFAULT CURRENT_DATE,
  top_keywords TEXT[],
  avg_sentiment REAL,
  trend_score REAL
);

CREATE TABLE IF NOT EXISTS moon_pools(
  id INT PRIMARY KEY,
  title TEXT,
  genre TEXT,
  core_fantasy TEXT,
  ai_hook TEXT,
  target_kpi JSONB,
  region_tag TEXT,
  ethics_cost SMALLINT,
  examples TEXT[]
);
