from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from backend.api.routers import orders, vendors, delivery

app = FastAPI(
    title="Dhivashi Backend API",
    description="Agentic-first backend for the Maldives Dhivashi platform.",
    version="0.1.0",
)

# CORS middleware for Next.js frontend and Flutter apps
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(orders.router)
app.include_router(vendors.router)
app.include_router(delivery.router)

@app.get("/")
def root():
    return {"message": "Welcome to Dhivashi API (Phase 0 MVP)"}

@app.get("/health")
def health_check():
    return {"status": "ok", "components": ["fastapi", "langgraph_stubs"]}

# To run locally: uvicorn backend.api.main:app --reload
