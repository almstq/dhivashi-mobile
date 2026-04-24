from typing import Dict, Any
from backend.agents.audit import log_agent_workflow
from langsmith import traceable

@traceable(run_type="chain", name="Order Routing Agent")
def route_order(order_id: str, shop_location: dict, dropoff_location: dict) -> Dict[str, Any]:
    """
    Agent stub: Determines the best routing for an order.
    """
    input_data = {
        "order_id": order_id,
        "shop_location": shop_location,
        "dropoff_location": dropoff_location
    }
    
    decision = "dhivashi_fleet"
    confidence = 0.85
    estimated_time = "15m"
    
    output_data = {
        "assigned_tier": decision,
        "estimated_time": estimated_time
    }
    
    log_agent_workflow("order_routing", input_data, output_data, confidence)
    return output_data
