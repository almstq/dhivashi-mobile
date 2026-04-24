from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from backend.api.database import get_supabase

router = APIRouter(prefix="/delivery", tags=["Delivery"])

class DeliveryAccept(BaseModel):
    rider_id: str
    delivery_request_id: str

@router.get("/available")
def get_available_deliveries():
    supabase = get_supabase()
    res = supabase.table("delivery_requests").select("*").eq("status", "searching").execute()
    return {"available": res.data}

@router.post("/accept")
def accept_delivery(payload: DeliveryAccept):
    supabase = get_supabase()
    
    # Check if still available
    check = supabase.table("delivery_requests").select("status").eq("id", payload.delivery_request_id).execute()
    if not check.data or check.data[0]['status'] != 'searching':
        raise HTTPException(status_code=400, detail="Delivery no longer available")
        
    res = supabase.table("delivery_requests").update({
        "rider_id": payload.rider_id,
        "status": "accepted"
    }).eq("id", payload.delivery_request_id).execute()
    
    if not res.data:
        raise HTTPException(status_code=400, detail="Failed to accept delivery")
        
    return {"message": "Delivery accepted", "delivery": res.data[0]}
