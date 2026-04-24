from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
app = FastAPI(title="Dhivashi API v0.1 - Male MVP")

app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])

@app.get("/")
async def root():
    return {"message": "Dhivashi LIVE", "phase": "0", "city": "Male", "rider_commission": "80%"}

@app.post("/orders")
async def create_order(data: dict):
    total = data.get("total", 0)
    return {
        "order_id": "dhv-123", 
        "rider_commission": total * 0.8,
        "platform_commission": total * 0.2,
        "status": "assigned"
    }

@app.get("/vendors")
async def get_vendors():
    return [{"id": "male-fmcg-1", "name": "Male Rice Shop", "phone": "+9609876543"}]

print("Dhivashi API starting...")