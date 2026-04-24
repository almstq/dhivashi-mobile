from backend.api.database import get_supabase
import json

def log_agent_workflow(name: str, input_data: dict, output_data: dict, confidence: float):
    """
    Logs every agent decision with inputs, outputs, and confidence into the agent_workflows table.
    """
    supabase = get_supabase()
    
    # We use service role key for backend agent writes if RLS is enabled
    data = {
        "name": name,
        "input": input_data,
        "output": output_data,
        "confidence": confidence,
        "audit_log": {"source": "fastapi_backend", "status": "executed"}
    }
    
    response = supabase.table("agent_workflows").insert(data).execute()
    return response.data
