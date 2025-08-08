# Minimal stub; replace with full ingestion pipeline from spec.
from fastapi import FastAPI
import uvicorn

app = FastAPI()

@app.get("/healthz")
def health():
    return {"ok": True, "service": "trend-scout"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
