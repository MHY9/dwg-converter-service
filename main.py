from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.responses import PlainTextResponse
import subprocess
import tempfile
import os

app = FastAPI()

@app.get("/")
def health():
    return {"status": "ok", "service": "DWG to DXF Converter"}

@app.post("/convert", response_class=PlainTextResponse)
async def convert_dwg_to_dxf(file: UploadFile = File(...)):
    if not file.filename.lower().endswith(".dwg"):
        raise HTTPException(status_code=400, detail="Sadece .dwg dosyaları kabul edilir.")
    
    with tempfile.TemporaryDirectory() as tmpdir:
        input_dwg = os.path.join(tmpdir, "input.dwg")
        output_dxf = os.path.join(tmpdir, "output.dxf")
        
        with open(input_dwg, "wb") as f:
            f.write(await file.read())
        
        # -o parametresini girdi dosyasından önce veriyoruz
        result = subprocess.run(
            ["dwg2dxf", "-y", "-v0", "-o", output_dxf, input_dwg],
            capture_output=True,
            text=True
        )
        
        if not os.path.exists(output_dxf):
            raise HTTPException(
                status_code=500, 
                detail=f"Dönüştürme başarısız: {result.stderr or result.stdout}"
            )
        
        with open(output_dxf, "r", encoding="utf-8", errors="ignore") as f:
            dxf_content = f.read()
            
        return dxf_content
