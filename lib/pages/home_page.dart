import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/config/primaryBtn.dart';
import 'package:weather_app/provider/weather_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final TextEditingController locationController = TextEditingController();
  late WeatherProvider weatherProvider;
  bool autoFetchTriggered = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 30), () {
        if (!autoFetchTriggered && locationController.text.isEmpty) {
          autoFetchTriggered = true;
          weatherProvider.showFetchDialog(context);
          fetchWeatherDataWithLocation();
        }
      });
    });
  }

  void fetchWeatherDataWithLocation() {
    weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    weatherProvider.fetchWeatherDataWithLocation();
  }

  @override
  Widget build(BuildContext context) {
    weatherProvider = Provider.of<WeatherProvider>(context);
    if (weatherProvider.locationName.isNotEmpty && locationController.text.isEmpty) {
      locationController.text = weatherProvider.locationName;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Weather App'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Enter location name',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrimaryBtn(
                    btnName: weatherProvider.isLocationSaved ? 'Update' : 'Save',
                    ontap: () {
                      if (locationController.text.isEmpty) {
                        weatherProvider.saveLocation('');
                      } else {
                        weatherProvider.saveLocation(locationController.text);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              if (weatherProvider.isError)
                Text(
                  weatherProvider.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              if (weatherProvider.temperature.isNotEmpty)
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.shade100,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.shade100.withOpacity(.5),
                        offset: const Offset(0, 25),
                        blurRadius: 10,
                        spreadRadius: -12,
                      ),
                    ],
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: -60,
                        left: -20,
                        child: Row(
                          children: [
                            if (weatherProvider.iconUrl.isNotEmpty)
                              Image.network(
                                weatherProvider.iconUrl,
                                fit: BoxFit.fill,
                                height: 170,
                                width: 170,
                              ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Text(
                          'Condition: ${weatherProvider.condition}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        top: 20,
                        child: Text(
                          '${weatherProvider.temperature}°C',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: Colors.white,
                              ),
                        ),
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
