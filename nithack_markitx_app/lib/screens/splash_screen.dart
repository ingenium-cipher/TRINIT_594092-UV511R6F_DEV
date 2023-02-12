import 'package:flutter/material.dart';
import 'package:nithack_marketx_app/screens/home_screen.dart';
import 'package:nithack_marketx_app/utilities/assets_name.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff181a20),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Image.asset(PngAssets.splashImage1),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: GestureDetector(
                  child: Image.asset(PngAssets.logo),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
