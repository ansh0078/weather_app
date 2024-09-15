import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WeatherProvider with ChangeNotifier {
  String locationName = '';
  String temperature = '';
  String condition = '';
  String iconUrl = '';
  bool isLocationSaved = false;
  bool isError = false;
  String errorMessage = '';

  String get locationName_ => locationName;
  String get temperature_ => temperature;
  String get condition_ => condition;
  String get iconUrl_ => iconUrl;
  bool get isLocationSaved_ => isLocationSaved;
  bool get isError_ => isError;
  String get errorMessage_ => errorMessage;

  WeatherProvider() {
    loadSavedLocation();
  }

  void loadSavedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLocation = prefs.getString('locationName');
    if (savedLocation != null && savedLocation.isNotEmpty) {
      locationName = savedLocation;
      isLocationSaved = true;
      await fetchWeatherData(locationName);
    } else {
      await fetchWeatherDataWithLocation();
    }
  }

  Future<void> fetchWeatherDataWithLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      isError = true;
      errorMessage = 'Location services are disabled.';
      notifyListeners();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        isError = true;
        errorMessage = 'Location permission denied.';
        notifyListeners();
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      String location = '${position.latitude},${position.longitude}';
      locationName = location;
      await fetchWeatherData(location);
    } catch (e) {
      isError = true;
      errorMessage = 'Unable to get GPS location.';
      notifyListeners();
    }
  }

  Future<void> fetchWeatherData(String location) async {
    String apiKey = 'acd2b8aec0054921ad8113952241509';
    String apiUrl = 'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$location';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      temperature = data['current']['temp_c'].toString();
      condition = data['current']['condition']['text'];
      iconUrl = "https:" + data['current']['condition']['icon'];
      isError = false;
    } else {
      temperature = '';
      condition = '';
      iconUrl = '';
      isError = true;
      errorMessage = 'This location does not exist.';
    }
    notifyListeners();
  }

  Future<void> saveLocation(String location) async {
    if (location.isEmpty) {
      isError = true;
      errorMessage = 'Please enter a location.';
      notifyListeners();
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('locationName', location);
    locationName = location;
    isLocationSaved = true;
    notifyListeners();
    await fetchWeatherData(location);
  }
  
  Future<void> showFetchDialog(BuildContext context) async {
  if (context.mounted) {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Fetching GPS Location'),
          content: const Text('Your location will be fetched automatically since no location was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
}

