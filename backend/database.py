from motor.motor_asyncio import AsyncIOMotorClient
import os

# Update this URI if your MongoDB is hosted elsewhere (e.g., MongoDB Atlas)
MONGODB_URL = "mongodb://localhost:27017"

client = AsyncIOMotorClient(MONGODB_URL)
database = client.my_app_db
collection = database.get_collection("items_collection")