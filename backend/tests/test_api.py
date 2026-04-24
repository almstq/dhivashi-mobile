import pytest
from fastapi.testclient import TestClient
from backend.api.main import app

client = TestClient(app)

def test_health_check():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok", "components": ["fastapi", "langgraph_stubs"]}

def test_root():
    response = client.get("/")
    assert response.status_code == 200
    assert "Welcome to Dhivashi API" in response.json()["message"]

# Note: Integration tests requiring Supabase connection are mocked or skipped in CI
# unless a local supabase instance is running.
@pytest.mark.skip(reason="Requires active Supabase connection")
def test_create_vendor_endpoint():
    payload = {
        "profile_id": "test-uuid-123",
        "name": "Test Fihhaara",
        "lat": 4.1755,
        "lng": 73.5093
    }
    response = client.post("/vendors/shop", json=payload)
    assert response.status_code == 200
