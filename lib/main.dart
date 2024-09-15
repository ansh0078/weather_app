import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/pages/help_screen.dart';
import 'package:weather_app/provider/weather_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => WeatherProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Colors.blueAccent),
      ),
      home: const HelpScreen(),
    );
  }
}
