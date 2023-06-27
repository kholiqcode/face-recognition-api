import numpy as np
import cv2

from fastapi import FastAPI, UploadFile, File
import face_recognition
from starlette.middleware.cors import CORSMiddleware

app = FastAPI(
    title="Face Recognition API",
    description="Face Recognition API",
    version="0.0.1",
    contact={
        "name": "Abdul Kholiq",
        "url": "http://stack.co.id/",
    })
app.add_middleware(
    CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"]
)


@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.post("/recognition", description="Face Detection")
async def recognition(known: UploadFile | None = File(None, description="Upload Original Image"), unknown: UploadFile | None = File(None, description="Upload Unknown Image")):
    try:
        known_contents = await known.read()
        known_array = np.fromstring(known_contents, np.uint8)
        known_image = cv2.imdecode(known_array, cv2.IMREAD_COLOR)
        known_locations = face_recognition.face_locations(known_image)
        known_encodings = face_recognition.face_encodings(known_image, known_locations)[0]
        
        unknown_contents = await unknown.read()
        unknown_array = np.fromstring(unknown_contents, np.uint8)
        unknown_image = cv2.imdecode(unknown_array, cv2.IMREAD_COLOR)
        unknown_locations = face_recognition.face_locations(unknown_image)
        unknown_encodings = face_recognition.face_encodings(unknown_image, unknown_locations)[0]
        
        results = face_recognition.compare_faces([known_encodings], unknown_encodings)
    
        if results[0] == True:
            return {"result": 1}
        else:
            return {"result": 0}
    except Exception as e:
        return {"error": str(e)}