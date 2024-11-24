from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import joblib
import pandas as pd
from fastapi.middleware.cors import CORSMiddleware
import uvicorn

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"],  
    allow_headers=["*"],  
)

model_pipeline = joblib.load("car_price_model.pkl")

class CarDetails(BaseModel):
    Prod_year: int
    Mileage: int
    Cylinders: int
    Engine_volume: float
    Manufacturer: str
    Model: str
    Category: str
    Leather_interior: str
    Fuel_type: str
    Gear_box_type: str
    Drive_wheels: str

@app.get("/")
async def root():
    return {"message": "Welcome to the Car Price Prediction API!"}

@app.post("/predict/")
async def predict_car_price(car_details: CarDetails):
    try:
        # Validate numeric ranges
        if not (1900 <= car_details.Prod_year <= 2024): 
            raise HTTPException(status_code=400, detail="Prod_year must be between 1900 and 2024.")
        if not (0 <= car_details.Mileage <= 1_000_000):  
            raise HTTPException(status_code=400, detail="Mileage must be between 0 and 1,000,000.")
        if not (1 <= car_details.Cylinders <= 16):  
            raise HTTPException(status_code=400, detail="Cylinders must be between 1 and 16.")
        if not (0.1 <= car_details.Engine_volume <= 8.0): 
            raise HTTPException(status_code=400, detail="Engine_volume must be between 0.1 and 8.0 liters.")

        # Convert input to a DataFrame
        input_data = pd.DataFrame([car_details.dict()])

        input_data = input_data.rename(columns={
            'Prod_year': 'Prod. year',
            'Fuel_type': 'Fuel type',
            'Gear_box_type': 'Gear box type',
            'Leather_interior': 'Leather interior',
            'Engine_volume': 'Engine volume',
            'Drive_wheels': 'Drive wheels'
        })

        required_columns = ['Prod. year', 'Mileage', 'Cylinders', 'Engine volume', 'Manufacturer', 
                            'Model', 'Category', 'Leather interior', 'Fuel type', 'Gear box type', 'Drive wheels']
        
        missing_columns = set(required_columns) - set(input_data.columns)
        if missing_columns:
            raise HTTPException(status_code=400, detail=f"Missing columns: {', '.join(missing_columns)}")

        # Predict using the pipeline
        predicted_price = model_pipeline.predict(input_data)[0]
        return {"predicted_price": round(predicted_price, 2)}
    
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000, reload=True)
