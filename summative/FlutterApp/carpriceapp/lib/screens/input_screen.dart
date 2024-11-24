import 'package:flutter/material.dart';
import 'result_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const CarInputApp());
}

class CarInputApp extends StatelessWidget {
  const CarInputApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CarInputScreen(),
    );
  }
}

class CarInputScreen extends StatefulWidget {
  const CarInputScreen({super.key});

  @override
  _CarInputScreenState createState() => _CarInputScreenState();
}

class _CarInputScreenState extends State<CarInputScreen> {
  final TextEditingController productionYearController =
      TextEditingController();
  final TextEditingController mileageController = TextEditingController();
  final TextEditingController manufacturerController = TextEditingController();
  final TextEditingController modelController = TextEditingController();

  final TextEditingController cylindersController = TextEditingController();
  final TextEditingController engineVolumeController = TextEditingController();

  String? selectedCategory;
  String? selectedLeatherInterior = "Yes";
  String? selectedFuelType;
  String? selectedGearBoxType;
  String? selectedDriveWheels;

  final categories = [
    "Jeep",
    "Hatchback",
    "Sedan",
    "SUV",
    "Convertible",
    "Coupe",
    "Pickup Truck",
    "Minivan",
    "Roadster",
    "Wagon",
    "Crossover",
    "Luxury Car",
    "Sports Car",
    "Diesel",
    "Hybrid",
    "Electric",
    "Off-Road Vehicle",
    "Compact Car",
    "Subcompact Car",
    "Microcar",
    "Van",
    "Commercial Vehicle",
    "Heavy-Duty Truck",
    "Classic Car",
    "Muscle Car"
  ];
  final leatherInteriorOptions = ["Yes", "No"];
  final fuelTypes = ["Hybrid", "Petrol", "Diesel", "Electric"];
  final gearBoxTypes = ["Automatic", "Tiptronic", "Variator", "Manual"];
  final driveWheels = ["4x4", "Front", "Rear"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle back navigation
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Predict Your Car Price!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField("Production Year", productionYearController),
              _buildTextField("Mileage", mileageController),
              _buildTextField("Manufacturer", manufacturerController),
              _buildTextField("Cylinders", cylindersController),
              _buildTextField("Model", modelController),
              _buildTextField("Engine Volume", engineVolumeController),
              _buildDropdown("Category", categories, selectedCategory, (value) {
                setState(() {
                  selectedCategory = value;
                });
              }),
              _buildDropdown("Leather Interior", leatherInteriorOptions,
                  selectedLeatherInterior, (value) {
                setState(() {
                  selectedLeatherInterior = value;
                });
              }),
              _buildDropdown("Fuel Type", fuelTypes, selectedFuelType, (value) {
                setState(() {
                  selectedFuelType = value;
                });
              }),
              _buildDropdown("Gearbox Type", gearBoxTypes, selectedGearBoxType,
                  (value) {
                setState(() {
                  selectedGearBoxType = value;
                });
              }),
              _buildDropdown("Drive Wheels", driveWheels, selectedDriveWheels,
                  (value) {
                setState(() {
                  selectedDriveWheels = value;
                });
              }),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Collect user input and send for prediction
                    _handlePrediction(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Predict",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? selectedItem,
      void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: selectedItem,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  void _handlePrediction(BuildContext context) async {
    final carDetails = {
      "Prod_year": int.tryParse(productionYearController.text) ?? 0,
      "Mileage": int.tryParse(mileageController.text) ?? 0,
      "Cylinders": int.tryParse(cylindersController.text) ?? 0,
      "Engine_volume": double.tryParse(engineVolumeController.text) ?? 0.0,
      "Manufacturer": manufacturerController.text,
      "Category": selectedCategory,
      "Model": modelController.text,
      "Leather_interior": selectedLeatherInterior,
      "Fuel_type": selectedFuelType,
      "Gear_box_type": selectedGearBoxType,
      "Drive_wheels": selectedDriveWheels,
    };

    try {
      final url = Uri.parse('https://linear-regression-model-286l.onrender.com/predict/');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(carDetails),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final predictedPrice = responseData['predicted_price'].toString();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarPriceScreen(
              price: predictedPrice,
              carDetails: carDetails
                  .map((key, value) => MapEntry(key, value.toString())),
            ),
          ),
        );
      } else {
        throw Exception("Failed to fetch prediction: ${response.body}");
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: Text(error.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }
}
