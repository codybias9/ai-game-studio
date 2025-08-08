from fastapi import FastAPI
import uvicorn

app = FastAPI()

@app.get("/healthz")
def health():
    return {"ok": True, "service": "proto-orchestrator"}

# TODO: enqueue prototype jobs by strategy and write artifact links

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
