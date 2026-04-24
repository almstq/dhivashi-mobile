-- Dhivashi Agentic Schema
CREATE EXTENSION postgis; CREATE EXTENSION vector;

CREATE TABLE profiles (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), phone TEXT UNIQUE, role TEXT CHECK (role IN ('customer','vendor','rider','admin')), created_at TIMESTAMPTZ DEFAULT NOW());
CREATE TABLE shops (id UUID PRIMARY KEY, profile_id UUID REFERENCES profiles, name TEXT, location GEOMETRY(POINT), inventory JSONB);
CREATE TABLE products (id UUID PRIMARY KEY, shop_id UUID REFERENCES shops, name TEXT, price NUMERIC, embeddings VECTOR(1536));
CREATE TABLE orders (id UUID PRIMARY KEY, profile_id UUID REFERENCES profiles, shop_id UUID, status TEXT DEFAULT 'pending', total NUMERIC, tracking JSONB);
CREATE TABLE delivery_requests (id UUID PRIMARY KEY, order_id UUID REFERENCES orders, rider_id UUID REFERENCES profiles, route GEOMETRY(LINESTRING));
CREATE TABLE earnings (id UUID PRIMARY KEY, profile_id UUID REFERENCES profiles, amount NUMERIC, type TEXT);  -- gigs/commissions
CREATE TABLE agent_workflows (id UUID PRIMARY KEY, name TEXT, input JSONB, output JSONB, confidence NUMERIC, audit_log JSONB);

-- Security/Indexes
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
CREATE POLICY user_orders ON orders USING (profile_id = current_setting('app.current_user_id')::UUID);
CREATE INDEX shops_location ON shops USING GIST(location);
CREATE INDEX products_embeddings ON products USING ivfflat(embeddings vector_cosine_ops);