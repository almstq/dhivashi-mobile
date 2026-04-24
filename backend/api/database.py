import os
from supabase import create_client, Client
from dotenv import load_dotenv

load_dotenv()

# We connect to Supabase local or cloud depending on ENV vars.
SUPABASE_URL = os.environ.get("SUPABASE_URL", "http://127.0.0.1:54321")
SUPABASE_KEY = os.environ.get("SUPABASE_KEY", "your-anon-or-service-role-key")

def get_supabase() -> Client:
    return create_client(SUPABASE_URL, SUPABASE_KEY)
