from fastapi import FastAPI
import uvicorn

app = FastAPI()

@app.get("/healthz")
def health():
    return {"ok": True, "service":"gene-sampler"}

# TODO: implement real endpoints per spec.

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
