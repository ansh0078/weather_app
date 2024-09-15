import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:weather_app/pages/home_page.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 5)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    "assets/bgimage.png",
                    fit: BoxFit.fill,
                    height: 400,
                    width: 250,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 140),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "We show weather for you",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const Spacer(),
                      SlideAction(
                        height: 55,
                        text: " Slide To Skip",
                        innerColor: Colors.orangeAccent,
                        outerColor: Theme.of(context).colorScheme.primary,
                        onSubmit: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                        ),
                        sliderButtonIcon: const Icon(
                          Icons.arrow_forward_rounded,
                          size: 10,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return const HomePage();
        }
      },
    );
  }
}
