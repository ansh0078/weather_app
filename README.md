#Description
Weather App is a simple Flutter application that displays weather information for a specified location. The app features a splash screen that allows users to skip to the main page and provides an interface for entering and saving location data. The app also fetches and displays current weather conditions.

##Features
Splash screen with a slide-to-skip feature.
Main page with a location input field.
Displays weather data including temperature and condition.
Option to save or update location data.

###Usage
Splash Screen: Upon launching the app, you'll see a splash screen with an image and a slide-to-skip button. You can either wait for 5 seconds for the splash screen to disappear or slide the button to skip directly to the main page.
Main Page: Enter a location name in the text field and either save or update the location. The app will display the weather information for the entered location. If no location is entered, the app will automatically fetch weather data based on the saved location after 30 seconds.

####Code Overview
HelpScreen Class: This is a StatelessWidget that displays the splash screen. It uses a FutureBuilder to wait for 5 seconds before navigating to the HomePage or immediately navigating if the slide-to-skip button is used.
HomePage Class: This is a StatefulWidget that provides the main user interface. It includes a TextField for entering a location, a button for saving/updating the location, and displays weather information retrieved from the WeatherProvider.