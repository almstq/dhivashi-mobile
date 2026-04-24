CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  phone TEXT UNIQUE NOT NULL,
  role TEXT CHECK (role IN ('customer','vendor','rider','admin')) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE shops (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id UUID REFERENCES profiles(id),
  name TEXT,
  location GEOMETRY(POINT),
  inventory JSONB
);

CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shop_id UUID REFERENCES shops(id),
  name TEXT,
  price NUMERIC,
  embeddings VECTOR(1536)
);

CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id UUID REFERENCES profiles(id),
  shop_id UUID REFERENCES shops(id),
  status TEXT DEFAULT 'pending',
  total NUMERIC,
  rider_commission NUMERIC GENERATED ALWAYS AS (total * 0.8) STORED,
  platform_commission NUMERIC GENERATED ALWAYS AS (total * 0.2) STORED,
  tracking JSONB
);

CREATE TABLE delivery_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID REFERENCES orders(id),
  rider_id UUID REFERENCES profiles(id),
  route GEOMETRY(LINESTRING)
);

CREATE TABLE earnings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id UUID REFERENCES profiles(id),
  amount NUMERIC,
  type TEXT
);

ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
CREATE INDEX idx_shops_location ON shops USING GIST(location);
