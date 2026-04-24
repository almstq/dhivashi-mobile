from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import List, Optional
from backend.api.database import get_supabase
from backend.agents.order_routing import route_order

router = APIRouter(prefix="/orders", tags=["Orders"])

class OrderCreate(BaseModel):
    profile_id: str
    shop_id: str
    total: float
    items: List[dict]

@router.post("/")
def create_order(order: OrderCreate):
    supabase = get_supabase()
    # Create order
    res = supabase.table("orders").insert({
        "profile_id": order.profile_id,
        "shop_id": order.shop_id,
        "total": order.total,
        "status": "pending"
    }).execute()
    
    if not res.data:
        raise HTTPException(status_code=400, detail="Failed to create order")
        
    created_order = res.data[0]
    
    # Call order routing agent stub
    # In a real scenario, we'd fetch locations from DB first.
    route_decision = route_order(
        order_id=created_order['id'],
        shop_location={"lat": 4.1755, "lng": 73.5093}, # Male' default
        dropoff_location={"lat": 4.1760, "lng": 73.5100}
    )
    
    return {"order": created_order, "routing": route_decision}

@router.get("/{profile_id}")
def get_user_orders(profile_id: str):
    supabase = get_supabase()
    res = supabase.table("orders").select("*").eq("profile_id", profile_id).execute()
    return {"orders": res.data}
