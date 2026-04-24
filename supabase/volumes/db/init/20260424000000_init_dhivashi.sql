-- Dhivashi Agentic Schema - Initial Migration
-- Includes Dhivehi labels, PostGIS, pgvector, and Revenue-first fields

CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS vector;

-- Profiles: Aharenge Profiles (User Profiles)
CREATE TABLE profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    phone TEXT UNIQUE,
    role TEXT CHECK (role IN ('customer', 'vendor', 'rider', 'admin')) DEFAULT 'customer',
    created_at TIMESTAMPTZ DEFAULT NOW()
);
COMMENT ON TABLE profiles IS 'Aharenge Profiles (User Profiles)';
COMMENT ON COLUMN profiles.phone IS 'Phone number, defaults to +960 for Maldives';

-- Shops: Fihhaara (Vendor Shops)
CREATE TABLE shops (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    location GEOMETRY(POINT),
    inventory JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW()
);
COMMENT ON TABLE shops IS 'Fihhaara (Vendor Shops)';

-- Products: Mudhaa (Shop Products)
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    shop_id UUID REFERENCES shops(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    price NUMERIC NOT NULL,
    embeddings VECTOR(1536),
    created_at TIMESTAMPTZ DEFAULT NOW()
);
COMMENT ON TABLE products IS 'Mudhaa (Shop Products)';

-- Orders: Orderthah (Customer Orders)
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    shop_id UUID REFERENCES shops(id),
    status TEXT DEFAULT 'pending',
    total NUMERIC NOT NULL,
    rider_commission NUMERIC GENERATED ALWAYS AS (total * 0.80) STORED, -- 80% to riders
    platform_commission NUMERIC GENERATED ALWAYS AS (total * 0.20) STORED, -- 20% to platform/vendor
    tracking JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW()
);
COMMENT ON TABLE orders IS 'Orderthah (Customer Orders) - Revenue first';

-- Delivery Requests: Delivery (Rider Requests)
CREATE TABLE delivery_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    rider_id UUID REFERENCES profiles(id),
    route GEOMETRY(LINESTRING),
    status TEXT DEFAULT 'searching',
    created_at TIMESTAMPTZ DEFAULT NOW()
);
COMMENT ON TABLE delivery_requests IS 'Delivery (Rider Requests)';

-- Earnings: Aamdhandi (Ledger for gigs/commissions)
CREATE TABLE earnings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    profile_id UUID REFERENCES profiles(id),
    amount NUMERIC NOT NULL,
    type TEXT CHECK (type IN ('gig', 'commission', 'payout')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);
COMMENT ON TABLE earnings IS 'Aamdhandi (Ledger for gigs/commissions)';

-- Agent Workflows: AI Agent execution logs
CREATE TABLE agent_workflows (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    input JSONB,
    output JSONB,
    confidence NUMERIC,
    audit_log JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW()
);
COMMENT ON TABLE agent_workflows IS 'AI Agent execution logs';

-- Audit Logs Table
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    table_name TEXT NOT NULL,
    record_id UUID NOT NULL,
    action TEXT NOT NULL,
    old_data JSONB,
    new_data JSONB,
    changed_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==========================================
-- Security & Indexes
-- ==========================================

-- Enable Row Level Security (RLS)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE shops ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE delivery_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE earnings ENABLE ROW LEVEL SECURITY;
ALTER TABLE agent_workflows ENABLE ROW LEVEL SECURITY;

-- Policies for profiles
CREATE POLICY "Users can view their own profile" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update their own profile" ON profiles FOR UPDATE USING (auth.uid() = id);
-- Admins can do all (stub)
CREATE POLICY "Admins bypass RLS on profiles" ON profiles USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));

-- Policies for orders
CREATE POLICY "Customers can view own orders" ON orders FOR SELECT USING (auth.uid() = profile_id);
CREATE POLICY "Customers can create orders" ON orders FOR INSERT WITH CHECK (auth.uid() = profile_id);

-- Indexes
CREATE INDEX shops_location_idx ON shops USING GIST(location);
CREATE INDEX products_embeddings_idx ON products USING ivfflat(embeddings vector_cosine_ops);
CREATE INDEX orders_profile_id_idx ON orders(profile_id);

-- ==========================================
-- Triggers and Functions
-- ==========================================

-- Auth trigger to automatically create a profile with +960 stub
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, phone, role)
  VALUES (
      new.id, 
      COALESCE(new.phone, '+960' || FLOOR(RANDOM() * 9000000 + 7000000)::TEXT), -- Stub +960 number if not provided
      'customer'
  );
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- Audit trigger function
CREATE OR REPLACE FUNCTION public.audit_record_changes()
RETURNS trigger AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO public.audit_logs (table_name, record_id, action, new_data)
    VALUES (TG_TABLE_NAME, NEW.id, TG_OP, to_jsonb(NEW));
    RETURN NEW;
  ELSIF TG_OP = 'UPDATE' THEN
    INSERT INTO public.audit_logs (table_name, record_id, action, old_data, new_data)
    VALUES (TG_TABLE_NAME, NEW.id, TG_OP, to_jsonb(OLD), to_jsonb(NEW));
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO public.audit_logs (table_name, record_id, action, old_data)
    VALUES (TG_TABLE_NAME, OLD.id, TG_OP, to_jsonb(OLD));
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Apply audit trigger to core tables
CREATE TRIGGER audit_orders_changes AFTER INSERT OR UPDATE OR DELETE ON orders FOR EACH ROW EXECUTE PROCEDURE public.audit_record_changes();
CREATE TRIGGER audit_agent_workflows_changes AFTER INSERT OR UPDATE OR DELETE ON agent_workflows FOR EACH ROW EXECUTE PROCEDURE public.audit_record_changes();
