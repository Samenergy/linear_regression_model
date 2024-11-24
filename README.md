
# Car Price Prediction using Flutter, FastAPI, and Machine Learning

This project predicts car prices based on a set of input features using a **Random Forest Regression** model. The backend is developed using **FastAPI** and serves the machine learning model. The frontend is built using **Flutter** to interact with the backend and display the predicted car price.

## Project Structure

```
linear_regression_model/
│
├── summative/
│   ├── linear_regression/
│   │   ├── Carprice.ipynb         # Jupyter notebook for training the model 
│
│   ├── API/
│   │   ├── app.py                 # FastAPI backend for serving the model
│   │   ├── requirements.txt       # Required Python dependencies for the API
│   │   ├── car_price_model.pkl    # Trained Random Forest Regression model
│
│   ├── FlutterApp/
│   │   ├── carpriceapp            # Flutter app for user interaction and API requests
```

## Demonstration Video

Watch the full demonstration of how the application works:  
[![Car Price Prediction Demo](https://e7.pngegg.com/pngimages/496/939/png-clipart-youtube-logo-youtube-play-button-computer-icons-icon-library-video-play-miscellaneous-angle-thumbnail.png)](https://vimeo.com/1032811199?share=copy)


## Getting Started

### 1. **Machine Learning Model**

The machine learning model used in this project is a **Random Forest Regression** model, which predicts the price of cars based on various input features.

#### Model File:
The trained model is saved as `car_price_model.pkl` in the `API/` folder. This model is loaded by the FastAPI backend to make predictions based on the input features provided by the Flutter app.

#### Model Input Features:

The following features will be used by the model for predicting the car price:

```json
{
  "Prod_year": 0,
  "Mileage": 0,
  "Cylinders": 0,
  "Engine_volume": 0,
  "Manufacturer": "string",
  "Model": "string",
  "Category": "string",
  "Leather_interior": "string",
  "Fuel_type": "string",
  "Gear_box_type": "string",
  "Drive_wheels": "string"
}
```

- **Prod_year**: Year the car was produced
- **Mileage**: Number of kilometers the car has been driven
- **Cylinders**: Number of engine cylinders
- **Engine_volume**: Volume of the engine (e.g., in liters)
- **Manufacturer**: The car manufacturer (e.g., "Toyota")
- **Model**: The specific model of the car
- **Category**: The type of car (e.g., "SUV", "Sedan")
- **Leather_interior**: Whether the car has leather seats ("Yes" or "No")
- **Fuel_type**: Type of fuel the car uses (e.g., "Petrol", "Diesel")
- **Gear_box_type**: Type of gearbox (e.g., "Manual", "Automatic")
- **Drive_wheels**: Type of drive wheels (e.g., "Front", "Rear", "All")

### 2. **API Backend with FastAPI**

The backend, developed using **FastAPI**, serves the Random Forest model for car price prediction.

#### Setup FastAPI:

1. Navigate to the `API/` folder.
2. Install dependencies:

   ```
   pip install -r requirements.txt
   ```

3. Run the FastAPI app:

   ```
   uvicorn app:app --reload
   ```

   The API will be available at `https://linear-regression-model-286l.onrender.com/docs`.

4. The backend provides an endpoint to predict the car price based on the input features:

   - **POST `/predict`**: Takes in a JSON body with the car features and returns the predicted car price.

   Example Request:

   ```json
   {
     "Prod_year": 2015,
     "Mileage": 120000,
     "Cylinders": 4,
     "Engine_volume": 1.8,
     "Manufacturer": "Toyota",
     "Model": "Corolla",
     "Category": "Sedan",
     "Leather_interior": "Yes",
     "Fuel_type": "Petrol",
     "Gear_box_type": "Automatic",
     "Drive_wheels": "Front"
   }
   ```

   Example Response:

   ```json
   {
     "predicted_price": 15000.0
   }
   ```

### 3. **Flutter Frontend**

The Flutter application is located in the `FlutterApp/carpriceapp/` folder. It provides a user-friendly interface to collect car details from the user and send them to the FastAPI backend for prediction.

#### Setup Flutter:

1. Ensure that **Flutter** is installed on your system.
2. Navigate to the `FlutterApp/carpriceapp/` folder.
3. Run the app:

   ```
   flutter run
   ```

4. The app will prompt the user to enter details about the car, and once the user submits the form, it will send the data to the FastAPI backend to get the predicted car price.

5. The frontend is available at: [Car Price Prediction App](https://carpriceprediction-699d6.web.app/)

### 4. **Model Deployment**

Once the FastAPI server is running and the machine learning model is loaded, the Flutter app can make predictions in real-time by interacting with the API.

The backend is fully integrated with the trained Random Forest Regression model (`car_price_model.pkl`), allowing the Flutter app to fetch predicted car prices based on user inputs.

## Features

- **Random Forest Regression** model for car price prediction.
- **FastAPI** backend for efficient and fast predictions.
- **Flutter** frontend for a responsive user interface.
- Real-time prediction of car prices using various car features.

## Dependencies

### FastAPI (Backend)
- FastAPI
- Uvicorn
- scikit-learn
- numpy
- pandas

### Flutter (Frontend)
- Flutter SDK
- HTTP package for API interaction

## Conclusion

This project combines **machine learning**, **FastAPI**, and **Flutter** to predict car prices based on various car features. It provides an easy-to-use frontend, a robust backend for model predictions, and integrates seamlessly with a trained **Random Forest Regression** model to deliver car price predictions efficiently.

---

Feel free to reach out if you need more information or have any questions!
