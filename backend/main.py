from fastapi import FastAPI, Body
from fastapi.middleware.cors import CORSMiddleware
from database import collection
from bson import ObjectId

app = FastAPI()

# Enable CORS so React can talk to the Python API
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/items")
async def get_items():
    items = []
    cursor = collection.find({})
    async for document in cursor:
        document["_id"] = str(document["_id"])
        items.append(document)
    return items

@app.post("/items")
async def create_item(item: dict = Body(...)):
    new_item = await collection.insert_one(item)
    return {"id": str(new_item.inserted_id)}