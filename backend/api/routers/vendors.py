from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import Optional
from backend.api.database import get_supabase
from backend.agents.demand_forecast import forecast_demand

router = APIRouter(prefix="/vendors", tags=["Vendors"])

class ShopCreate(BaseModel):
    profile_id: str
    name: str
    lat: float
    lng: float

@router.post("/shop")
def create_shop(shop: ShopCreate):
    supabase = get_supabase()
    # PostGIS point format: POINT(lng lat)
    location_wkt = f"POINT({shop.lng} {shop.lat})"
    
    res = supabase.table("shops").insert({
        "profile_id": shop.profile_id,
        "name": shop.name,
        "location": location_wkt
    }).execute()
    
    if not res.data:
        raise HTTPException(status_code=400, detail="Failed to create shop")
    return res.data[0]

@router.get("/{shop_id}/forecast")
def get_shop_forecast(shop_id: str):
    # Call demand forecast agent stub
    forecast = forecast_demand(shop_id=shop_id)
    return {"shop_id": shop_id, "forecast": forecast}
